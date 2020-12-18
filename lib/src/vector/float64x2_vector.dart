/* This file is auto generated, do not change it manually */

import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/norm.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager.dart';
import 'package:ml_linalg/src/vector/serialization/vector_to_json.dart';
import 'package:ml_linalg/src/vector/simd_helper/float64x2_helper.dart';
import 'package:ml_linalg/src/vector/vector_cache_keys.dart';
import 'package:ml_linalg/vector.dart';

const _bytesPerElement = Float64List.bytesPerElement;
const _bytesPerSimdElement = Float64x2List.bytesPerElement;
const _bucketSize = Float64x2List.bytesPerElement ~/ Float64List.bytesPerElement;
final _simdOnes = Float64x2.splat(1.0);

class Float64x2Vector with IterableMixin<double> implements Vector {
  Float64x2Vector.fromList(List<num> source, this._cacheManager) :
        length = source.length,
        _numOfBuckets = _getNumOfBuckets(source.length, _bucketSize),
        _buffer = ByteData(_getNumOfBuckets(source.length, _bucketSize) *
            _bytesPerSimdElement).buffer {
    for (var i = 0; i < length; i++) {
      _buffer.asByteData().setFloat64(_bytesPerElement * i,
        source[i].toDouble(), Endian.host);
    }
  }

  Float64x2Vector.randomFilled(this.length, int seed, this._cacheManager, {
    num min = 0, num max = 1}) :
        _numOfBuckets = _getNumOfBuckets(length, _bucketSize),
        _buffer = ByteData(_getNumOfBuckets(length, _bucketSize) *
            _bytesPerSimdElement).buffer {
    if (min >= max) {
      throw ArgumentError.value(min, 'Argument `min` should be less than `max`');
    }

    final generator = math.Random(seed);
    final diff = max - min;

    for (var i = 0; i < length; i++) {
      _buffer.asByteData().setFloat64(_bytesPerElement * i,
        generator.nextDouble() * diff + min, Endian.host);
    }
  }

  Float64x2Vector.filled(this.length, num value, this._cacheManager) :
        _numOfBuckets = _getNumOfBuckets(length, _bucketSize),
        _buffer = ByteData(_getNumOfBuckets(length, _bucketSize) *
            _bytesPerSimdElement).buffer {
    for (var i = 0; i < length; i++) {
      _buffer.asByteData().setFloat64(_bytesPerElement * i, value.toDouble(),
          Endian.host);
    }
  }

  Float64x2Vector.zero(this.length, this._cacheManager) :
        _numOfBuckets = _getNumOfBuckets(length, _bucketSize),
        _buffer = ByteData(_getNumOfBuckets(length, _bucketSize) *
            _bytesPerSimdElement).buffer;

  Float64x2Vector.fromSimdList(Float64x2List data, this.length,
      this._cacheManager) :
        _numOfBuckets = _getNumOfBuckets(length, _bucketSize),
        _buffer = data.buffer {
    _cachedInnerSimdList = data;
  }

  Float64x2Vector.empty(this._cacheManager) :
        length = 0,
        _numOfBuckets = 0,
        _buffer = ByteData(0).buffer;

  static int _getNumOfBuckets(int length, int bucketSize) =>
      (length / bucketSize).ceil();

  @override
  final int length;

  final CacheManager _cacheManager;
  final Float64x2Helper _simdHelper = const Float64x2Helper();
  final ByteBuffer _buffer;
  final int _numOfBuckets;

  @override
  Iterator<double> get iterator => _innerTypedList.iterator;

  Float64x2List get _innerSimdList =>
      _cachedInnerSimdList ??= _buffer.asFloat64x2List();
  Float64x2List _cachedInnerSimdList;

  List<double> get _innerTypedList =>
      _cachedInnerTypedList ??= _buffer.asFloat64List(0, length);
  Float64List _cachedInnerTypedList;

  bool get _isLastBucketNotFull => length % _bucketSize > 0;

