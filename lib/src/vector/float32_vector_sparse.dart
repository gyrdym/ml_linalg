import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/norm.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager_factory_impl.dart';
import 'package:ml_linalg/src/common/exception/unsupported_operand_type_exception.dart';
import 'package:ml_linalg/src/vector/exception/cosine_of_zero_vector_exception.dart';
import 'package:ml_linalg/src/vector/exception/empty_vector_exception.dart';
import 'package:ml_linalg/src/vector/exception/unsupported_distance_type_exception.dart';
import 'package:ml_linalg/src/vector/exception/unsupported_norm_type_exception.dart';
import 'package:ml_linalg/src/vector/exception/vector_list_length_mismatch_exception.dart';
import 'package:ml_linalg/src/vector/exception/vectors_length_mismatch_exception.dart';
import 'package:ml_linalg/src/vector/serialization/vector_to_json.dart';
import 'package:ml_linalg/src/vector/vector_cache_keys.dart';
import 'package:ml_linalg/vector.dart';

/// A float32 sparse vector that stores only non-zero values.
///
/// Missing indices are treated as `0.0`.
class Float32VectorSparse with IterableMixin<double> implements Vector {
  /// Creates a sparse vector from [source], where keys are indices and values
  /// are vector elements.
  ///
  /// Zero values in [source] are ignored. Indices must be in `[0, length)`.
  Float32VectorSparse.fromMap(
    Map<int, num> source, {
    required this.length,
  }) : _cache = const CacheManagerFactoryImpl().create(vectorCacheKeys) {
    if (length < 0) {
      throw ArgumentError.value(length, 'length', 'Cannot be negative');
    }

    final entries = <MapEntry<int, double>>[];

    source.forEach((index, value) {
      if (index < 0 || index >= length) {
        throw RangeError.range(index, 0, length - 1, 'index');
      }

      final doubleValue = value.toDouble();

      if (doubleValue != 0.0) {
        entries.add(MapEntry(index, doubleValue));
      }
    });

    entries.sort((a, b) => a.key.compareTo(b.key));

    _indices = Int32List(entries.length);
    _values = Float32List(entries.length);

    for (var i = 0; i < entries.length; i++) {
      _indices[i] = entries[i].key;
      _values[i] = entries[i].value;
    }
  }

  Float32VectorSparse._raw({
    required this.length,
    required Int32List indices,
    required Float32List values,
    required CacheManager cache,
  })  : _indices = indices,
        _values = values,
        _cache = cache;

  @override
  final int length;

  final CacheManager _cache;

  late final Int32List _indices;
  late final Float32List _values;

  /// Number of non-zeros — how many explicitly stored (non-zero) elements.
  int get nnz => _indices.length;

  @override
  DType get dtype => DType.float32;

  @override
  Iterator<double> get iterator =>
      _Float32VectorSparseIterator(_indices, _values, length);

  @override
  double operator [](int index) {
    if (isEmpty) {
      throw EmptyVectorException();
    }

    if (index < 0 || index >= length) {
      throw RangeError.index(index, this);
    }

    final position = _indexOf(index);

    return position < 0 ? 0.0 : _values[position];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! Vector || length != other.length) {
      return false;
    }

    // Same sparse shape ⇒ same algebraic vector.
    if (other is Float32VectorSparse) {
      if (nnz != other.nnz) {
        return false;
      }

      for (var i = 0; i < nnz; i++) {
        if (_indices[i] != other._indices[i] ||
            _values[i] != other._values[i]) {
          return false;
        }
      }

      return true;
    }

    var sparsePosition = 0;

