import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/norm.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager.dart';
import 'package:ml_linalg/src/common/exception/unsupported_operand_type_exception.dart';
import 'package:ml_linalg/src/matrix/float32_matrix.dart';
import 'package:ml_linalg/src/vector/exception/cosine_of_zero_vector_exception.dart';
import 'package:ml_linalg/src/vector/exception/empty_vector_exception.dart';
import 'package:ml_linalg/src/vector/exception/matrix_rows_and_vector_length_mismatch_exception.dart';
import 'package:ml_linalg/src/vector/exception/unsupported_distance_type_exception.dart';
import 'package:ml_linalg/src/vector/exception/unsupported_norm_type_exception.dart';
import 'package:ml_linalg/src/vector/exception/vectors_length_mismatch_exception.dart';
import 'package:ml_linalg/src/vector/serialization/vector_to_json.dart';
import 'package:ml_linalg/src/vector/simd_helper/simd_helper.dart';
import 'package:ml_linalg/src/vector/vector_cache_keys.dart';
import 'package:ml_linalg/vector.dart';

const _bytesPerElement = Float32List.bytesPerElement;
const _bytesPerSimdElement = Float32x4List.bytesPerElement;
const _bucketSize =
    Float32x4List.bytesPerElement ~/ Float32List.bytesPerElement;
final _simdOnes = Float32x4.splat(1.0);

class Float32x4Vector with IterableMixin<double> implements Vector {
  Float32x4Vector.fromList(
      List<num> source, this._cacheManager, this._simdHelper)
      : length = source.length {
    _numOfBuckets = _getNumOfBuckets(source.length, _bucketSize);
    final byteData = ByteData(_numOfBuckets * _bytesPerSimdElement);
    _buffer = byteData.buffer;

    for (var i = 0; i < length; i++) {
      byteData.setFloat32(
          _bytesPerElement * i, source[i].toDouble(), Endian.host);
    }
  }

  Float32x4Vector.randomFilled(
    this.length,
    int? seed,
    this._cacheManager,
    this._simdHelper, {
    num min = 0,
    num max = 1,
  }) {
    if (min >= max) {
      throw ArgumentError.value(min,
          'Argument `min` should be less than `max`, min: $min, max: $max');
    }

    _numOfBuckets = _getNumOfBuckets(length, _bucketSize);
    final byteData = ByteData(_numOfBuckets * _bytesPerSimdElement);
    _buffer = byteData.buffer;

    final generator = math.Random(seed);
    final diff = max - min;

    for (var i = 0; i < length; i++) {
      byteData.setFloat32(_bytesPerElement * i,
          generator.nextDouble() * diff + min, Endian.host);
    }
  }

  Float32x4Vector.filled(
      this.length, num value, this._cacheManager, this._simdHelper) {
    _numOfBuckets = _getNumOfBuckets(length, _bucketSize);
    final byteData = ByteData(_numOfBuckets * _bytesPerSimdElement);
    _buffer = byteData.buffer;

    for (var i = 0; i < length; i++) {
      byteData.setFloat32(_bytesPerElement * i, value.toDouble(), Endian.host);
    }
  }

  Float32x4Vector.zero(this.length, this._cacheManager, this._simdHelper)
      : _numOfBuckets = _getNumOfBuckets(length, _bucketSize),
        _buffer = ByteData(
                _getNumOfBuckets(length, _bucketSize) * _bytesPerSimdElement)
            .buffer;

  Float32x4Vector.fromSimdList(
      Float32x4List data, this.length, this._cacheManager, this._simdHelper)
      : _numOfBuckets = _getNumOfBuckets(length, _bucketSize),
        _buffer = data.buffer {
    _cachedInnerSimdList = data;
  }

  Float32x4Vector.empty(this._cacheManager, this._simdHelper)
      : length = 0,
        _numOfBuckets = 0,
        _buffer = ByteData(0).buffer;

  static int _getNumOfBuckets(int length, int bucketSize) =>
      (length / bucketSize).ceil();

  @override
  final int length;

  final CacheManager _cacheManager;
  final SimdHelper _simdHelper;
  late ByteBuffer _buffer;
  late int _numOfBuckets;

  @override
  Iterator<double> get iterator => _innerTypedList.iterator;

  Float32x4List get _innerSimdList =>
      _cachedInnerSimdList ??= _buffer.asFloat32x4List();
  Float32x4List? _cachedInnerSimdList;

  Float32List get _innerTypedList =>
      _cachedInnerTypedList ??= _buffer.asFloat32List(0, length);
  Float32List? _cachedInnerTypedList;

  bool get _isLastBucketNotFull => length % _bucketSize > 0;

