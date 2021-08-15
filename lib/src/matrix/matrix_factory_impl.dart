import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager_factory.dart';
import 'package:ml_linalg/src/matrix/data_manager/float32_matrix_data_manager.dart';
import 'package:ml_linalg/src/matrix/data_manager/float64_matrix_data_manager.dart';
import 'package:ml_linalg/src/matrix/matrix_cache_keys.dart';
import 'package:ml_linalg/src/matrix/matrix_factory.dart';
import 'package:ml_linalg/src/matrix/matrix_impl.dart';
import 'package:ml_linalg/vector.dart';

class MatrixFactoryImpl implements MatrixFactory {
  MatrixFactoryImpl(this._cacheManagerFactory);

  final CacheManagerFactory _cacheManagerFactory;

  @override
  Matrix fromList(DType dtype, List<List<double>> source) {
    switch (dtype) {
      case DType.float32:
        return MatrixImpl(
          Float32MatrixDataManager.fromList(source),
          _cacheManagerFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return MatrixImpl(
          Float64MatrixDataManager.fromList(source),
          _cacheManagerFactory.create(matrixCacheKeys),
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
        return MatrixImpl(
          Float32MatrixDataManager.fromRows(source),
          _cacheManagerFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return MatrixImpl(
          Float64MatrixDataManager.fromRows(source),
          _cacheManagerFactory.create(matrixCacheKeys),
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
        return MatrixImpl(
          Float32MatrixDataManager.fromColumns(source),
          _cacheManagerFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return MatrixImpl(
          Float64MatrixDataManager.fromColumns(source),
          _cacheManagerFactory.create(matrixCacheKeys),
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
        return MatrixImpl(
          Float32MatrixDataManager.fromList([]),
          _cacheManagerFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return MatrixImpl(
          Float64MatrixDataManager.fromList([]),
          _cacheManagerFactory.create(matrixCacheKeys),
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
        return MatrixImpl(
          Float32MatrixDataManager.fromFlattened(source, rowsNum, columnsNum),
          _cacheManagerFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return MatrixImpl(
          Float64MatrixDataManager.fromFlattened(source, rowsNum, columnsNum),
          _cacheManagerFactory.create(matrixCacheKeys),
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
        return MatrixImpl(
          Float32MatrixDataManager.diagonal(source),
          _cacheManagerFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return MatrixImpl(
          Float64MatrixDataManager.diagonal(source),
          _cacheManagerFactory.create(matrixCacheKeys),
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
        return MatrixImpl(
          Float32MatrixDataManager.scalar(scalar, size),
          _cacheManagerFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return MatrixImpl(
          Float64MatrixDataManager.scalar(scalar, size),
          _cacheManagerFactory.create(matrixCacheKeys),
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
        return MatrixImpl(
          Float32MatrixDataManager.scalar(1.0, size),
          _cacheManagerFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return MatrixImpl(
          Float64MatrixDataManager.scalar(1.0, size),
          _cacheManagerFactory.create(matrixCacheKeys),
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
        return MatrixImpl(
          Float32MatrixDataManager.fromRows(
              [Vector.fromList(source, dtype: dtype)]),
          _cacheManagerFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return MatrixImpl(
          Float64MatrixDataManager.fromRows(
              [Vector.fromList(source, dtype: dtype)]),
          _cacheManagerFactory.create(matrixCacheKeys),
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
        return MatrixImpl(
          Float32MatrixDataManager.fromColumns(
              ([Vector.fromList(source, dtype: dtype)])),
          _cacheManagerFactory.create(matrixCacheKeys),
        );

      case DType.float64:
        return MatrixImpl(
          Float64MatrixDataManager.fromColumns(
              ([Vector.fromList(source, dtype: dtype)])),
          _cacheManagerFactory.create(matrixCacheKeys),
        );

      default:
        throw UnimplementedError(
            'Matrix of type $dtype is not implemented yet');
    }
  }
}