    for (var i = 0; i < length; i++) {
      final value = sparsePosition < nnz && _indices[sparsePosition] == i
          ? _values[sparsePosition++]
          : 0.0;

      if (other[i] != value) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode => _cache.get(vectorHashKey, () {
        if (isEmpty) {
          return 0;
        }

        // O(nnz) hash over length and stored (index, value) pairs. Equal sparse
        // vectors have the same non-zero layout, so they share hashCode.
        var hash = length;

        for (var i = 0; i < nnz; i++) {
          hash = _mixHash(hash, _indices[i]);
          hash = _mixHash(hash, _values[i].hashCode);
        }

        return _finalizeHash(hash);
      }, skipCaching: false);

  @override
  Vector operator +(Object value) => _asDense() + value;

  @override
  Vector operator -(Object value) => _asDense() - value;

  @override
  Vector operator *(Object value) {
    if (value is num) {
      return _mapValues((element) => element * value.toDouble());
    }

    if (value is Float32VectorSparse) {
      if (value.length != length) {
        throw VectorsLengthMismatchException(length, value.length);
      }

      return _multiplySparse(value);
    }

    if (value is Vector) {
      if (value.length != length) {
        throw VectorsLengthMismatchException(length, value.length);
      }

      return _mapEntries((index, element) => element * value[index]);
    }

    if (value is Iterable<num>) {
      if (value.length != length) {
        throw VectorListLengthMismatchException(length, value.length);
      }

      if (value is List<num>) {
        return _mapEntries((index, element) => element * value[index]);
      }

      return _asDense() * value;
    }

    if (value is Matrix) {
      return _asDense() * value;
    }

    throw UnsupportedOperandTypeException(value.runtimeType,
        operationName: 'Vector "*" operator');
  }

  @override
  Vector operator /(Object value) {
    if (value is num) {
      return _mapValues((element) => element / value.toDouble());
    }

    return _asDense() / value;
  }

  @override
  Vector sqrt({bool skipCaching = false}) =>
      _cache.get(vectorSqrtKey, () => _asDense().sqrt(skipCaching: true),
          skipCaching: skipCaching);

  @override
  Vector scalarDiv(num scalar) => this / scalar;

  @override
  Vector pow(num exponent) {
    if (exponent == 0) {
      return Vector.filled(length, 1.0, dtype: dtype);
    }

    // Negative exponents turn implicit zeros into infinities, so densify.
    if (exponent < 0) {
      return _asDense().pow(exponent);
    }

    return _mapValues((value) => math.pow(value, exponent).toDouble());
  }

  @override
  Vector exp({bool skipCaching = false}) =>
      _cache.get(vectorExpKey, () => _asDense().exp(skipCaching: true),
          skipCaching: skipCaching);

  @override
  Vector log({bool skipCaching = false}) =>
      _cache.get(vectorLogKey, () => _asDense().log(skipCaching: true),
          skipCaching: skipCaching);

  @override
  Vector abs({bool skipCaching = false}) => _cache.get(
        vectorAbsKey,
        () => _mapValues((value) => value.abs()),
        skipCaching: skipCaching,
      );

  @override
  double dot(Vector vector) {
    if (vector.length != length) {
      throw VectorsLengthMismatchException(length, vector.length);
    }

    var result = 0.0;

    for (var i = 0; i < nnz; i++) {
      result += _values[i] * vector[_indices[i]];
    }

    return result;
  }

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
        return _hammingDistance(other);

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

    return _cache.get(
        vectorMeanKey, () => sum(skipCaching: skipCaching) / length,
        skipCaching: skipCaching);
  }

  @override
  double median({bool skipCaching = false}) {
    if (isEmpty) {
      throw EmptyVectorException();
    }

    return _cache.get(vectorMedianKey, () {
      if (length == 1) {
        return this[0];
      }

      final sorted = _toFloat32List()..sort();
      final isOdd = length % 2 != 0;
      final midIndex = ((length - 1) / 2).floor();

      return isOdd
          ? sorted[midIndex]
          : (sorted[midIndex] + sorted[midIndex + 1]) / 2;
    }, skipCaching: skipCaching);
  }

  @override
  double norm([Norm normType = Norm.euclidean, bool skipCaching = false]) =>
      _cache.get(getCacheKeyForNormByNormType(normType), () {
        final power = _powerByNormType(normType);

        if (power == 1) {
          return abs(skipCaching: true).sum(skipCaching: true);
        }

        var sumOfPowers = 0.0;

        for (var i = 0; i < nnz; i++) {
          sumOfPowers += math.pow(_values[i].abs(), power).toDouble();
        }

        return math.pow(sumOfPowers, 1 / power).toDouble();
      }, skipCaching: skipCaching);