  @override
  bool operator ==(Object other) {
    if (other is Float32x4Vector) {
      if (length != other.length) {
        return false;
      }

      for (var i = 0; i < _numOfBuckets; i++) {
        if (!_simdHelper.areLanesEqual(
            _innerSimdList[i], other._innerSimdList[i])) {
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

        final summed = _innerSimdList
            .reduce((sum, element) => sum + element.scale((31 * (i++)) * 1.0));

        return length + _simdHelper.sumLanesForHash(summed).hashCode;
      }, skipCaching: false);

  @override
  Vector operator +(Object value) {
    if (value is Float32x4Vector || value is Float32Matrix) {
      final other = (value is Float32Matrix ? value.toVector() : value)
          as Float32x4Vector;

      if (other.length != length) {
        throw VectorsLengthMismatchException(length, other.length);
      }

      final source = Float32x4List(_numOfBuckets);

      for (var i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i] + other._innerSimdList[i];
      }

      return Vector.fromSimdList(source, length, dtype: dtype);
    }

    if (value is num) {
      final arg = Float32x4.splat(value.toDouble());
      final source = Float32x4List(_numOfBuckets);

      for (var i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i] + arg;
      }

      return Vector.fromSimdList(source, length, dtype: dtype);
    }

    throw UnsupportedOperandTypeException(value.runtimeType,
        operationName: 'Vector "+" operator');
  }

  @override
  Vector operator -(Object value) {
    if (value is Float32x4Vector || value is Float32Matrix) {
      final other =
          (value is Matrix ? value.toVector() : value) as Float32x4Vector;

      if (other.length != length) {
        throw VectorsLengthMismatchException(length, other.length);
      }

      final source = Float32x4List(_numOfBuckets);

      for (var i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i] - other._innerSimdList[i];
      }

      return Vector.fromSimdList(source, length, dtype: dtype);
    }

    if (value is num) {
      final arg = Float32x4.splat(value.toDouble());
      final source = Float32x4List(_numOfBuckets);

      for (var i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i] - arg;
      }

