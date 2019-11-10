import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/norm.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager.dart';
import 'package:ml_linalg/src/vector/simd_helper.dart';
import 'package:ml_linalg/src/vector/float32x4_helper.dart';
import 'package:ml_linalg/vector.dart';

const _bytesPerElement = Float32List.bytesPerElement;
const _bytesPerSimdElement = Float32x4List.bytesPerElement;
const _bucketSize = Float32x4List.bytesPerElement ~/ Float32List.bytesPerElement;

class Float32x4Vector with IterableMixin<double> implements Vector {
  Float32x4Vector.fromList(List<num> source, this._cacheManager) :
        length = source.length,
        _numOfBuckets = _getNumOfBuckets(source.length, _bucketSize),
        _buffer = ByteData(_getNumOfBuckets(source.length, _bucketSize) *
            _bytesPerSimdElement).buffer {
    for (int i = 0; i < length; i++) {
      _buffer.asByteData().setFloat32(_bytesPerElement * i,
        source[i].toDouble(), Endian.host);
    }
  }

  Float32x4Vector.randomFilled(this.length, int seed, this._cacheManager, {
    num min = 0,
    num max = 1,
  }) :
        _numOfBuckets = _getNumOfBuckets(length, _bucketSize),
        _buffer = ByteData(_getNumOfBuckets(length, _bucketSize) *
            _bytesPerSimdElement).buffer {
    final generator = math.Random(seed);
    final diff = (max - min).abs();
    final realMin = math.min(min, max);

    for (int i = 0; i < length; i++) {
      _buffer.asByteData().setFloat32(_bytesPerElement * i,
        generator.nextDouble() * diff + realMin, Endian.host);
    }
  }

  Float32x4Vector.filled(this.length, num value, this._cacheManager, {
    bool disableCache = false,
  }) :
        _numOfBuckets = _getNumOfBuckets(length, _bucketSize),
        _buffer = ByteData(_getNumOfBuckets(length, _bucketSize) *
            _bytesPerSimdElement).buffer {
    for (int i = 0; i < length; i++) {
      _buffer.asByteData().setFloat32(_bytesPerElement * i, value.toDouble(),
          Endian.host);
    }
  }

  Float32x4Vector.zero(this.length, this._cacheManager) :
        _numOfBuckets = _getNumOfBuckets(length, _bucketSize),
        _buffer = ByteData(_getNumOfBuckets(length, _bucketSize) *
            _bytesPerSimdElement).buffer {
    for (int i = 0; i < length; i++) {
      _buffer.asByteData().setFloat32(_bytesPerElement * i, 0.0, Endian.host);
    }
  }

  Float32x4Vector.fromSimdList(Float32x4List data, this.length,
      this._cacheManager) :
        _numOfBuckets = _getNumOfBuckets(length, _bucketSize),
        _buffer = data.buffer {
    _cachedInnerSimdList = data;
  }

  Float32x4Vector.empty(this._cacheManager) :
        length = 0,
        _numOfBuckets = 0,
        _buffer = ByteData(0).buffer;

  static int _getNumOfBuckets(int length, int bucketSize) =>
      (length / bucketSize).ceil();

  @override
  final int length;

  final CacheManager _cacheManager;
  final SimdHelper _simdHelper = const Float32x4Helper();
  final ByteBuffer _buffer;
  final int _numOfBuckets;

  @override
  Iterator<double> get iterator => _innerTypedList.iterator;

  Float32x4List get _innerSimdList =>
      _cachedInnerSimdList ??= _buffer.asFloat32x4List();
  Float32x4List _cachedInnerSimdList;

  List<double> get _innerTypedList =>
      _cachedInnerTypedList ??= _buffer.asFloat32List(0, length);
  Float32List _cachedInnerTypedList;

  bool get _isLastBucketNotFull => length % _bucketSize > 0;

  @override
  bool operator ==(Object other) {
    if (other is Float32x4Vector) {
      if (length != other.length) {
        return false;
      }
      for (int i = 0; i < _numOfBuckets; i++) {
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
  int get hashCode => _cacheManager.retrieve('hash', () {
    if (isEmpty) {
      return 0;
    }

    int i = 0;

    final summed = _innerSimdList.reduce(
            (sum, element) => sum + element.scale((31 * (i++)) * 1.0));

    return length + _simdHelper.sumLanesForHash(summed).hashCode;
  }, skipCaching: false);

  @override
  Vector operator +(Object value) {
    if (value is Vector || value is Matrix) {
      final other = (value is Matrix ? value.toVector() : value) as Float32x4Vector;
      if (other.length != length) {
        throw _mismatchLengthError;
      }
      final source = Float32x4List(_numOfBuckets);
      for (int i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i] + other._innerSimdList[i];
      }
      return Vector.fromSimdList(source, length, dtype: dtype);

    } else if (value is num) {
      final arg = Float32x4.splat(value.toDouble());
      final source = Float32x4List(_numOfBuckets);
      for (int i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i] + arg;
      }
      return Vector.fromSimdList(source, length, dtype: dtype);
    }

    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Vector operator -(Object value) {
    if (value is Vector || value is Matrix) {
      final other = (value is Matrix ? value.toVector() : value) as Float32x4Vector;
      if (other.length != length) {
        throw _mismatchLengthError;
      }
      final source = Float32x4List(_numOfBuckets);
      for (int i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i] - other._innerSimdList[i];
      }
      return Vector.fromSimdList(source, length, dtype: dtype);

    } else if (value is num) {
      final arg = Float32x4.splat(value.toDouble());
      final source = Float32x4List(_numOfBuckets);
      for (int i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i] - arg;
      }
      return Vector.fromSimdList(source, length, dtype: dtype);
    }

    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Vector operator *(Object value) {
    if (value is Vector) {
      final other = value as Float32x4Vector;
      if (other.length != length) {
        throw _mismatchLengthError;
      }
      final source = Float32x4List(_numOfBuckets);
      for (int i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i] * other._innerSimdList[i];
      }
      return Vector.fromSimdList(source, length, dtype: dtype);

    } else if (value is Matrix) {
      return _matrixMul(value);

    } else if (value is num) {
      final source = Float32x4List(_numOfBuckets);
      for (int i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i].scale(value.toDouble());
      }
      return Vector.fromSimdList(source, length, dtype: dtype);
    }

    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Vector operator /(Object value) {
    if (value is Vector) {
      final other = value as Float32x4Vector;
      if (other.length != length) {
        throw _mismatchLengthError;
      }
      final source = Float32x4List(_numOfBuckets);
      for (int i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i] / other._innerSimdList[i];
      }
      return Vector.fromSimdList(source, length, dtype: dtype);

    } else if (value is num) {
      final source = Float32x4List(_numOfBuckets);
      for (int i = 0; i < _numOfBuckets; i++) {
        source[i] = _innerSimdList[i].scale(1 / value);
      }
      return Vector.fromSimdList(source, length, dtype: dtype);
    }

