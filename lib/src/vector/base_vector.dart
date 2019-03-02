import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/norm.dart';
import 'package:ml_linalg/src/vector/common/simd_helper.dart';
import 'package:ml_linalg/src/vector/common/typed_list_factory.dart';
import 'package:ml_linalg/src/vector/common/vector_data_store.dart';
import 'package:ml_linalg/vector.dart';
import 'package:quiver/core.dart';

abstract class BaseVector<E, S extends List<E>> implements Vector {
  BaseVector.from(
    Iterable<double> source,
    this.bucketSize,
    this.isMutable,
    this.typedListFactory,
    this.simdHelper,
  ) : length = source.length {
    _data = convertCollectionToSIMDList(source.toList(growable: false));
  }

  BaseVector.randomFilled(
    this.length,
    int seed,
    this.bucketSize,
    this.isMutable,
    this.typedListFactory,
    this.simdHelper,
  ) {
    final random = math.Random(seed);
    final source = List<double>.generate(length, (_) => random.nextDouble());
    _data = convertCollectionToSIMDList(source);
  }

  BaseVector.filled(
    this.length,
    double value,
    this.bucketSize,
    this.isMutable,
    this.typedListFactory,
    this.simdHelper,
  ) {
    final source = List<double>.filled(length, value);
    _data = convertCollectionToSIMDList(source);
  }

  BaseVector.zero(
    this.length,
    this.bucketSize,
    this.isMutable,
    this.typedListFactory,
    this.simdHelper,
  ) {
    final source = List<double>.filled(length, 0.0);
    _data = convertCollectionToSIMDList(source);
  }

  BaseVector.fromSimdList(
    this.length,
    this.bucketSize,
    this.isMutable,
    this.typedListFactory,
    this.simdHelper,
    S simdListFactory(),
  ) {
    final source = List<double>.filled(length, 0.0);
    _data = convertCollectionToSIMDList(source);
  }

  Iterator<double> get iterator =>
      typedListFactory.createIterator((_data as TypedData).buffer, length);

  @override
  final int length;

  @override
  final Type dtype = Float32x4;

  @override
  final bool isMutable;

  final int bucketSize;
  final SimdHelper<E, S> simdHelper;
  final TypedListFactory typedListFactory;

  S _data;

  S get dataWithoutLastBucket => simdHelper.sublist(_data, 0, _data.length - 1);

  bool get _isLastBucketNotFull => length % bucketSize > 0;

