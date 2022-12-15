import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager_factory.dart';
import 'package:ml_linalg/src/matrix/data_manager/float32_matrix_data_manager.dart';
import 'package:ml_linalg/src/matrix/data_manager/float64_matrix_data_manager.g.dart';
import 'package:ml_linalg/src/matrix/float32_matrix.dart';
import 'package:ml_linalg/src/matrix/float64_matrix.g.dart';
import 'package:ml_linalg/src/matrix/matrix_cache_keys.dart';
import 'package:ml_linalg/src/matrix/matrix_factory.dart';
import 'package:ml_linalg/vector.dart';

class MatrixFactoryImpl implements MatrixFactory {
  MatrixFactoryImpl(this._cacheFactory);

  final CacheManagerFactory _cacheFactory;

  @override
  Matrix fromList(DType dtype, List<List<double>> source) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix(
          Float32MatrixDataManager.fromList(source),
          _cacheFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return Float64Matrix(
          Float64MatrixDataManager.fromList(source),
          _cacheFactory.create(matrixCacheKeys),
        );

      default:
        throw UnimplementedError(
            'Matrix of type $dtype is not implemented yet');
    }
  }

  @override
  Matrix fromRows(DType dtype, List<Vector> source) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix(
          Float32MatrixDataManager.fromRows(source),
          _cacheFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return Float64Matrix(
          Float64MatrixDataManager.fromRows(source),
          _cacheFactory.create(matrixCacheKeys),
        );

      default:
        throw UnimplementedError(
            'Matrix of type $dtype is not implemented yet');
    }
  }

  @override
  Matrix fromColumns(DType dtype, List<Vector> source) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix(
          Float32MatrixDataManager.fromColumns(source),
          _cacheFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return Float64Matrix(
          Float64MatrixDataManager.fromColumns(source),
          _cacheFactory.create(matrixCacheKeys),
        );

      default:
        throw UnimplementedError(
            'Matrix of type $dtype is not implemented yet');
    }
  }

  @override
  Matrix empty(DType dtype) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix(
          Float32MatrixDataManager.fromList([]),
          _cacheFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return Float64Matrix(
          Float64MatrixDataManager.fromList([]),
          _cacheFactory.create(matrixCacheKeys),
        );

      default:
        throw UnimplementedError(
            'Matrix of type $dtype is not implemented yet');
    }
  }

  @override
  Matrix fromFlattenedList(
      DType dtype, List<double> source, int rowsNum, int columnsNum) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix(
          Float32MatrixDataManager.fromFlattened(source, rowsNum, columnsNum),
          _cacheFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return Float64Matrix(
          Float64MatrixDataManager.fromFlattened(source, rowsNum, columnsNum),
          _cacheFactory.create(matrixCacheKeys),
        );

      default:
        throw UnimplementedError(
            'Matrix of type $dtype is not implemented yet');
    }
  }

  @override
  Matrix fromByteData(DType dtype, ByteData data, int rowsNum, int columnsNum) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix(
          Float32MatrixDataManager.fromByteData(data, rowsNum, columnsNum),
          _cacheFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return Float64Matrix(
          Float64MatrixDataManager.fromByteData(data, rowsNum, columnsNum),
          _cacheFactory.create(matrixCacheKeys),
        );

      default:
        throw UnimplementedError(
            'Matrix of type $dtype is not implemented yet');
    }
  }

  @override
  Matrix diagonal(DType dtype, List<double> source) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix(
          Float32MatrixDataManager.diagonal(source),
          _cacheFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return Float64Matrix(
          Float64MatrixDataManager.diagonal(source),
          _cacheFactory.create(matrixCacheKeys),
        );

      default:
        throw UnimplementedError(
            'Matrix of type $dtype is not implemented yet');
    }
  }

  @override
  Matrix scalar(DType dtype, double scalar, int size) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix(
          Float32MatrixDataManager.scalar(scalar, size),
          _cacheFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return Float64Matrix(
          Float64MatrixDataManager.scalar(scalar, size),
          _cacheFactory.create(matrixCacheKeys),
        );

      default:
        throw UnimplementedError(
            'Matrix of type $dtype is not implemented yet');
    }
  }

  @override
  Matrix identity(DType dtype, int size) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix(
          Float32MatrixDataManager.scalar(1.0, size),
          _cacheFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return Float64Matrix(
          Float64MatrixDataManager.scalar(1.0, size),
          _cacheFactory.create(matrixCacheKeys),
        );

      default:
        throw UnimplementedError(
            'Matrix of type $dtype is not implemented yet');
    }
  }

  @override
  Matrix row(DType dtype, List<double> source) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix(
          Float32MatrixDataManager.fromRows(
              [Vector.fromList(source, dtype: dtype)]),
          _cacheFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return Float64Matrix(
          Float64MatrixDataManager.fromRows(
              [Vector.fromList(source, dtype: dtype)]),
          _cacheFactory.create(matrixCacheKeys),
        );

      default:
        throw UnimplementedError(
            'Matrix of type $dtype is not implemented yet');
    }
  }

  @override
  Matrix column(DType dtype, List<double> source) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix(
          Float32MatrixDataManager.fromColumns(
              ([Vector.fromList(source, dtype: dtype)])),
          _cacheFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return Float64Matrix(
          Float64MatrixDataManager.fromColumns(
              ([Vector.fromList(source, dtype: dtype)])),
          _cacheFactory.create(matrixCacheKeys),
        );

      default:
        throw UnimplementedError(
            'Matrix of type $dtype is not implemented yet');
    }
  }

  @override
  Matrix random(DType dtype, int rowsNum, int columnsCount,
      {num min = -1000, num max = 1000, int? seed}) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix(
          Float32MatrixDataManager.random(dtype, rowsNum, columnsCount,
              min: min, max: max, seed: seed),
          _cacheFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return Float64Matrix(
          Float64MatrixDataManager.random(dtype, rowsNum, columnsCount,
              min: min, max: max, seed: seed),
          _cacheFactory.create(matrixCacheKeys),
        );

      default:
        throw UnimplementedError(
            'Matrix of type $dtype is not implemented yet');
    }
  }

  @override
  Matrix randomSPD(DType dtype, int size,
      {num min = -1000, num max = 1000, int? seed}) {
    final A =
        Matrix.random(size, size, dtype: dtype, max: max, min: min, seed: seed);

    return A * A.transpose() + Matrix.scalar(size * 1.0, size, dtype: dtype);
  }
}