  @override
  bool operator ==(Object other) {
    if (other is Float64x2Vector) {
      if (length != other.length) {
        return false;
      }
      for (var i = 0; i < _numOfBuckets; i++) {
        if (!_simdHelper.areLanesEqual(_innerSimdList[i],
            other._innerSimdList[i])) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  @override
  int get hashCode => _cacheManager.retrieveValue(vectorHashKey, () {
    if (isEmpty) {
      return 0;
    }

    var i = 0;

    final summed = _innerSimdList.reduce(
            (sum, element) => sum + element.scale((31 * (i++)) * 1.0));

    return length + _simdHelper.sumLanesForHash(summed).hashCode;
  }, skipCaching: false);

  @override
  Vector operator +(Object value) {
    if (value is Vector || value is Matrix) {
      final other = (value is Matrix ? value.toVector() : value) as Float64x2Vector;
      if (other.length != length) {
        throw _mismatchLengthError;
      }
      final source = Float64x2List(_numOfBuckets);
      for (var i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i] + other._innerSimdList[i];
      }
      return Vector.fromSimdList(source, length, dtype: dtype);

    } else if (value is num) {
      final arg = Float64x2.splat(value.toDouble());
      final source = Float64x2List(_numOfBuckets);
      for (var i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i] + arg;
      }
      return Vector.fromSimdList(source, length, dtype: dtype);
    }

    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Vector operator -(Object value) {
    if (value is Vector || value is Matrix) {
      final other = (value is Matrix ? value.toVector() : value) as Float64x2Vector;
      if (other.length != length) {
        throw _mismatchLengthError;
      }
      final source = Float64x2List(_numOfBuckets);
      for (var i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i] - other._innerSimdList[i];
      }
      return Vector.fromSimdList(source, length, dtype: dtype);

    } else if (value is num) {
      final arg = Float64x2.splat(value.toDouble());
      final source = Float64x2List(_numOfBuckets);
      for (var i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i] - arg;
      }
      return Vector.fromSimdList(source, length, dtype: dtype);
    }

    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Vector operator *(Object value) {
    if (value is Vector) {
      final other = value as Float64x2Vector;
      if (other.length != length) {
        throw _mismatchLengthError;
      }
      final source = Float64x2List(_numOfBuckets);
      for (var i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i] * other._innerSimdList[i];
      }
      return Vector.fromSimdList(source, length, dtype: dtype);
    }

    if (value is Matrix) {
      return _matrixMul(value);
    }

    if (value is num) {
      final source = Float64x2List(_numOfBuckets);
      for (var i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i].scale(value.toDouble());
      }
      return Vector.fromSimdList(source, length, dtype: dtype);
    }

    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Vector operator /(Object value) {
    if (value is Vector) {
      final other = value as Float64x2Vector;
      if (other.length != length) {
        throw _mismatchLengthError;
      }
      final source = Float64x2List(_numOfBuckets);
      for (var i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i] / other._innerSimdList[i];
      }
      return Vector.fromSimdList(source, length, dtype: dtype);

    } else if (value is num) {
      final source = Float64x2List(_numOfBuckets);
      for (var i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i].scale(1 / value);
      }
      return Vector.fromSimdList(source, length, dtype: dtype);
    }

    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Vector sqrt({bool skipCaching = false}) =>
      _cacheManager.retrieveValue(vectorSqrtKey, () {
        final source = Float64x2List(_numOfBuckets);
        for (var i = 0; i < _numOfBuckets; i++) {
          source[i] = _innerSimdList[i].sqrt();
        }
        return Vector.fromSimdList(source, length, dtype: dtype);
      }, skipCaching: skipCaching);

  @override
  Vector scalarDiv(num scalar) => this / scalar;

  @override
  Vector pow(num exponent) => _elementWisePow(exponent);

  @override
  Vector exp({bool skipCaching = false}) => _cacheManager
      .retrieveValue(vectorLogKey, () {
        final source = Float64List(length);

        for (var i = 0; i < length; i++) {
          source[i] = math.exp(_innerTypedList[i]);
        }

        return Vector.fromList(source, dtype: dtype);
      }, skipCaching: skipCaching);

  @override
  Vector log({bool skipCaching = false}) => _cacheManager
      .retrieveValue(vectorLogKey, () {
        final source = Float64List(length);
        for (var i = 0; i < length; i++) {
          source[i] = math.log(_innerTypedList[i]);
        }

        return Vector.fromList(source, dtype: dtype);
      }, skipCaching: skipCaching);

  @override
  @deprecated
  Vector toIntegerPower(int power) => pow(power);

  @override
  Vector abs({bool skipCaching = false}) =>
      _cacheManager.retrieveValue(vectorAbsKey, () {
        final source = Float64x2List(_numOfBuckets);
        for (var i = 0; i < _numOfBuckets; i++) {
          source[i] = _innerSimdList[i].abs();
        }
        return Vector.fromSimdList(source, length, dtype: dtype);
      }, skipCaching: skipCaching);

  @override
  double dot(Vector vector) => (this * vector).sum(skipCaching: true);

  @override
  double sum({bool skipCaching = false}) {
    if (isEmpty) {
      return double.nan;
    }

    return _cacheManager.retrieveValue(vectorSumKey,
            () => _simdHelper.sumLanes(_innerSimdList.reduce((a, b) => a + b)),
        skipCaching: skipCaching);
  }

  @override
  double prod({bool skipCaching = false}) =>
      _cacheManager.retrieveValue(vectorSumKey,
          _findProduct, skipCaching: skipCaching);

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
  double mean({bool skipCaching = false}) {
    if (isEmpty) {
      throw _emptyVectorException;
    }
    return _cacheManager.retrieveValue(vectorMeanKey, () => sum() / length,
        skipCaching: skipCaching);
  }

  @override
  double norm([Norm normType = Norm.euclidean, bool skipCaching = false]) =>
      _cacheManager.retrieveValue(getCacheKeyForNormByNormType(normType), () {
        final power = _getPowerByNormType(normType);
        if (power == 1) {
          return abs().sum();
        }
        return math.pow(pow(power).sum(), 1 / power) as double;
      }, skipCaching: skipCaching);

  @override
  double max({bool skipCaching = false}) =>
      _cacheManager.retrieveValue(vectorMaxKey, () =>
          _findExtrema(-double.infinity, _simdHelper.getMaxLane,
                  (a, b) => a.max(b), math.max), skipCaching: skipCaching);

  @override
  double min({bool skipCaching = false}) =>
      _cacheManager.retrieveValue(vectorMinKey, () =>
          _findExtrema(double.infinity, _simdHelper.getMinLane,
                  (a, b) => a.min(b), math.min), skipCaching: skipCaching);

  double _findProduct() {
    if (length == 0) {
      return double.nan;
    }

    if (_isLastBucketNotFull) {
      final fullBucketsList = _innerSimdList.take(_numOfBuckets - 1);
      final product = fullBucketsList.isNotEmpty
          ? fullBucketsList.reduce((result, value) => result * value)
          : _simdOnes;

      return _simdHelper.simdValueToList(_innerSimdList.last)
          .take(length % _bucketSize)
          .fold(_simdHelper.multLanes(product),
              (result, value) => result * value);
    }

    return _simdHelper.multLanes(
        _innerSimdList.reduce((result, value) => result * value));
  }

  double _findExtrema(double initialValue,
      double Function(Float64x2 bucket) getExtremalLane,
      Float64x2 Function(Float64x2 first, Float64x2 second) getExtremalBucket,
      double Function(double first, double second) getExtremalValue,
  ) {
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
    final list = Float64List(indices.length);
    var i = 0;
    for (final idx in indices) {
      list[i++] = this[idx];
    }
    return Vector.fromList(list, dtype: dtype);
  }

  @override
  Vector unique({bool skipCaching = false}) =>
      _cacheManager.retrieveValue(vectorUniqueKey, () => Vector.fromList(
                Set<double>.from(this).toList(growable: false), dtype: dtype),
        skipCaching: skipCaching);

  @override
  Vector fastMap<T>(T Function(T element) mapper) {
    final source = _innerSimdList.map<Float64x2>(
            (value) => mapper(value as T) as Float64x2).toList(growable: false);
    return Vector.fromSimdList(Float64x2List.fromList(source), length,
        dtype: dtype);
  }

  @override
  Vector mapToVector(double Function(double value) mapper) =>
      Vector.fromList(_innerTypedList.map(mapper).toList(), dtype: dtype);

  @override
  double operator [](int index) {
    if (isEmpty) {
      throw _emptyVectorException;
    }
    if (index >= length) {
      throw RangeError.index(index, this);
    }
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
    final limit = end == null || end > length ? length : end;
    final collection = _innerTypedList.sublist(start, limit);

    return Vector.fromList(collection, dtype: dtype);
  }

  @override
  Vector normalize([Norm normType = Norm.euclidean,
    bool skipCaching = false]) =>
      _cacheManager.retrieveValue(getCacheKeyForNormalizeByNormType(normType),
              () => this / norm(normType), skipCaching: skipCaching);

  @override
  Vector rescale({bool skipCaching = false}) =>
      _cacheManager.retrieveValue(vectorRescaleKey, () {
        final minValue = min();
        final maxValue = max();
        return (this - minValue) / (maxValue - minValue);
      }, skipCaching: skipCaching);

  @override
  Map<String, dynamic> toJson() => vectorToJson(this);

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

  Vector _elementWisePow(num exp) => exp is int
      ? _elementWiseIntegerPow(exp)
      : _elementWiseFloatPow(exp as double);

  Vector _elementWiseIntegerPow(int exponent) {
    final source = Float64x2List(_numOfBuckets);
    for (var i = 0; i < _numOfBuckets; i++) {
      source[i] = _simdToIntPow(_innerSimdList[i], exponent);
    }
    return Vector.fromSimdList(source, length, dtype: dtype);
  }

  Vector _elementWiseFloatPow(double exponent) {
    final source = Float64x2List(_numOfBuckets);
    for (var i = 0; i < _numOfBuckets; i++) {
      source[i] = _simdToFloatPow(_innerSimdList[i], exponent);
    }
    return Vector.fromSimdList(source, length, dtype: dtype);
  }

  /// Returns a SIMD value raised to the integer power
  Float64x2 _simdToIntPow(Float64x2 lane, num power) {
    if (power == 0) {
      return Float64x2.splat(1.0);
    }

    final x = _simdToIntPow(lane, power ~/ 2);
    final sqrX = x * x;

    if (power % 2 == 0) {
      return sqrX;
    }

    return lane * sqrX;
  }

  Float64x2 _simdToFloatPow(Float64x2 lane, num exponent) =>
      _simdHelper.pow(lane, exponent);

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

  Exception get _emptyVectorException =>
      Exception('The vector is empty');

  RangeError get _mismatchLengthError =>
      RangeError('Vectors length must be equal');

  @override
  DType get dtype => DType.float64;
}