  @override
  bool operator ==(Object obj) {
    if (obj is Vector) {
      // TODO: consider checking hashcode here to compare two vectors
      if (length != obj.length) {
        return false;
      }
      for (int i = 0; i < _data.length; i++) {
        if (!simdHelper.areValuesEqual(
            _data[i], (obj as VectorDataStore<E, S>).data[i])) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  @override
  int get hashCode {
    _hash ??= hashObjects(_data);
    return _hash;
  }

  int _hash;

  @override
  Vector operator +(Object value) {
    if (value is Vector) {
      return _elementWiseVectorOperation(value, simdHelper.sum);
    } else if (value is Matrix) {
      final other = value.toVector();
      return _elementWiseVectorOperation(other, simdHelper.sum);
    } else if (value is num) {
      return _elementWiseSimdScalarOperation(
          simdHelper.createFilled(value.toDouble()), simdHelper.sum);
    }
    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Vector operator -(Object value) {
    if (value is Vector) {
      return _elementWiseVectorOperation(value, simdHelper.sub);
    } else if (value is Matrix) {
      final other = value.toVector();
      return _elementWiseVectorOperation(other, simdHelper.sub);
    } else if (value is num) {
      return _elementWiseSimdScalarOperation(
          simdHelper.createFilled(value.toDouble()), simdHelper.sub);
    }
    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Vector operator *(Object value) {
    if (value is Vector) {
      return _elementWiseVectorOperation(value, simdHelper.mul);
    } else if (value is Matrix) {
      return _matrixMul(value);
    } else if (value is num) {
      return _elementWiseFloatScalarOperation(value.toDouble(),
          simdHelper.scale);
    }
    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Vector operator /(Object value) {
    if (value is Vector) {
      return _elementWiseVectorOperation(value, simdHelper.div);
    } else if (value is num) {
      return _elementWiseFloatScalarOperation(1 / value, simdHelper.scale);
    }
    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Vector toIntegerPower(int power) => _elementWisePow(power);

  /// Returns a vector filled with absolute values of an each component of
  /// [this] vector
  @override
  Vector abs() =>
      _elementWiseSelfOperation((E element, [int i]) =>
          simdHelper.abs(element));

  @override
  double dot(Vector vector) => (this * vector).sum();

  /// Returns sum of all vector components
  @override
  double sum() => simdHelper.sumLanes(_data.reduce(simdHelper.sum));

  @override
  double distanceTo(Vector vector, [Norm norm = Norm.euclidean]) =>
      (this - vector).norm(norm);

  @override
  double mean() => sum() / length;

  @override
  double norm([Norm norm = Norm.euclidean]) {
    final power = _getPowerByNormType(norm);
    if (power == 1) {
      return abs().sum();
    }
    return math.pow(toIntegerPower(power).sum(), 1 / power) as double;
  }

  @override
  double max() {
    if (_isLastBucketNotFull) {
      var max = -double.infinity;
      final listOnlyWithFullBuckets = dataWithoutLastBucket;
      if (listOnlyWithFullBuckets.isNotEmpty) {
        max = simdHelper.getMaxLane(listOnlyWithFullBuckets
            .reduce(simdHelper.selectMax));
      }
      return simdHelper.toList(_data.last)
          .take(length % bucketSize)
          .fold(max, math.max);
    } else {
      return simdHelper.getMaxLane(_data.reduce(simdHelper.selectMax));
    }
  }

  @override
  double min() {
    if (_isLastBucketNotFull) {
      var min = double.infinity;
      final listOnlyWithFullBuckets = dataWithoutLastBucket;
      if (listOnlyWithFullBuckets.isNotEmpty) {
        min = simdHelper.getMinLane(listOnlyWithFullBuckets
            .reduce(simdHelper.selectMin));
      }
      return simdHelper.toList(_data.last)
          .take(length % bucketSize)
          .fold(min, math.min);
    } else {
      return simdHelper.getMinLane(_data.reduce(simdHelper.selectMin));
    }
  }

  @override
  Vector query(Iterable<int> indexes) {
    final list = typedListFactory.empty(indexes.length);
    int i = 0;
    for (final idx in indexes) {
      list[i++] = this[idx];
    }
    return Vector.from(list, dtype: dtype);
  }

  @override
  Vector unique() {
    final unique = <double>[];
    for (int i = 0; i < length; i++) {
      final el = this[i];
      if (!unique.contains(el)) {
        unique.add(el);
      }
    }
    return Vector.from(unique, dtype: dtype);
  }

  @override
  Vector fastMap<T>(
      T mapper(T element, int offsetStartIdx, int offsetEndIdx)) {
    final list = simdHelper.createList(_data.length) as List<T>;
    for (int i = 0; i < _data.length; i++) {
      final offsetStart = i * bucketSize;
      final offsetEnd = offsetStart + bucketSize - 1;
      list[i] =
          mapper(_data[i] as T, offsetStart, math.min(offsetEnd, length - 1));
    }
    return Vector.fromSimdList(list, length, isMutable: false, dtype: dtype);
  }

  @override
  double operator [](int index) {
    if (index >= length) throw RangeError.index(index, this);
    final base = (index / bucketSize).floor();
    final offset = index - base * bucketSize;
    return simdHelper.getLaneByIndex(_data[base], offset);
  }

  @override
  void operator []=(int index, double value) {
    if (!isMutable) throw _dontMutateError();
    if (index >= length) throw RangeError.index(index, this);
    final base = (index / bucketSize).floor();
    final offset = index - base * bucketSize;
    _data[base] = simdHelper.mutate(_data[base], offset, value);
  }

  @override
  Vector subvector(int start, [int end]) {
    final collection = typedListFactory
        .fromBuffer((_data as TypedData).buffer, start,
        (end > length ? length : end) - start);
    return Vector.from(collection, dtype: dtype);
  }

  /// Returns exponent depending on vector norm type (for Euclidean norm - 2, Manhattan - 1)
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
      return simdHelper.createFilled(1.0);
    }

    final x = _simdToIntPow(lane, power ~/ 2);
    final sqrX = simdHelper.mul(x, x);

    if (power % 2 == 0) {
      return sqrX;
    }

    return simdHelper.mul(lane, sqrX);
  }

  /// Returns SIMD list (e.g. Float32x4List) as a result of converting iterable
  /// source
  ///
  /// All sequence of [collection] elements splits into groups with
  /// [_bucketSize] length
  S convertCollectionToSIMDList(List<double> collection) {
    final numOfBuckets = (collection.length / bucketSize).ceil();
    final source = typedListFactory.fromList(collection);
    final target = simdHelper.createList(numOfBuckets);

    for (int i = 0; i < numOfBuckets; i++) {
      final start = i * bucketSize;
      final end = start + bucketSize;
      final bucketAsList = source.sublist(start, math.min(end, source.length));
      target[i] = simdHelper.createFromList(bucketAsList);
    }

    return target;
  }

  /// Returns a vector as a result of applying to [this] any element-wise
  /// operation with a simd value
  Vector _elementWiseFloatScalarOperation(
      double scalar, E operation(E a, double b)) {
    final list = simdHelper.createList(_data.length);
    for (int i = 0; i < _data.length; i++) {
      list[i] = operation(_data[i], scalar);
    }
    return Vector.fromSimdList(list, length, isMutable: false, dtype: dtype);
  }

  /// Returns a vector as a result of applying to [this] any element-wise
  /// operation with a simd value
  Vector _elementWiseSimdScalarOperation(E simdVal, E operation(E a, E b)) {
    final list = simdHelper.createList(_data.length);
    for (int i = 0; i < _data.length; i++) {
      list[i] = operation(_data[i], simdVal);
    }
    return Vector.fromSimdList(list, length, isMutable: false, dtype: dtype);
  }

  /// Returns a vector as a result of applying to [this] any element-wise
  /// operation with a vector (e.g. vector addition)
  Vector _elementWiseVectorOperation(Vector vector, E operation(E a, E b)) {
    if (vector.length != length) throw _mismatchLengthError();
    final list = simdHelper.createList(_data.length);
    for (int i = 0; i < _data.length; i++) {
      list[i] = operation(_data[i], (vector as VectorDataStore<E, S>).data[i]);
    }
    return Vector.fromSimdList(list, length, isMutable: false, dtype: dtype);
  }

  Vector _elementWiseSelfOperation(E operation(E element, [int index])) {
    final list = simdHelper.createList(_data.length);
    for (int i = 0; i < _data.length; i++) {
      list[i] = operation(_data[i], i);
    }
    return Vector.fromSimdList(list, length, isMutable: false, dtype: dtype);
  }

  /// Returns a vector as a result of applying to [this] element-wise raising
  /// to the integer power
  Vector _elementWisePow(int exp) {
    final list = simdHelper.createList(_data.length);
    for (int i = 0; i < _data.length; i++) {
      list[i] = _simdToIntPow(_data[i], exp);
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

  UnsupportedError _dontMutateError() =>
      UnsupportedError('mutation operations unsupported for immutable vectors');

  RangeError _mismatchLengthError() =>
      RangeError('Vectors length must be equal');
}
