import 'dart:typed_data';

import 'package:ml_linalg/src/common/cache_manager/cache_manager.dart';
import 'package:ml_linalg/src/vector/exception/vectors_length_mismatch_exception.dart';
import 'package:ml_linalg/vector.dart' show Vector;
import 'package:ml_linalg/vector_buffer.dart';

/// Gives a float32 vector's internal data to its mutable buffer.
abstract class Float32x4VectorDataProvider {
  Float32x4VectorData get bufferData;
}

/// The internal float32 representation shared by a vector and its buffer.
class Float32x4VectorData {
  Float32x4VectorData(this.simd, this.values, this.length, this.cache);

  final Float32x4List simd;
  final Float32List values;
  final int length;
  final CacheManager cache;
}

/// Mutable float32 operations over a vector's internal representation.
class Float32x4VectorBuffer implements VectorBuffer {
  Float32x4VectorBuffer(this._data);

  final Float32x4VectorData _data;

  @override
  VectorBuffer add(Vector vector) {
    _checkLength(vector);
    if (vector is Float32x4VectorDataProvider) {
      final other = (vector as Float32x4VectorDataProvider).bufferData.simd;
      final bucketSize =
          Float32x4List.bytesPerElement ~/ Float32List.bytesPerElement;
      final fullBuckets = _data.length ~/ bucketSize;
      for (var i = 0; i < fullBuckets; i++) {
        _data.simd[i] = _data.simd[i] + other[i];
      }
      for (var i = fullBuckets * bucketSize; i < _data.length; i++) {
        _data.values[i] += vector[i];
      }
    } else {
      for (var i = 0; i < _data.length; i++) {
        _data.values[i] += vector[i];
      }
    }
    _data.cache.clear();
    return this;
  }

  @override
  VectorBuffer subtract(Vector vector) {
    _checkLength(vector);
    if (vector is Float32x4VectorDataProvider) {
      final other = (vector as Float32x4VectorDataProvider).bufferData.simd;
      final bucketSize =
          Float32x4List.bytesPerElement ~/ Float32List.bytesPerElement;
      final fullBuckets = _data.length ~/ bucketSize;
      for (var i = 0; i < fullBuckets; i++) {
        _data.simd[i] = _data.simd[i] - other[i];
      }
      for (var i = fullBuckets * bucketSize; i < _data.length; i++) {
        _data.values[i] -= vector[i];
      }
    } else {
      for (var i = 0; i < _data.length; i++) {
        _data.values[i] -= vector[i];
      }
    }
    _data.cache.clear();
    return this;
  }

  @override
  VectorBuffer multiply(Vector vector) {
    _checkLength(vector);
    if (vector is Float32x4VectorDataProvider) {
      final other = (vector as Float32x4VectorDataProvider).bufferData.simd;
      final bucketSize =
          Float32x4List.bytesPerElement ~/ Float32List.bytesPerElement;
      final fullBuckets = _data.length ~/ bucketSize;
      for (var i = 0; i < fullBuckets; i++) {
        _data.simd[i] = _data.simd[i] * other[i];
      }
      for (var i = fullBuckets * bucketSize; i < _data.length; i++) {
        _data.values[i] *= vector[i];
      }
    } else {
      for (var i = 0; i < _data.length; i++) {
        _data.values[i] *= vector[i];
      }
    }
    _data.cache.clear();
    return this;
  }

  @override
  VectorBuffer divide(Vector vector) {
    _checkLength(vector);
    if (vector is Float32x4VectorDataProvider) {
      final other = (vector as Float32x4VectorDataProvider).bufferData.simd;
      final bucketSize =
          Float32x4List.bytesPerElement ~/ Float32List.bytesPerElement;
      final fullBuckets = _data.length ~/ bucketSize;
      for (var i = 0; i < fullBuckets; i++) {
        _data.simd[i] = _data.simd[i] / other[i];
      }
      for (var i = fullBuckets * bucketSize; i < _data.length; i++) {
        _data.values[i] /= vector[i];
      }
    } else {
      for (var i = 0; i < _data.length; i++) {
        _data.values[i] /= vector[i];
      }
    }
    _data.cache.clear();
    return this;
  }

  void _checkLength(Vector vector) {
    if (vector.length != _data.length) {
      throw VectorsLengthMismatchException(_data.length, vector.length);
    }
  }
}
