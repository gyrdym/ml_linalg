import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/norm.dart';
import 'package:ml_linalg/src/vector/common/simd_helper.dart';
import 'package:ml_linalg/src/vector/common/typed_list_factory.dart';
import 'package:ml_linalg/src/vector/common/vector_data_store.dart';
import 'package:ml_linalg/vector.dart';
import 'package:quiver/core.dart';

abstract class BaseVector<E, S extends List<E>> with IterableMixin<double>
    implements Vector, VectorDataStore<E, S> {

  BaseVector.from(
    Iterable<double> source,
    this._bucketSize,
    this.isMutable,
    this._typedListFactory,
    this._simdHelper,
  ) : length = source.length {
    data = _convertCollectionToSIMDList(source.toList(growable: false));
  }

  BaseVector.randomFilled(
    this.length,
    int seed,
    this._bucketSize,
    this.isMutable,
    this._typedListFactory,
    this._simdHelper,
  ) {
    final random = math.Random(seed);
    final source = List<double>.generate(length, (_) => random.nextDouble());
    data = _convertCollectionToSIMDList(source);
  }

  BaseVector.filled(
    this.length,
    double value,
    this._bucketSize,
    this.isMutable,
    this._typedListFactory,
    this._simdHelper,
  ) {
    final source = List<double>.filled(length, value);
    data = _convertCollectionToSIMDList(source);
  }

  BaseVector.zero(
    this.length,
    this._bucketSize,
    this.isMutable,
    this._typedListFactory,
    this._simdHelper,
  ) {
    final source = List<double>.filled(length, 0.0);
    data = _convertCollectionToSIMDList(source);
  }

  BaseVector.fromSimdList(
    S source,
    this.length,
    this._bucketSize,
    this.isMutable,
    this._typedListFactory,
    this._simdHelper,
  ) {
    data = source;
  }

  @override
  Iterator<double> get iterator =>
      _typedListFactory.createIterator((data as TypedData).buffer, length);

  @override
  final int length;

  @override
  final Type dtype = Float32x4;

  @override
  final bool isMutable;

  final int _bucketSize;
  final SimdHelper<E, S> _simdHelper;
  final TypedListFactory _typedListFactory;

  @override
  S data;

  S get _dataWithoutLastBucket => _simdHelper.sublist(data, 0, data.length - 1);

  bool get _isLastBucketNotFull => length % _bucketSize > 0;

  // Vector's cache TODO: move to cache manager
  final Map<Norm, double> _cachedNorms = {};
  double _maxValue;
  double _minValue;
  Vector _normalized;
  Vector _rescaled;
  Vector _unique;
  Vector _abs;
  double _sum;
  int _hash;
  // ------------

  @override
  bool operator ==(Object obj) {
    if (obj is Vector) {
      // TODO: consider checking hashcode here to compare two vectors
      if (length != obj.length) {
        return false;
      }
      for (int i = 0; i < data.length; i++) {
        if (!_simdHelper.areValuesEqual(
            data[i], (obj as VectorDataStore<E, S>).data[i])) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  @override
  int get hashCode => _hash ??= hashObjects(data);

  @override
  Vector operator +(Object value) {
    if (value is Vector) {
      return _elementWiseVectorOperation(value, _simdHelper.sum);
    } else if (value is Matrix) {
      final other = value.toVector();
      return _elementWiseVectorOperation(other, _simdHelper.sum);
    } else if (value is num) {
      return _elementWiseSimdScalarOperation(
          _simdHelper.createFilled(value.toDouble()), _simdHelper.sum);
    }
    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Vector operator -(Object value) {
    if (value is Vector) {
      return _elementWiseVectorOperation(value, _simdHelper.sub);
    } else if (value is Matrix) {
      final other = value.toVector();
      return _elementWiseVectorOperation(other, _simdHelper.sub);
    } else if (value is num) {
      return _elementWiseSimdScalarOperation(
          _simdHelper.createFilled(value.toDouble()), _simdHelper.sub);
    }
    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Vector operator *(Object value) {
    if (value is Vector) {
      return _elementWiseVectorOperation(value, _simdHelper.mul);
    } else if (value is Matrix) {
      return _matrixMul(value);
    } else if (value is num) {
      return _elementWiseFloatScalarOperation(value.toDouble(),
          _simdHelper.scale);
    }
    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Vector operator /(Object value) {
    if (value is Vector) {
      return _elementWiseVectorOperation(value, _simdHelper.div);
    } else if (value is num) {
      return _elementWiseFloatScalarOperation(1 / value, _simdHelper.scale);
    }
    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Vector toIntegerPower(int power) => _elementWisePow(power);

  /// Returns a vector filled with absolute values of an each component of
  /// [this] vector
  @override
  Vector abs() =>
      _abs ??= _elementWiseSelfOperation((E element, [int i]) =>
          _simdHelper.abs(element));

  @override
  double dot(Vector vector) => (this * vector).sum();

  /// Returns sum of all vector components
  @override
  double sum() => _sum ??= _simdHelper.sumLanes(data.reduce(_simdHelper.sum));

  @override
  double distanceTo(Vector vector, [Norm norm = Norm.euclidean]) =>
      (this - vector).norm(norm);

  @override
  double mean() => sum() / length;

  @override
  double norm([Norm norm = Norm.euclidean]) {
    if (!_cachedNorms.containsKey(norm)) {
      final power = _getPowerByNormType(norm);
      if (power == 1) {
        return abs().sum();
      }
      _cachedNorms[norm] = math.pow(toIntegerPower(power)
          .sum(), 1 / power) as double;
    }
    return _cachedNorms[norm];
  }

  @override
  double max() {
    if (_maxValue == null) {
      if (_isLastBucketNotFull) {
        var max = -double.infinity;
        final listOnlyWithFullBuckets = _dataWithoutLastBucket;
        if (listOnlyWithFullBuckets.isNotEmpty) {
          max = _simdHelper.getMaxLane(listOnlyWithFullBuckets
              .reduce(_simdHelper.selectMax));
        }
        _maxValue = _simdHelper.toList(data.last)
            .take(length % _bucketSize)
            .fold(max, math.max);
      } else {
        _maxValue = _simdHelper.getMaxLane(data.reduce(_simdHelper.selectMax));
      }
    }
    return _maxValue;
  }

  @override
  double min() {
    if (_minValue == null) {
      if (_isLastBucketNotFull) {
        var min = double.infinity;
        final listOnlyWithFullBuckets = _dataWithoutLastBucket;
        if (listOnlyWithFullBuckets.isNotEmpty) {
          min = _simdHelper.getMinLane(listOnlyWithFullBuckets
              .reduce(_simdHelper.selectMin));
        }
        _minValue = _simdHelper.toList(data.last)
            .take(length % _bucketSize)
            .fold(min, math.min);
      } else {
        _minValue = _simdHelper.getMinLane(data.reduce(_simdHelper.selectMin));
      }
    }
    return _minValue;
  }

  @override
  Vector query(Iterable<int> indexes) {
    final list = _typedListFactory.empty(indexes.length);
    int i = 0;
    for (final idx in indexes) {
      list[i++] = this[idx];
    }
    return Vector.from(list, dtype: dtype);
  }

  @override
  Vector unique() {
    if (_unique == null) {
      final unique = <double>[];
      for (int i = 0; i < length; i++) {
        final el = this[i];
        if (!unique.contains(el)) {
          unique.add(el);
        }
      }
      _unique = Vector.from(unique, dtype: dtype);
    }
    return _unique;
  }

  @override
  Vector fastMap<T>(
      T mapper(T element, int offsetStartIdx, int offsetEndIdx)) {
    final list = _simdHelper.createList(data.length) as List<T>;
    for (int i = 0; i < data.length; i++) {
      final offsetStart = i * _bucketSize;
      final offsetEnd = offsetStart + _bucketSize - 1;
      list[i] =
          mapper(data[i] as T, offsetStart, math.min(offsetEnd, length - 1));
    }
    return Vector.fromSimdList(list, length, isMutable: false, dtype: dtype);
  }

  @override
  double operator [](int index) {
    if (index >= length) throw RangeError.index(index, this);
    final base = (index / _bucketSize).floor();
    final offset = index - base * _bucketSize;
    return _simdHelper.getLaneByIndex(data[base], offset);
  }

  @override
  void operator []=(int index, double value) {
    if (!isMutable) throw _dontMutateError();
    if (index >= length) throw RangeError.index(index, this);
    final base = (index / _bucketSize).floor();
    final offset = index - base * _bucketSize;
    data[base] = _simdHelper.mutate(data[base], offset, value);
    _invalidateCache();
  }

  @override
  Vector subvector(int start, [int end]) {
    final collection = _typedListFactory
        .fromBuffer((data as TypedData).buffer, start,
        (end > length ? length : end) - start);
    return Vector.from(collection, dtype: dtype);
  }

  @override
  Vector normalize([Norm normType = Norm.euclidean]) =>
      _normalized ??= this / norm(normType);

  @override
  Vector rescale() {
    if (_rescaled == null) {
      final minValue = min();
      final maxValue = max();
      _rescaled = (this - minValue) / (maxValue - minValue);
    }
    return _rescaled;
  }

  /// Returns exponent depending on vector norm type (for Euclidean norm - 2,
  /// Manhattan - 1)
  int _getPowerByNormType(Norm norm) {
    switch (norm) {
      case Norm.euclidean:
        return 2;
      case Norm.manhattan:
        return 1;
      default:
        throw UnsupportedError('Unsupported norm type!');
    }
  }

  /// Returns a SIMD value raised to the integer power
  E _simdToIntPow(E lane, int power) {
    if (power == 0) {
      return _simdHelper.createFilled(1.0);
    }

    final x = _simdToIntPow(lane, power ~/ 2);
    final sqrX = _simdHelper.mul(x, x);

    if (power % 2 == 0) {
      return sqrX;
    }

    return _simdHelper.mul(lane, sqrX);
  }

  /// Returns SIMD list (e.g. Float32x4List) as a result of converting iterable
  /// source
  ///
  /// All sequence of [collection] elements splits into groups with
  /// [_bucketSize] length
  S _convertCollectionToSIMDList(List<double> collection) {
    final numOfBuckets = (collection.length / _bucketSize).ceil();
    final source = _typedListFactory.fromList(collection);
    final target = _simdHelper.createList(numOfBuckets);

    for (int i = 0; i < numOfBuckets; i++) {
      final start = i * _bucketSize;
      final end = start + _bucketSize;
      final bucketAsList = source.sublist(start, math.min(end, source.length));
      target[i] = _simdHelper.createFromList(bucketAsList);
    }

    return target;
  }

  /// Returns a vector as a result of applying to [this] any element-wise
  /// operation with a simd value
  Vector _elementWiseFloatScalarOperation(
      double scalar, E operation(E a, double b)) {
    final list = _simdHelper.createList(data.length);
    for (int i = 0; i < data.length; i++) {
      list[i] = operation(data[i], scalar);
    }
    return Vector.fromSimdList(list, length, isMutable: false, dtype: dtype);
  }

  /// Returns a vector as a result of applying to [this] any element-wise
  /// operation with a simd value
  Vector _elementWiseSimdScalarOperation(E simdVal, E operation(E a, E b)) {
    final list = _simdHelper.createList(data.length);
    for (int i = 0; i < data.length; i++) {
      list[i] = operation(data[i], simdVal);
    }
    return Vector.fromSimdList(list, length, isMutable: false, dtype: dtype);
  }

  /// Returns a vector as a result of applying to [this] any element-wise
  /// operation with a vector (e.g. vector addition)
  Vector _elementWiseVectorOperation(Vector vector, E operation(E a, E b)) {
    if (vector.length != length) throw _mismatchLengthError();
    final list = _simdHelper.createList(data.length);
    for (int i = 0; i < data.length; i++) {
      list[i] = operation(data[i], (vector as VectorDataStore<E, S>).data[i]);
    }
    return Vector.fromSimdList(list, length, isMutable: false, dtype: dtype);
  }

  Vector _elementWiseSelfOperation(E operation(E element, [int index])) {
    final list = _simdHelper.createList(data.length);
    for (int i = 0; i < data.length; i++) {
      list[i] = operation(data[i], i);
    }
    return Vector.fromSimdList(list, length, isMutable: false, dtype: dtype);
  }

  /// Returns a vector as a result of applying to [this] element-wise raising
  /// to the integer power
  Vector _elementWisePow(int exp) {
    final list = _simdHelper.createList(data.length);
    for (int i = 0; i < data.length; i++) {
      list[i] = _simdToIntPow(data[i], exp);
    }
    return Vector.fromSimdList(list, length, isMutable: false, dtype: dtype);
  }

  Vector _matrixMul(Matrix matrix) {
    if (length != matrix.rowsNum) {
      throw Exception(
          'Multiplication by a matrix with diffrent number of rows than the '
              'vector length is not allowed: vector length: $length, matrix '
              'row number: ${matrix.rowsNum}');
    }
    final source = List<double>.generate(
        matrix.columnsNum, (int i) => dot(matrix.getColumn(i)));
    return Vector.from(source, dtype: dtype);
  }

  void _invalidateCache() {
    _maxValue = null;
    _minValue = null;
    _normalized = null;
    _rescaled = null;
    _unique = null;
    _abs = null;
    _sum = null;
    _cachedNorms.clear();
  }

  UnsupportedError _dontMutateError() =>
      UnsupportedError('mutation operations unsupported for immutable vectors');

  RangeError _mismatchLengthError() =>
      RangeError('Vectors length must be equal');
}
