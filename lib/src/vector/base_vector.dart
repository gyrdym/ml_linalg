import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/norm.dart';
import 'package:ml_linalg/src/common/typed_list_helper/typed_list_helper.dart';
import 'package:ml_linalg/src/vector/common/simd_helper.dart';
import 'package:ml_linalg/vector.dart';

abstract class BaseVector<E, S extends List<E>> with IterableMixin<double>
    implements Vector {

  BaseVector.fromList(
    List<num> source,
    this._bytesPerElement,
    this._bucketSize,
    this._typedListHelper,
    this._simdHelper,
    this._simdExponent,
  ) :
        length = source.length,
        _numOfBuckets = _getNumOfBuckets(source.length, _bucketSize),
        _source = _getBuffer(
            _getNumOfBuckets(source.length, _bucketSize) * _bucketSize,
            _bytesPerElement) {
    _setByteData((i) => source[i]);
  }

  BaseVector.randomFilled(
    this.length,
    int seed,
    this._bytesPerElement,
    this._bucketSize,
    this._typedListHelper,
    this._simdHelper,
    this._simdExponent,
    {
      num min = 0,
      num max = 1,
    }
  ) :
        _numOfBuckets = _getNumOfBuckets(length, _bucketSize),
        _source = _getBuffer(
            _getNumOfBuckets(length, _bucketSize) * _bucketSize,
            _bytesPerElement) {
    final generator = math.Random(seed);
    final diff = (max - min).abs();
    final realMin = math.min(min, max);
    _setByteData((i) => generator.nextDouble() * diff + realMin);
  }

  BaseVector.filled(
    this.length,
    num value,
    this._bytesPerElement,
    this._bucketSize,
    this._typedListHelper,
    this._simdHelper,
    this._simdExponent,
  ) :
        _numOfBuckets = _getNumOfBuckets(length, _bucketSize),
        _source = _getBuffer(
            _getNumOfBuckets(length, _bucketSize) * _bucketSize,
            _bytesPerElement) {
    _setByteData((_) => value);
  }

  BaseVector.zero(
    this.length,
    this._bytesPerElement,
    this._bucketSize,
    this._typedListHelper,
    this._simdHelper,
    this._simdExponent,
  ) :
        _numOfBuckets = _getNumOfBuckets(length, _bucketSize),
        _source = _getBuffer(
            _getNumOfBuckets(length, _bucketSize) * _bucketSize,
            _bytesPerElement) {
    _setByteData((_) => 0.0);
  }

  BaseVector.fromSimdList(
    S data,
    this.length,
    this._bytesPerElement,
    this._bucketSize,
    this._typedListHelper,
    this._simdHelper,
    this._simdExponent,
  ) : 
        _numOfBuckets = _getNumOfBuckets(length, _bucketSize),
        _source = (data as TypedData).buffer {
    _cachedInnerSimdList = data;
  }

  static int _getNumOfBuckets(int length, int bucketSize) =>
      (length / bucketSize).ceil();

  static ByteBuffer _getBuffer(int length, int bytesPerElement) =>
      ByteData(length * bytesPerElement).buffer;

  @override
  final int length;

  final ByteBuffer _source;
  final int _bytesPerElement;
  final int _bucketSize;
  final int _numOfBuckets;
  final SimdHelper<E, S> _simdHelper;
  final TypedListHelper _typedListHelper;
  final E _simdExponent;

  @override
  Iterator<double> get iterator => _innerTypedList.iterator;

  S get _innerSimdList =>
      _cachedInnerSimdList ??= _simdHelper.getBufferAsSimdList(_source);
  S _cachedInnerSimdList;

  List<double> get _innerTypedList =>
      _cachedInnerTypedList ??= _typedListHelper
          .getBufferAsList(_source, 0, length);
  List<double> _cachedInnerTypedList;

  bool get _isLastBucketNotFull => length % _bucketSize > 0;

  // Vector's cache
  final Map<Norm, double> _cachedNorms = {};
  double _maxValue;
  double _minValue;
  Vector _normalized;
  Vector _rescaled;
  Vector _unique;
  Vector _abs;
  double _sum;
  int _hash;

  @override
  bool operator ==(Object other) {
    if (other is BaseVector<E, S>) {
      if (length != other.length) {
        return false;
      }
      for (int i = 0; i < _numOfBuckets; i++) {
        if (!_simdHelper.areValuesEqual(_innerSimdList[i],
            other._innerSimdList[i])) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  @override
  int get hashCode => _hash ??= length > 0 ? _generateHash() : 0;

  int _generateHash() {
    int i = 0;
    final simdHash = _innerSimdList.reduce((sum, element) => _simdHelper
            .sum(sum, _simdHelper.scale(element, (31 * (i++)) * 1.0)));
    return _simdHelper.sumLanesForHash(simdHash) ~/ 1;
  }

  @override
  Vector operator +(Object value) {
    if (value is Vector) {
      return _elementWiseVectorOperation(value, _simdHelper.sum);
    } else if (value is Matrix) {
      final other = value.toVector();
      return _elementWiseVectorOperation(other, _simdHelper.sum);
    } else if (value is num) {
      return _elementWiseScalarOperation<E>(
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
      return _elementWiseScalarOperation<E>(
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
      return _elementWiseScalarOperation<double>(value.toDouble(),
          _simdHelper.scale);
    }
    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Vector operator /(Object value) {
    if (value is Vector) {
      return _elementWiseVectorOperation(value, _simdHelper.div);
    } else if (value is num) {
      return _elementWiseScalarOperation<double>(1 / value, _simdHelper.scale);
    }
    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Vector sqrt() => _elementWiseSelfOperation((el, [_]) => _simdHelper.sqrt(el));

  @override
  Vector toIntegerPower(int power) => _elementWisePow(power);

  @override
  Vector abs() =>
      _abs ??= _elementWiseSelfOperation((E element, [int i]) =>
          _simdHelper.abs(element));

  @override
  double dot(Vector vector) => (this * vector).sum();

  /// Returns sum of all vector components
  @override
  double sum() => _sum ??= _simdHelper.sumLanes(_innerSimdList
      .reduce(_simdHelper.sum));

  @override
  double distanceTo(Vector other, {
    Distance distance = Distance.euclidean,
  }) {
    switch (distance) {
      case Distance.euclidean:
        return (this - other).norm(Norm.euclidean);
      case Distance.manhattan:
        return (this - other).norm(Norm.manhattan);
      case Distance.cosine:
        return 1 - getCosine(other);
      default:
        throw UnimplementedError('Unimplemented distance type - $distance');
    }
  }

  @override
  double getCosine(Vector other) {
    final cosine = (dot(other) / norm(Norm.euclidean) /
        other.norm(Norm.euclidean));
    if (cosine.isInfinite || cosine.isNaN) {
      throw Exception('It is impossible to find cosine of an angle of two '
          'vectors if at least one of the vectors is zero-vector');
    }
    return cosine;
  }

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
  double max() =>
      _maxValue ??= _findExtrema(-double.infinity, _simdHelper.getMaxLane,
          _simdHelper.selectMax, math.max);

  @override
  double min() =>
      _minValue ??= _findExtrema(double.infinity, _simdHelper.getMinLane,
          _simdHelper.selectMin, math.min);

  double _findExtrema(double initialValue, double getExtremalLane(E bucket),
      E getExtremalBucket(E first, E second),
      double getExtremalValue(double first, double second)) {
    if (_isLastBucketNotFull) {
      var extrema = initialValue;
      final fullBucketsList = _innerSimdList.take(_numOfBuckets - 1);
      if (fullBucketsList.isNotEmpty) {
        extrema = getExtremalLane(fullBucketsList.reduce(getExtremalBucket));
      }
      return _simdHelper.simdValueToList(_innerSimdList.last)
          .take(length % _bucketSize)
          .fold(extrema, getExtremalValue);
    } else {
      return getExtremalLane(_innerSimdList.reduce(getExtremalBucket));
    }
  }

  @override
  Vector sample(Iterable<int> indices) {
    final list = _typedListHelper.empty(indices.length);
    int i = 0;
    for (final idx in indices) {
      list[i++] = this[idx];
    }
    return Vector.fromList(list, dtype: dtype);
  }

  @override
  Vector unique() => _unique ??= Vector
      .fromList(Set<double>.from(this).toList(growable: false), dtype: dtype);

  @override
  Vector fastMap<T>(T mapper(T element)) {
    final source = _innerSimdList.map((value) => mapper(value as T))
        .toList(growable: false) as List<E>;
    return Vector.fromSimdList(_simdHelper.createListFrom(source), length,
        dtype: dtype);
  }

  @override
  double operator [](int index) {
    if (index >= length) throw RangeError.index(index, this);
    return _innerTypedList[index];
  }

  @override
  Vector subvector(int start, [int end]) {
    if (start < 0) {
      throw RangeError.range(start, 0, length - 1, '`start` cannot'
          ' be negative');
    }
    if (end != null && start >= end) {
      throw RangeError.range(start, 0,
          length - 1, '`start` cannot be greater than or equal to `end`');
    }
    if (start >= length) {
      throw RangeError.range(start, 0,
          length - 1, '`start` cannot be greater than or equal to the vector'
              'length');
    }
    final collection = _typedListHelper
        .getBufferAsList((_innerSimdList as TypedData).buffer, start,
        (end == null || end > length ? length : end) - start);
    return Vector.fromList(collection, dtype: dtype);
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
  E _simdToIntPow(E lane, num power) {
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

  Vector _elementWiseScalarOperation<T>(T arg, E operation(E a, T b)) {
    final source = _innerSimdList.map((value) => operation(value, arg))
        .toList(growable: false);
    return Vector.fromSimdList(_simdHelper.createListFrom(source), length,
        dtype: dtype);
  }

  /// Returns a vector as a result of applying to [this] any element-wise
  /// operation with a vector (e.g. vector addition)
  Vector _elementWiseVectorOperation(Vector arg, E operation(E a, E b)) {
    if (arg.length != length) throw _mismatchLengthError();
    final other = (arg as BaseVector<E, S>);
    final source = _simdHelper.createList(_numOfBuckets);
    for (int i = 0; i < _numOfBuckets; i++) {
      source[i] = operation(_innerSimdList[i], other._innerSimdList[i]);
    }
    return Vector.fromSimdList(source, length, dtype: dtype);
  }

  Vector _elementWiseSelfOperation(E operation(E element, [int index])) {
    final source = _innerSimdList.map(operation).toList(growable: false);
    return Vector.fromSimdList(_simdHelper.createListFrom(source), length,
        dtype: dtype);
  }

  /// Returns a vector as a result of applying to [this] element-wise raising
  /// to the integer power
  Vector _elementWisePow(int exp) {
    final source = _innerSimdList.map((value) => _simdToIntPow(value, exp))
        .toList(growable: false);
    return Vector.fromSimdList(_simdHelper.createListFrom(source), length,
        dtype: dtype);
  }

  Vector _matrixMul(Matrix matrix) {
    if (length != matrix.rowsNum) {
      throw Exception(
          'Multiplication by a matrix with diffrent number of rows than the '
              'vector length is not allowed: vector length: $length, matrix '
              'row number: ${matrix.rowsNum}');
    }
    final source = List.generate(
        matrix.columnsNum, (int i) => dot(matrix.getColumn(i)));
    return Vector.fromList(source, dtype: dtype);
  }

  void _setByteData(num generateValue(int i)) {
    final byteData = _source.asByteData();
    var byteOffset = -_bytesPerElement;
    for (int i = 0; i < length; i++) {
      _typedListHelper.setValue(byteData, byteOffset += _bytesPerElement,
          generateValue(i).toDouble());
    }
  }

  RangeError _mismatchLengthError() =>
      RangeError('Vectors length must be equal');
}