  @override
  double sum({bool skipCaching = false}) {
    if (isEmpty) {
      return double.nan;
    }

    return _cache.get(vectorSumKey, () {
      var result = 0.0;

      for (var i = 0; i < nnz; i++) {
        result += _values[i];
      }

      return result;
    }, skipCaching: skipCaching);
  }

  @override
  double prod() {
    if (isEmpty) {
      return double.nan;
    }

    if (nnz < length) {
      return 0.0;
    }

    var result = 1.0;

    for (var i = 0; i < nnz; i++) {
      result *= _values[i];
    }

    return result;
  }

  @override
  double max({bool skipCaching = false}) => _cache.get(vectorMaxKey, () {
        if (isEmpty) {
          return _asDense().max(skipCaching: true);
        }

        if (nnz == 0) {
          return 0.0;
        }

        var result = _values[0];

        for (var i = 1; i < nnz; i++) {
          result = math.max(result, _values[i]);
        }

        if (nnz < length) {
          result = math.max(result, 0.0);
        }

        return result;
      }, skipCaching: skipCaching);

  @override
  double min({bool skipCaching = false}) => _cache.get(vectorMinKey, () {
        if (isEmpty) {
          return _asDense().min(skipCaching: true);
        }

        if (nnz == 0) {
          return 0.0;
        }

        var result = _values[0];

        for (var i = 1; i < nnz; i++) {
          result = math.min(result, _values[i]);
        }

        if (nnz < length) {
          result = math.min(result, 0.0);
        }

        return result;
      }, skipCaching: skipCaching);

  @override
  Vector sample(Iterable<int> indices) {
    final list = Float32List(indices.length);
    var i = 0;

    for (final index in indices) {
      list[i++] = this[index];
    }

    return Vector.fromList(list, dtype: dtype);
  }

  @override
  Vector unique({bool skipCaching = false}) => _cache.get(
        vectorUniqueKey,
        () => Vector.fromList(
          Set<double>.from(this).toList(growable: false),
          dtype: dtype,
        ),
        skipCaching: skipCaching,
      );

  @override
  Vector normalize(
          [Norm normType = Norm.euclidean, bool skipCaching = false]) =>
      _cache.get(
        getCacheKeyForNormalizeByNormType(normType),
        () => this / norm(normType, true),
        skipCaching: skipCaching,
      );

  @override
  Vector rescale({bool skipCaching = false}) =>
      _cache.get(vectorRescaleKey, () {
        final minValue = min(skipCaching: true);
        final maxValue = max(skipCaching: true);

        return (this - minValue) / (maxValue - minValue);
      }, skipCaching: skipCaching);

  @override
  Vector set(int index, num value) {
    if (index < 0 || index >= length) {
      throw RangeError.index(index, this);
    }

    final map = <int, num>{
      for (var i = 0; i < nnz; i++) _indices[i]: _values[i],
    };

    if (value == 0) {
      map.remove(index);
    } else {
      map[index] = value;
    }

    return Float32VectorSparse.fromMap(map, length: length);
  }

  @override
  Vector fastMap<T>(T Function(T element) mapper) =>
      _asDense().fastMap(mapper);

  @override
  Vector mapToVector(double Function(double value) mapper) =>
      Vector.fromList(_toFloat32List().map(mapper).toList(), dtype: dtype);

  @override
  Vector filterElements(bool Function(double element, int idx) predicate) {
    final result = <double>[];

    for (var i = 0; i < length; i++) {
      final value = this[i];

      if (predicate(value, i)) {
        result.add(value);
      }
    }

    return Vector.fromList(result, dtype: dtype);
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
    final map = <int, num>{};

    for (var i = 0; i < nnz; i++) {
      final index = _indices[i];

      if (index >= start && index < limit) {
        map[index - start] = _values[i];
      }
    }

    return Float32VectorSparse.fromMap(map, length: limit - start);
  }

