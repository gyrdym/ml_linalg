/* This file is auto generated, do not change it manually */
// ignore_for_file: unused_local_variable

import 'dart:typed_data';

import 'package:ml_linalg/src/common/cache_manager/cache_manager.dart';
import 'package:ml_linalg/src/vector/exception/vectors_length_mismatch_exception.dart';
import 'package:ml_linalg/vector.dart' show Vector;
import 'package:ml_linalg/vector_buffer.dart';

/// Gives a float64 vector's internal data to its mutable buffer.
abstract class Float64x2VectorDataProvider {
  Float64x2VectorData get bufferData;
}

/// The internal float64 representation shared by a vector and its buffer.
class Float64x2VectorData {
  Float64x2VectorData(this.simd, this.values, this.length, this.cache);

  final Float64x2List simd;
  final Float64List values;
  final int length;
  final CacheManager cache;
}

/// Mutable float64 operations over a vector's internal representation.
class Float64x2VectorBuffer implements VectorBuffer {
  Float64x2VectorBuffer(this._data);

  final Float64x2VectorData _data;

  @override
  VectorBuffer add(Vector vector) {
    _checkLength(vector);
    if (vector is Float64x2VectorDataProvider) {
      final other = (vector as Float64x2VectorDataProvider).bufferData.simd;
      final bucketSize =
          Float64x2List.bytesPerElement ~/ Float64List.bytesPerElement;
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
    if (vector is Float64x2VectorDataProvider) {
      final other = (vector as Float64x2VectorDataProvider).bufferData.simd;
      final bucketSize =
          Float64x2List.bytesPerElement ~/ Float64List.bytesPerElement;
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
    if (vector is Float64x2VectorDataProvider) {
      final other = (vector as Float64x2VectorDataProvider).bufferData.simd;
      final bucketSize =
          Float64x2List.bytesPerElement ~/ Float64List.bytesPerElement;
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
    if (vector is Float64x2VectorDataProvider) {
      final other = (vector as Float64x2VectorDataProvider).bufferData.simd;
      final bucketSize =
          Float64x2List.bytesPerElement ~/ Float64List.bytesPerElement;
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