      return Vector.fromSimdList(source, length, dtype: dtype);
    }

    throw UnsupportedOperandTypeException(value.runtimeType,
        operationName: 'Vector "-" operator');
  }

  @override
  Vector operator *(Object value) {
    if (value is Float32x4Vector) {
      final other = value;

      if (other.length != length) {
        throw VectorsLengthMismatchException(length, other.length);
      }

      final source = Float32x4List(_numOfBuckets);

      for (var i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i] * other._innerSimdList[i];
      }

      return Vector.fromSimdList(source, length, dtype: dtype);
    }

    if (value is Float32Matrix) {
      return _matrixMul(value);
    }

    if (value is num) {
      final source = Float32x4List(_numOfBuckets);

      for (var i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i].scale(value.toDouble());
      }

      return Vector.fromSimdList(source, length, dtype: dtype);
    }

    throw UnsupportedOperandTypeException(value.runtimeType,
        operationName: 'Vector "*" operator');
  }

  @override
  Vector operator /(Object value) {
    if (value is Float32x4Vector) {
      final other = value;

      if (other.length != length) {
        throw VectorsLengthMismatchException(length, other.length);
      }

      final source = Float32x4List(_numOfBuckets);

      for (var i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i] / other._innerSimdList[i];
      }

      return Vector.fromSimdList(source, length, dtype: dtype);
    }

    if (value is num) {
      final source = Float32x4List(_numOfBuckets);

      for (var i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i].scale(1 / value);
      }

      return Vector.fromSimdList(source, length, dtype: dtype);
    }

    throw UnsupportedOperandTypeException(value.runtimeType,
        operationName: 'Vector "/" operator');
  }

  @override
  Vector sqrt({bool skipCaching = false}) =>
      _cacheManager.retrieveValue(vectorSqrtKey, () {
        final source = Float32x4List(_numOfBuckets);

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
  Vector exp({bool skipCaching = false}) =>
      _cacheManager.retrieveValue(vectorLogKey, () {
        final source = Float32List(length);

        for (var i = 0; i < length; i++) {
          source[i] = math.exp(_innerTypedList[i]);
        }

        return Vector.fromList(source, dtype: dtype);
      }, skipCaching: skipCaching);

  @override
  Vector log({bool skipCaching = false}) =>
      _cacheManager.retrieveValue(vectorLogKey, () {
        final source = Float32List(length);
        for (var i = 0; i < length; i++) {
          source[i] = math.log(_innerTypedList[i]);
        }

        return Vector.fromList(source, dtype: dtype);
      }, skipCaching: skipCaching);

  @override
  Vector abs({bool skipCaching = false}) =>
      _cacheManager.retrieveValue(vectorAbsKey, () {
        final source = Float32x4List(_numOfBuckets);
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
  double prod({bool skipCaching = false}) => _cacheManager
      .retrieveValue(vectorSumKey, _findProduct, skipCaching: skipCaching);

  @override
  double distanceTo(
    Vector other, {
    Distance distance = Distance.euclidean,
  }) {
    switch (distance) {
      case Distance.euclidean:
        return (this - other).norm(Norm.euclidean);

      case Distance.manhattan:
        return (this - other).norm(Norm.manhattan);

      case Distance.cosine:
        return 1 - getCosine(other);

      case Distance.hamming:
        return _getHammingDistance(other);

      default:
        throw UnsupportedDistanceTypeException(distance);
    }
  }

  @override
  double getCosine(Vector other) {
    final cosine =
        (dot(other) / norm(Norm.euclidean) / other.norm(Norm.euclidean));

    if (cosine.isInfinite || cosine.isNaN) {
      throw CosineOfZeroVectorException();
    }

    return cosine;
  }

  @override
  double mean({bool skipCaching = false}) {
    if (isEmpty) {
      throw EmptyVectorException();
    }

    return _cacheManager.retrieveValue(vectorMeanKey, () => sum() / length,
        skipCaching: skipCaching);
  }

  @override
  double median({bool skipCaching = false}) {
    if (isEmpty) {
      throw EmptyVectorException();
    }

    return _cacheManager.retrieveValue(vectorMedianKey, () {
      if (length == 1) {
        return this[0];
      }

      final sorted = Float32List.fromList(_innerTypedList)..sort();
      final isOdd = length % 2 != 0;
      final midIndex = ((length - 1) / 2).floor();

      return isOdd
          ? sorted[midIndex]
          : (sorted[midIndex] + sorted[midIndex + 1]) / 2;
    }, skipCaching: skipCaching);
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
  double max({bool skipCaching = false}) => _cacheManager.retrieveValue(
      vectorMaxKey,
      () => _findExtrema(-double.infinity, _simdHelper.getMaxLane,
          (a, b) => a.max(b), math.max),
      skipCaching: skipCaching);

  @override
  double min({bool skipCaching = false}) => _cacheManager.retrieveValue(
      vectorMinKey,
      () => _findExtrema(double.infinity, _simdHelper.getMinLane,
          (a, b) => a.min(b), math.min),
      skipCaching: skipCaching);

  double _findProduct() {
    if (length == 0) {
      return double.nan;
    }

    if (_isLastBucketNotFull) {
      final fullBucketsList = _innerSimdList.take(_numOfBuckets - 1);
      final product = fullBucketsList.isNotEmpty
          ? fullBucketsList.reduce((result, value) => result * value)
          : _simdOnes;

      return _simdHelper
          .simdValueToList(_innerSimdList.last)
          .take(length % _bucketSize)
          .fold(_simdHelper.multLanes(product),
              (result, value) => result * value);
    }

    return _simdHelper
        .multLanes(_innerSimdList.reduce((result, value) => result * value));
  }

  double _findExtrema(
    double initialValue,
    double Function(Float32x4 bucket) getExtremalLane,
    Float32x4 Function(Float32x4 first, Float32x4 second) getExtremalBucket,
    double Function(double first, double second) getExtremalValue,
  ) {
    if (_isLastBucketNotFull) {
      var extrema = initialValue;
      final fullBucketsList = _innerSimdList.take(_numOfBuckets - 1);

      if (fullBucketsList.isNotEmpty) {
        extrema = getExtremalLane(fullBucketsList.reduce(getExtremalBucket));
      }

      return _simdHelper
          .simdValueToList(_innerSimdList.last)
          .take(length % _bucketSize)
          .fold(extrema, getExtremalValue);
    }

    return getExtremalLane(_innerSimdList.reduce(getExtremalBucket));
  }

  @override
  Vector sample(Iterable<int> indices) {
    var i = 0;
    final list = Float32List(indices.length);

    for (final idx in indices) {
      list[i++] = this[idx];
    }

    return Vector.fromList(list, dtype: dtype);
  }

  @override
  Vector unique({bool skipCaching = false}) => _cacheManager.retrieveValue(
      vectorUniqueKey,
      () => Vector.fromList(
            Set<double>.from(this).toList(growable: false),
            dtype: dtype,
          ),
      skipCaching: skipCaching);

  @override
  Vector fastMap<T>(T Function(T element) mapper) {
    final source = _innerSimdList
        .map<Float32x4>((value) => mapper(value as T) as Float32x4)
        .toList(growable: false);
    return Vector.fromSimdList(Float32x4List.fromList(source), length,
        dtype: dtype);
  }

  @override
  Vector mapToVector(double Function(double value) mapper) =>
      Vector.fromList(_innerTypedList.map(mapper).toList(), dtype: dtype);

  @override
  Vector filterElements(bool Function(double element, int idx) predicate) {
    var i = 0;
    return Vector.fromList(
        _innerTypedList.where((element) => predicate(element, i++)).toList(),
        dtype: dtype);
  }

  @override
  double operator [](int index) {
    if (isEmpty) {
      throw EmptyVectorException();
    }

    if (index >= length) {
      throw RangeError.index(index, this);
    }

    return _innerTypedList[index];
  }

  @override
  Vector subvector(int start, [int? end]) {
    if (start < 0) {
      throw RangeError.range(
          start,
          0,
          length - 1,
          '`start` cannot'
          ' be negative, `start`: $start');
    }

    if (end != null && start >= end) {
      throw RangeError.range(start, 0, length - 1,
          '`start` cannot be greater than or equal to `end`, `start`: $start, `end`: $end');
    }

    if (start >= length) {
      throw RangeError.range(
          start,
          0,
          length - 1,
          '`start` cannot be greater than or equal to the vector'
          'length, `start`: $start');
    }

    final limit = end == null || end > length ? length : end;
    final collection = _innerTypedList.sublist(start, limit);

    return Vector.fromList(collection, dtype: dtype);
  }

  @override
  Vector normalize(
          [Norm normType = Norm.euclidean, bool skipCaching = false]) =>
      _cacheManager.retrieveValue(getCacheKeyForNormalizeByNormType(normType),
          () => this / norm(normType),
          skipCaching: skipCaching);

  @override
  Vector rescale({bool skipCaching = false}) =>
      _cacheManager.retrieveValue(vectorRescaleKey, () {
        final minValue = min();
        final maxValue = max();

        return (this - minValue) / (maxValue - minValue);
      }, skipCaching: skipCaching);

  @override
  Vector set(int index, num value) {
    final copy = Float32List.fromList(_innerTypedList);

    copy[index] = value.toDouble();

    return Vector.fromList(copy, dtype: dtype);
  }

  @override
  Map<String, dynamic> toJson() => vectorToJson(this)!;

  /// Returns exponent depending on vector norm type (for Euclidean norm - 2,
  /// Manhattan - 1)
  int _getPowerByNormType(Norm norm) {
    switch (norm) {
      case Norm.euclidean:
        return 2;

      case Norm.manhattan:
        return 1;

      default:
        throw UnsupportedNormType(norm);
    }
  }

  Vector _elementWisePow(num exp) => exp is int
      ? _elementWiseIntegerPow(exp)
      : _elementWiseFloatPow(exp as double);

  Vector _elementWiseIntegerPow(int exponent) {
    final source = Float32x4List(_numOfBuckets);

    for (var i = 0; i < _numOfBuckets; i++) {
      source[i] = _simdToIntPow(_innerSimdList[i], exponent);
    }

    return Vector.fromSimdList(source, length, dtype: dtype);
  }

  Vector _elementWiseFloatPow(double exponent) {
    final source = Float32x4List(_numOfBuckets);

    for (var i = 0; i < _numOfBuckets; i++) {
      source[i] = _simdToFloatPow(_innerSimdList[i], exponent);
    }

    return Vector.fromSimdList(source, length, dtype: dtype);
  }

  /// Returns a SIMD value raised to the integer power
  Float32x4 _simdToIntPow(Float32x4 lane, num power) {
    if (power == 0) {
      return Float32x4.splat(1.0);
    }

    final x = _simdToIntPow(lane, power ~/ 2);
    final sqrX = x * x;

    if (power % 2 == 0) {
      return sqrX;
    }

    return lane * sqrX;
  }

  Float32x4 _simdToFloatPow(Float32x4 lane, num exponent) =>
      _simdHelper.pow(lane, exponent);

  double _getHammingDistance(Vector other) {
    var dist = 0.0;

    for (var i = 0; i < _innerTypedList.length; i++) {
      if (other[i] != _innerTypedList[i]) {
        dist++;
      }
    }

    return dist;
  }

  Vector _matrixMul(Matrix matrix) {
    if (length != matrix.rowsNum) {
      throw MatrixRowsAndVectorLengthMismatchException(matrix.rowsNum, length);
    }

    final source =
        List.generate(matrix.columnsNum, (int i) => dot(matrix.getColumn(i)));

    return Vector.fromList(source, dtype: dtype);
  }

  @override
  DType get dtype => DType.float32;
}