  @override
  Map<String, dynamic> toJson() => vectorToJson(this)!;

  Vector _asDense() => Vector.fromList(_toFloat32List(), dtype: dtype);

  Float32List _toFloat32List() {
    final result = Float32List(length);

    for (var i = 0; i < nnz; i++) {
      result[_indices[i]] = _values[i];
    }

    return result;
  }

  Float32VectorSparse _mapValues(double Function(double value) mapper) {
    final indices = Int32List(nnz);
    final values = Float32List(nnz);
    var count = 0;

    for (var i = 0; i < nnz; i++) {
      final mapped = mapper(_values[i]);

      if (mapped != 0.0) {
        indices[count] = _indices[i];
        values[count] = mapped;
        count++;
      }
    }

    return Float32VectorSparse._raw(
      length: length,
      indices: Int32List.sublistView(indices, 0, count),
      values: Float32List.sublistView(values, 0, count),
      cache: const CacheManagerFactoryImpl().create(vectorCacheKeys),
    );
  }

  Float32VectorSparse _mapEntries(
      double Function(int index, double value) mapper) {
    final indices = Int32List(nnz);
    final values = Float32List(nnz);
    var count = 0;

    for (var i = 0; i < nnz; i++) {
      final mapped = mapper(_indices[i], _values[i]);

      if (mapped != 0.0) {
        indices[count] = _indices[i];
        values[count] = mapped;
        count++;
      }
    }

    return Float32VectorSparse._raw(
      length: length,
      indices: Int32List.sublistView(indices, 0, count),
      values: Float32List.sublistView(values, 0, count),
      cache: const CacheManagerFactoryImpl().create(vectorCacheKeys),
    );
  }

  Float32VectorSparse _multiplySparse(Float32VectorSparse other) {
    final indices = <int>[];
    final values = <double>[];
    var i = 0;
    var j = 0;

    while (i < nnz && j < other.nnz) {
      final leftIndex = _indices[i];
      final rightIndex = other._indices[j];

      if (leftIndex == rightIndex) {
        final product = _values[i] * other._values[j];

        if (product != 0.0) {
          indices.add(leftIndex);
          values.add(product);
        }

        i++;
        j++;
      } else if (leftIndex < rightIndex) {
        i++;
      } else {
        j++;
      }
    }

    return Float32VectorSparse._raw(
      length: length,
      indices: Int32List.fromList(indices),
      values: Float32List.fromList(values),
      cache: const CacheManagerFactoryImpl().create(vectorCacheKeys),
    );
  }

  int _indexOf(int index) {
    var low = 0;
    var high = nnz - 1;

    while (low <= high) {
      final mid = (low + high) >> 1;
      final midIndex = _indices[mid];

      if (midIndex == index) {
        return mid;
      }

      if (midIndex < index) {
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }

    return -1;
  }

  int _powerByNormType(Norm normType) {
    switch (normType) {
      case Norm.euclidean:
        return 2;

      case Norm.manhattan:
        return 1;

      default:
        throw UnsupportedNormType(normType);
    }
  }

  double _hammingDistance(Vector other) {
    var distance = 0.0;

    for (var i = 0; i < length; i++) {
      if (this[i] != other[i]) {
        distance++;
      }
    }

    return distance;
  }

  static int _mixHash(int hash, int value) {
    hash = 0x1fffffff & (hash + value);
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int _finalizeHash(int hash) {
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash ^= hash >> 11;
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

class _Float32VectorSparseIterator implements Iterator<double> {
  _Float32VectorSparseIterator(this._indices, this._values, this._length);

  final Int32List _indices;
  final Float32List _values;
  final int _length;

  int _position = -1;
  int _sparsePosition = 0;
  double _current = 0.0;

  @override
  double get current => _current;

  @override
  bool moveNext() {
    _position++;

    if (_position >= _length) {
      return false;
    }

    if (_sparsePosition < _indices.length &&
        _indices[_sparsePosition] == _position) {
      _current = _values[_sparsePosition];
      _sparsePosition++;
    } else {
      _current = 0.0;
    }

    return true;
  }
}