    throw UnsupportedError('Unsupported operand type: ${value.runtimeType}');
  }

  @override
  Vector sqrt({bool skipCaching = false}) =>
      _cacheManager.retrieve<Vector>('sqrt', () {
        final source = Float32x4List(_numOfBuckets);
        for (int i = 0; i < _numOfBuckets; i++) {
          source[i] = _innerSimdList[i].sqrt();
        }
        return Vector.fromSimdList(source, length, dtype: dtype);
      }, skipCaching: skipCaching);

  @override
  Vector scalarDiv(num scalar) => this / scalar;

  @override
  Vector toIntegerPower(int power) => _elementWisePow(power);

  @override
  Vector abs({bool skipCaching = false}) =>
      _cacheManager.retrieve<Vector>('abs', () {
        final source = Float32x4List(_numOfBuckets);
        for (int i = 0; i < _numOfBuckets; i++) {
          source[i] = _innerSimdList[i].abs();
        }
        return Vector.fromSimdList(source, length, dtype: dtype);
      }, skipCaching: skipCaching);

  @override
  double dot(Vector vector) => (this * vector).sum();

  @override
  double sum({bool skipCaching = false}) => _cacheManager.retrieve('sum',
          () => _simdHelper.sumLanes(_innerSimdList.reduce((a, b) => a + b)),
      skipCaching: skipCaching);

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
    return _cacheManager.retrieve('mean', () => sum() / length,
        skipCaching: skipCaching);
  }

  @override
  double norm([Norm norm = Norm.euclidean, bool skipCaching = false]) =>
      _cacheManager.retrieve('norm_$norm', () {
        final power = _getPowerByNormType(norm);
        if (power == 1) {
          return abs().sum();
        }
        return math.pow(toIntegerPower(power)
            .sum(), 1 / power) as double;
      }, skipCaching: skipCaching);

  @override
  double max({bool skipCaching = false}) => _cacheManager.retrieve('max', () =>
      _findExtrema(-double.infinity, _simdHelper.getMaxLane,
              (a, b) => a.max(b), math.max), skipCaching: skipCaching);

  @override
  double min({bool skipCaching = false}) => _cacheManager.retrieve('min', () =>
      _findExtrema(double.infinity, _simdHelper.getMinLane,
              (a, b) => a.min(b), math.min), skipCaching: skipCaching);

  double _findExtrema(double initialValue,
      double getExtremalLane(Float32x4 bucket),
      Float32x4 getExtremalBucket(Float32x4 first, Float32x4 second),
      double getExtremalValue(double first, double second),
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
    final list = Float32List(indices.length);
    int i = 0;
    for (final idx in indices) {
      list[i++] = this[idx];
    }
    return Vector.fromList(list, dtype: dtype);
  }

  @override
  Vector unique({bool skipCaching = false}) =>
      _cacheManager.retrieve('unique', () => Vector.fromList(
                Set<double>.from(this).toList(growable: false), dtype: dtype),
        skipCaching: skipCaching);

  @override
  Vector fastMap<T>(T mapper(T element)) {
    final source = _innerSimdList.map<Float32x4>(
            (value) => mapper(value as T) as Float32x4).toList(growable: false);
    return Vector.fromSimdList(Float32x4List.fromList(source), length,
        dtype: dtype);
  }

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
      _cacheManager.retrieve('normalize_$normType',
              () => this / norm(normType), skipCaching: skipCaching);

  @override
  Vector rescale({bool skipCaching = false}) =>
      _cacheManager.retrieve('rescale', () {
        final minValue = min();
        final maxValue = max();
        return (this - minValue) / (maxValue - minValue);
      }, skipCaching: skipCaching);

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

  /// Returns a vector as a result of applying to [this] element-wise raising
  /// to the integer power
  Vector _elementWisePow(int exp) {
    final source = Float32x4List(_numOfBuckets);
    for (int i = 0; i < _numOfBuckets; i++) {
      source[i] = _simdToIntPow(_innerSimdList[i], exp);
    }
    return Vector.fromSimdList(source, length, dtype: dtype);
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

  Exception get _emptyVectorException =>
      Exception('The vector is empty');

  RangeError get _mismatchLengthError =>
      RangeError('Vectors length must be equal');

  @override
  DType get dtype => DType.float32;
}
