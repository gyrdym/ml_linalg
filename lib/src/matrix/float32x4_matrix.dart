import 'dart:collection';
import 'dart:core';
import 'dart:typed_data';

import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/matrix/float32_matrix_iterator.dart';
import 'package:ml_linalg/src/matrix/float32x4_matrix_factory_mixin.dart';
import 'package:ml_linalg/src/matrix/matrix_validation_mixin.dart';
import 'package:ml_linalg/src/matrix/ml_matrix_cache_service.dart';
import 'package:ml_linalg/src/matrix/ml_matrix_mixin.dart';
import 'package:ml_linalg/src/vector/float32x4_vector_factory_mixin.dart';
import 'package:ml_linalg/vector.dart';

class Float32x4Matrix extends Object with
    IterableMixin<Iterable<double>>,
    MatrixValidationMixin<Float32x4>,
    Float32x4MatrixFactoryMixin,
    Float32x4VectorFactoryMixin,
    MLMatrixMixin<Float32x4List, Float32x4> implements MLMatrixCacheService<Float32x4>, MLMatrix<Float32x4> {

  @override
  final int rowsNum;

  @override
  final int columnsNum;

  @override
  final ByteData data;

  @override
  final List<MLVector<Float32x4>> columnsCache;

  @override
  final List<MLVector<Float32x4>> rowsCache;

  Float32x4Matrix.from(Iterable<Iterable<double>> source)
      : rowsNum = source.length,
        columnsNum = source.first.length,
        data = ByteData(source.length * source.first.length * Float32List.bytesPerElement),
        rowsCache = List<MLVector<Float32x4>>(source.length),
        columnsCache = List<MLVector<Float32x4>>(source.first.length) {
    final flattened = flatten2dimList(source, (i, j) => i * columnsNum + j);
    data.buffer.asFloat32List().setAll(0, flattened);
  }

  /// vectors from [source] will serve as columns of the matrix
  /// It works this way:
  /// Input:
  ///   {a1 a2 a3 a4}
  ///   {b1 b2 b3 b4}
  ///   {c1 c2 c3 c4}
  ///
  ///  Output:
  ///   {a1} {b1} {c1}
  ///   {a2} {b2} {c2}
  ///   {a3} {b3} {c3}
  ///   {a4} {b4} {c4}
  Float32x4Matrix.columns(Iterable<MLVector<Float32x4>> source)
      : rowsNum = source.first.length,
        columnsNum = source.length,
        data = ByteData(source.length * source.first.length * Float32List.bytesPerElement),
        rowsCache = List<MLVector<Float32x4>>(source.first.length),
        columnsCache = source.toList(growable: false) {
    final flattened = flatten2dimList(source, (i, j) => j * columnsNum + i);
    data.buffer.asFloat32List().setAll(0, flattened);
  }

  /// vectors from [source] will serve as rows of the matrix
  Float32x4Matrix.rows(Iterable<MLVector<Float32x4>> source)
      : rowsNum = source.length,
        columnsNum = source.first.length,
        data = ByteData(source.length * source.first.length * Float32List.bytesPerElement),
        rowsCache = source.toList(growable: false),
        columnsCache = List<MLVector<Float32x4>>(source.first.length) {
    final flattened = flatten2dimList(source, (i, j) => i * columnsNum + j);
    data.buffer.asFloat32List().setAll(0, flattened);
  }

  Float32x4Matrix.flattened(Iterable<double> source, this.rowsNum, this.columnsNum)
      : data = ByteData(rowsNum * columnsNum * Float32List.bytesPerElement),
        rowsCache = List<MLVector<Float32x4>>(rowsNum),
        columnsCache = List<MLVector<Float32x4>>(columnsNum) {
    if (source.length != rowsNum * columnsNum) {
      throw Exception('Invalid number of rows and columns are provided');
    }
    data.buffer.asFloat32List().setAll(0, source);
  }

  @override
  Iterator<Iterable<double>> get iterator => Float32MatrixIterator(data, columnsNum);
}
