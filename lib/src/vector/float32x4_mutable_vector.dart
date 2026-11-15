import 'dart:collection';
import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/mutable_vector.dart';
import 'package:ml_linalg/src/vector/exception/vectors_length_mismatch_exception.dart';
import 'package:ml_linalg/vector.dart' show Vector;

/// Gives SIMD data to float32 vector implementations.
abstract class Float32x4VectorDataProvider {
  Float32x4VectorData get vectorData;
}

/// The typed views used by a float32 vector implementation.
class Float32x4VectorData {
  Float32x4VectorData(this.simd, this.values, this.length);

  final Float32x4List simd;
  final Float32List values;
  final int length;
}

/// Mutable float32 vector with storage independent from its source vector.
class Float32x4MutableVector
    with IterableMixin<double>
    implements MutableVector, Float32x4VectorDataProvider {
  Float32x4MutableVector(Float32x4VectorData source)
      : this._fromSimd(Float32x4List.fromList(source.simd), source.length);

  Float32x4MutableVector._fromSimd(Float32x4List simd, this.length)
      : _data = Float32x4VectorData(
          simd,
          simd.buffer.asFloat32List(0, length),
          length,
        );

  final Float32x4VectorData _data;

  @override
  final int length;

  @override
  DType get dtype => DType.float32;

  @override
  Iterator<double> get iterator => _data.values.iterator;

  @override
  double operator [](int index) => _data.values[index];

  @override
  Float32x4VectorData get vectorData => _data;

  @override
  Vector toVector() => Vector.fromSimdList(
        Float32x4List.fromList(_data.simd),
        length,
        dtype: dtype,
      );

  @override
  MutableVector add(Vector vector) {
    _checkLength(vector);
    if (vector is Float32x4VectorDataProvider) {
      final other = (vector as Float32x4VectorDataProvider).vectorData.simd;
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
    return this;
  }

  @override
  MutableVector subtract(Vector vector) {
    _checkLength(vector);
    if (vector is Float32x4VectorDataProvider) {
      final other = (vector as Float32x4VectorDataProvider).vectorData.simd;
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
    return this;
  }

  @override
  MutableVector multiply(Vector vector) {
    _checkLength(vector);
    if (vector is Float32x4VectorDataProvider) {
      final other = (vector as Float32x4VectorDataProvider).vectorData.simd;
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
    return this;
  }

  @override
  MutableVector divide(Vector vector) {
    _checkLength(vector);
    if (vector is Float32x4VectorDataProvider) {
      final other = (vector as Float32x4VectorDataProvider).vectorData.simd;
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
    return this;
  }

  void _checkLength(Vector vector) {
    if (vector.length != _data.length) {
      throw VectorsLengthMismatchException(_data.length, vector.length);
    }
  }
}
