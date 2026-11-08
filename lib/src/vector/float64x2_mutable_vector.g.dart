/* This file is auto generated, do not change it manually */
// ignore_for_file: unused_local_variable

import 'dart:collection';
import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/vector/exception/vectors_length_mismatch_exception.dart';
import 'package:ml_linalg/vector.dart' show Vector;
import 'package:ml_linalg/mutable_vector.dart';

/// Gives SIMD data to float64 vector implementations.
abstract class Float64x2VectorDataProvider {
  Float64x2VectorData get vectorData;
}

/// The typed views used by a float64 vector implementation.
class Float64x2VectorData {
  Float64x2VectorData(this.simd, this.values, this.length);

  final Float64x2List simd;
  final Float64List values;
  final int length;
}

/// Mutable float64 vector with storage independent from its source vector.
class Float64x2MutableVector
    with IterableMixin<double>
    implements MutableVector, Float64x2VectorDataProvider {
  Float64x2MutableVector(Float64x2VectorData source)
      : this._fromSimd(Float64x2List.fromList(source.simd), source.length);

  Float64x2MutableVector._fromSimd(Float64x2List simd, this.length)
      : _data = Float64x2VectorData(
          simd,
          simd.buffer.asFloat64List(0, length),
          length,
        );

  final Float64x2VectorData _data;

  @override
  final int length;

  @override
  DType get dtype => DType.float64;

  @override
  Iterator<double> get iterator => _data.values.iterator;

  @override
  double operator [](int index) => _data.values[index];

  @override
  Float64x2VectorData get vectorData => _data;

  @override
  Vector toVector() => Vector.fromSimdList(
        Float64x2List.fromList(_data.simd),
        length,
        dtype: dtype,
      );

  @override
  MutableVector add(Vector vector) {
    _checkLength(vector);
    if (vector is Float64x2VectorDataProvider) {
      final other = (vector as Float64x2VectorDataProvider).vectorData.simd;
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
    return this;
  }

  @override
  MutableVector subtract(Vector vector) {
    _checkLength(vector);
    if (vector is Float64x2VectorDataProvider) {
      final other = (vector as Float64x2VectorDataProvider).vectorData.simd;
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
    return this;
  }

  @override
  MutableVector multiply(Vector vector) {
    _checkLength(vector);
    if (vector is Float64x2VectorDataProvider) {
      final other = (vector as Float64x2VectorDataProvider).vectorData.simd;
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
    return this;
  }

  @override
  MutableVector divide(Vector vector) {
    _checkLength(vector);
    if (vector is Float64x2VectorDataProvider) {
      final other = (vector as Float64x2VectorDataProvider).vectorData.simd;
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
    return this;
  }

  void _checkLength(Vector vector) {
    if (vector.length != _data.length) {
      throw VectorsLengthMismatchException(_data.length, vector.length);
    }
  }
}
