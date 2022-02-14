import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ml_linalg/axis.dart';
import 'package:ml_linalg/decomposition.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/inverse.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/matrix_norm.dart';
import 'package:ml_linalg/sort_direction.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager.dart';
import 'package:ml_linalg/src/common/exception/backward_substitution_non_square_matrix_exception.dart';
import 'package:ml_linalg/src/common/exception/cholesky_inappropriate_matrix_exception.dart';
import 'package:ml_linalg/src/common/exception/cholesky_non_square_matrix_exception.dart';
import 'package:ml_linalg/src/common/exception/forward_substitution_non_square_matrix_exception.dart';
import 'package:ml_linalg/src/common/exception/lu_decomposition_non_square_matrix_exception.dart';
import 'package:ml_linalg/src/common/exception/matrix_division_by_vector_exception.dart';
import 'package:ml_linalg/src/common/exception/square_matrix_division_by_vector_exception.dart';
import 'package:ml_linalg/src/matrix/data_manager/matrix_data_manager.dart';
import 'package:ml_linalg/src/matrix/matrix_cache_keys.dart';
import 'package:ml_linalg/src/matrix/mixin/matrix_validator_mixin.dart';
import 'package:ml_linalg/src/matrix/serialization/matrix_to_json.dart';
import 'package:ml_linalg/vector.dart';
import 'package:quiver/iterables.dart';

class Float32Matrix
    with IterableMixin<Iterable<double>>, MatrixValidatorMixin
    implements Matrix {
  Float32Matrix(
    this._dataManager,
    this._cacheManager,
  );

  final MatrixDataManager _dataManager;
  final CacheManager _cacheManager;

  @override
  DType get dtype => _dataManager.dtype;

  @override
  int get rowsNum => _dataManager.rowsNum;

  @override
  int get columnsNum => _dataManager.columnsNum;

  @override
  bool get hasData => _dataManager.hasData;

  @override
  bool get isSquare => columnsNum == rowsNum;

  @override
  Iterator<Iterable<double>> get iterator => _dataManager.iterator;

  @override
  Matrix operator +(Object value) {
    if (value is Matrix) {
      return _matrixAdd(value);
    }

    if (value is num) {
      return _matrixScalarAdd(value.toDouble());
    }

    throw UnsupportedError(
        'Cannot add a ${value.runtimeType} to a $runtimeType');
  }

  @override
  Matrix operator -(Object value) {
    if (value is Matrix) {
      return _matrixSub(value);
    }

    if (value is num) {
      return _matrixScalarSub(value.toDouble());
    }

    throw UnsupportedError(
        'Cannot subtract a ${value.runtimeType} from a $runtimeType');
  }

  /// Mathematical matrix multiplication
  ///
  /// The main rule:
  ///
  /// let `N` be a number of columns, so the multiplication is
  /// available only for X by N * N by Y matrices, that causes X by Y matrix
  @override
  Matrix operator *(Object value) {
    if (value is Vector) {
      return _matrixVectorMul(value);
    }

    if (value is Matrix) {
      return _matrixMul(value);
    }

    if (value is num) {
      return _matrixScalarMul(value.toDouble());
    }

    throw UnsupportedError(
        'Cannot multiple a $runtimeType by a ${value.runtimeType}');
  }

  /// Performs division of the matrix by vector, matrix or scalar
  @override
  Matrix operator /(Object value) {
    if (value is Vector) {
      return _matrixByVectorDiv(value);
    }

    if (value is Matrix) {
      return _matrixByMatrixDiv(value);
    }

    if (value is num) {
      return _matrixByScalarDiv(value.toDouble());
    }

    throw UnsupportedError(
        'Cannot divide a $runtimeType by a ${value.runtimeType}');
  }

  @override
  Vector operator [](int index) => getRow(index);

  @override
  Matrix transpose() {
    final source = List.generate(rowsNum, getRow);

    return Matrix.fromColumns(source, dtype: dtype);
  }

  @override
  Vector getRow(int index) => _dataManager.getRow(index);

  @override
  Vector getColumn(int index) => _dataManager.getColumn(index);

  @override
  Matrix sample({
    Iterable<int> rowIndices = const [],
    Iterable<int> columnIndices = const [],
  }) {
    final indices = rowIndices.isEmpty
        ? count(0).take(rowsNum).map((i) => i.toInt())
        : rowIndices;
    final targetMatrixSource = indices.map((index) {
      final sourceRow = getRow(index);

      return columnIndices.isEmpty
          ? sourceRow
          : sourceRow.sample(columnIndices);
    }).toList(growable: false);

    return Matrix.fromRows(targetMatrixSource, dtype: dtype);
  }

  @override
  Vector reduceColumns(
    Vector Function(Vector combine, Vector vector) combiner, {
    Vector? initValue,
  }) =>
      _reduce(
        combiner,
        columnsNum,
        getColumn,
        initValue: initValue,
      );

  @override
  Vector reduceRows(Vector Function(Vector combine, Vector vector) combiner,
          {Vector? initValue}) =>
      _reduce(
        combiner,
        rowsNum,
        getRow,
        initValue: initValue,
      );

  @override
  Matrix mapElements(double Function(double element) mapper) =>
      _dataManager.areAllRowsCached
          ? mapRows((row) => row.mapToVector(mapper))
          : mapColumns((column) => column.mapToVector(mapper));

  @override
  Matrix mapColumns(Vector Function(Vector columns) mapper) =>
      Matrix.fromColumns(
          List.generate(columnsNum, (int i) => mapper(getColumn(i))),
          dtype: dtype);

  @override
  Matrix mapRows(Vector Function(Vector row) mapper) =>
      Matrix.fromRows(List.generate(rowsNum, (int i) => mapper(getRow(i))),
          dtype: dtype);

  @override
  Matrix uniqueRows() {
    final checked = <Vector>[];

    for (final i in _dataManager.rowIndices) {
      final row = getRow(i);

      if (!checked.contains(row)) {
        checked.add(row);
      }
    }

    return Matrix.fromRows(checked, dtype: dtype);
  }

  @override
  Vector mean([Axis axis = Axis.columns]) {
    if (!hasData) {
      return Vector.empty(dtype: dtype);
    }

    switch (axis) {
      case Axis.columns:
        return _cacheManager.retrieveValue(
            matrixMeansByColumnsKey, () => _mean(columns));

      case Axis.rows:
        return _cacheManager.retrieveValue(
            matrixMeansByRowsKey, () => _mean(rows));

      default:
        throw UnimplementedError(
            'Mean values calculation for axis $axis is not '
            'supported yet');
    }
  }

  Vector _mean(Iterable<Vector> vectors) =>
      Vector.fromList(vectors.map((vector) => vector.mean()).toList(),
          dtype: dtype);

  @override
  Vector deviation([Axis axis = Axis.columns]) {
    if (!hasData) {
      return Vector.empty(dtype: dtype);
    }

    final means = mean(axis);

    switch (axis) {
      case Axis.columns:
        return _cacheManager.retrieveValue(matrixDeviationByColumnsKey,
            () => _deviation(rows, means, rowsNum));

      case Axis.rows:
        return _cacheManager.retrieveValue(matrixDeviationByRowsKey,
            () => _deviation(columns, means, columnsNum));

      default:
        throw UnimplementedError('Deviation calculation for axis $axis is not '
            'supported yet');
    }
  }

  Vector _deviation(Iterable<Vector> vectors, Vector means, int vectorsNum) =>
      vectors
          .map((vector) => (vector - means) * (vector - means))
          .reduce((summed, vector) => summed + vector)
          .scalarDiv(vectorsNum)
          .sqrt();

  @override
  Vector toVector() {
    if (columnsNum == 1) {
      return getColumn(0);
    }

    if (rowsNum == 1) {
      return getRow(0);
    }

    throw Exception(
        'Cannot convert $rowsNum x $columnsNum matrix into a vector');
  }

  @override
  String toString() {
    final columnsLimit = 5;
    final rowsLimit = 5;
    final eol = columnsNum > columnsLimit ? ', ...)' : ')';
    var result = 'Matrix $rowsNum x $columnsNum:\n';
    var i = 1;

    for (final row in this) {
      if (i > rowsLimit) {
        result += '...';
        break;
      }
      result =
          '$result${row.take(columnsLimit).toString().replaceAll(RegExp(r'\)$'), '')}$eol\n';
      i++;
    }

    return result;
  }

  @override
  double max() => _findExtrema((Vector row) => row.max());

  @override
  double min() => _findExtrema((Vector row) => row.min());

  @override
  double norm([MatrixNorm norm = MatrixNorm.frobenius]) {
    switch (norm) {
      case MatrixNorm.frobenius:
        // ignore: deprecated_member_use_from_same_package
        return math.sqrt(reduceRows((sum, row) => sum + row.pow(2)).sum());
      default:
        throw UnsupportedError('Unsupported matrix norm type: $norm');
    }
  }

  @override
  Matrix insertColumns(int targetIndex, List<Vector> columns) {
    final columnsIterator = columns.iterator;
    final indices =
        count(0).take(columnsNum + columns.length).map((i) => i.toInt());
    final newColumns = indices.map((index) {
      if (index < targetIndex) {
        return getColumn(index);
      }

      if (index < (targetIndex + columns.length)) {
        return (columnsIterator..moveNext()).current;
      }

      return getColumn(index - columns.length);
    }).toList(growable: false);

    return Matrix.fromColumns(newColumns, dtype: dtype);
  }

  @override
  Matrix sort(double Function(Vector vector) selectSortValue,
      [Axis axis = Axis.rows, SortDirection sortDir = SortDirection.asc]) {
    final doSort =
        (Iterable<Vector> source) => _doSort(source, sortDir, selectSortValue);

    switch (axis) {
      case Axis.rows:
        return Matrix.fromRows(doSort(rows), dtype: dtype);

      case Axis.columns:
        return Matrix.fromColumns(doSort(columns), dtype: dtype);

      default:
        throw UnsupportedError('Unsupported axis type $axis');
    }
  }

  List<Vector> _doSort(Iterable<Vector> source, SortDirection sortDir,
      double Function(Vector vector) selector) {
    final dir = sortDir == SortDirection.asc ? 1 : -1;

    return source.toList(growable: false)
      ..sort((row1, row2) => (selector(row1) - selector(row2)) ~/ dir);
  }

  @override
  Iterable<Vector> get rows => _dataManager.rowIndices.map(getRow);

  @override
  Iterable<Vector> get columns => _dataManager.columnIndices.map(getColumn);

  @override
  Iterable<int> get rowIndices => _dataManager.rowIndices;

  @override
  Iterable<int> get columnIndices => _dataManager.columnIndices;

  @override
  Matrix fastMap<T>(T Function(T element) mapper) {
    final source = List.generate(rowsNum, (int i) => getRow(i).fastMap(mapper));

    return Matrix.fromRows(source, dtype: dtype);
  }

  @override
  Matrix pow(num exponent) => _dataManager.areAllRowsCached
      ? Matrix.fromRows(rows.map((row) => row.pow(exponent)).toList(),
          dtype: dtype)
      : Matrix.fromColumns(
          columns.map((column) => column.pow(exponent)).toList(),
          dtype: dtype);

  @override
  Matrix exp({bool skipCaching = false}) => _cacheManager.retrieveValue(
      matrixExpKey,
      () => _dataManager.areAllRowsCached
          ? Matrix.fromRows(
              rows
                  .map((row) => row.exp(
                        skipCaching: skipCaching,
                      ))
                  .toList(),
              dtype: dtype)
          : Matrix.fromColumns(
              columns
                  .map((column) => column.exp(
                        skipCaching: skipCaching,
                      ))
                  .toList(),
              dtype: dtype),
      skipCaching: skipCaching);

  @override
  Matrix log({bool skipCaching = false}) => _cacheManager.retrieveValue(
      matrixLogKey,
      () => _dataManager.areAllRowsCached
          ? Matrix.fromRows(
              rows
                  .map((row) => row.log(
                        skipCaching: skipCaching,
                      ))
                  .toList(),
              dtype: dtype)
          : Matrix.fromColumns(
              columns
                  .map((column) => column.log(
                        skipCaching: skipCaching,
                      ))
                  .toList(),
              dtype: dtype),
      skipCaching: skipCaching);

  @override
  Matrix multiply(Matrix other) {
    checkShape(this, other, errorMessage: 'Cannot find Hadamard product');

    return _dataManager.areAllRowsCached
        ? Matrix.fromRows(
            zip([rows, other.rows])
                .map((pair) => pair.first * pair.last)
                .toList(),
            dtype: dtype)
        : Matrix.fromColumns(
            zip([columns, other.columns])
                .map((pair) => pair.first * pair.last)
                .toList(),
            dtype: dtype);
  }

  @override
  double sum() {
    if (!hasData) {
      return double.nan;
    }

    return _cacheManager.retrieveValue(
        matrixSumKey,
        () => _dataManager.areAllRowsCached
            ? rows.fold(0, (result, row) => result + row.sum())
            : columns.fold(0, (result, column) => result + column.sum()));
  }

  @override
  double prod() {
    if (!hasData) {
      return double.nan;
    }

    return _cacheManager.retrieveValue(
        matrixProdKey,
        () => _dataManager.areAllRowsCached
            ? rows.fold(0, (result, row) => result * row.prod())
            : columns.fold(0, (result, column) => result * column.prod()));
  }

  @override
  Iterable<Matrix> decompose(
      [Decomposition decompositionType = Decomposition.LU]) {
    switch (decompositionType) {
      case Decomposition.cholesky:
        return _choleskyDecomposition();

      case Decomposition.LU:
        return _luDecomposition();

      default:
        throw UnimplementedError(
            'Unimplemented decomposition type $decompositionType');
    }
  }

  @override
  Matrix inverse([Inverse inverseType = Inverse.LU]) {
    switch (inverseType) {
      case Inverse.cholesky:
        return _choleskyInverse();

      case Inverse.LU:
        return _luInverse();

      case Inverse.forwardSubstitution:
        return _forwardSubstitutionInverse();

      case Inverse.backwardSubstitution:
        return _backwardSubstitutionInverse();

      default:
        throw UnimplementedError('Unimplemented inverse type $inverseType');
    }
  }

  Matrix _choleskyInverse() {
    final matrices = decompose(Decomposition.cholesky);
    final lower = matrices.first;
    final lowerInverted = lower.inverse(Inverse.forwardSubstitution);

    return lowerInverted.transpose() * lowerInverted;
  }

  Matrix _luInverse() {
    final matrices = decompose(Decomposition.LU);
    final lower = matrices.first;
    final upper = matrices.last;

    return upper.inverse(Inverse.backwardSubstitution) *
        lower.inverse(Inverse.forwardSubstitution);
  }

  Matrix _forwardSubstitutionInverse() {
    if (!isSquare) {
      throw ForwardSubstitutionNonSquareMatrixException(rowsNum, columnsNum);
    }

    final zeroes = List.filled(rowsNum, 0.0);
    final generator = (_) => Float32List.fromList(zeroes);
    final X = List.generate(rowsNum, generator);

    for (var i = 0; i < rowsNum; i++) {
      for (var row = 0; row < rowsNum; row++) {
        var sum = 0.0;
        var b = row == i ? 1.0 : 0.0;

        for (var col = 0; col < row; col++) {
          sum += this[row][col] * X[col][i];
        }

        X[row][i] = (b - sum) / this[row][row];
      }
    }

    return Matrix.fromList(X, dtype: dtype);
  }

  Matrix _backwardSubstitutionInverse() {
    if (!isSquare) {
      throw BackwardSubstitutionNonSquareMatrixException(rowsNum, columnsNum);
    }

    final X = List.generate(rowsNum, (index) => List.filled(rowsNum, 0.0));

    for (var i = rowsNum - 1; i >= 0; i--) {
      for (var row = rowsNum - 1; row >= 0; row--) {
        var sum = 0.0;
        var b = row == i ? 1.0 : 0.0;

        for (var col = rowsNum - 1; col > row; col--) {
          sum += this[row][col] * X[col][i];
        }

        X[row][i] = (b - sum) / this[row][row];
      }
    }

    return Matrix.fromList(X, dtype: dtype);
  }

  Iterable<Matrix> _choleskyDecomposition() {
    if (!isSquare) {
      throw CholeskyNonSquareMatrixException(rowsNum, columnsNum);
    }

    final zeroes = List.filled(rowsNum, 0.0);
    final generator = (_) => Float32List.fromList(zeroes);
    final lower = List.generate(rowsNum, generator);

    for (var i = 0; i < rowsNum; i++) {
      for (var j = 0; j <= i; j++) {
        var sum = 0.0;

        for (var k = 0; k < j; k++) {
          sum += (lower[i][k] * lower[j][k]);
        }

        if (j == i) {
          lower[j][j] = math.sqrt(this[j][j] - sum);

          if (lower[j][j].isNaN) {
            throw CholeskyInappropriateMatrixException();
          }
        } else {
          lower[i][j] = (this[i][j] - sum) / lower[j][j];
        }
      }
    }

    final lowerMatrix = Matrix.fromList(lower, dtype: dtype);
    final upperMatrix = lowerMatrix.transpose();

    return [lowerMatrix, upperMatrix];
  }

  Iterable<Matrix> _luDecomposition() {
    if (!isSquare) {
      throw LUDecompositionNonSquareMatrixException(rowsNum, columnsNum);
    }

    final L = List.generate(
        rowsNum,
        (i) => Float32List.fromList(
            List.generate(rowsNum, (j) => i == j ? 1.0 : 0.0)));
    final zeroes = List.filled(rowsNum, 0.0);
    final uGenerator = (i) => Float32List.fromList(zeroes);
    final U = List.generate(rowsNum, uGenerator);

    for (var i = 0; i < rowsNum; i++) {
      for (var j = 0; j < rowsNum; j++) {
        var sum = 0.0;

        for (var k = 0; k < i; k++) {
          sum += L[i][k] * U[k][j];
        }

        if (i <= j) {
          U[i][j] = this[i][j] - sum;
        } else {
          L[i][j] = (this[i][j] - sum) / U[j][j];
        }
      }
    }

    return [Matrix.fromList(L, dtype: dtype), Matrix.fromList(U, dtype: dtype)];
  }

  @override
  Map<String, dynamic> toJson() => matrixToJson(this)!;

  double _findExtrema(double Function(Vector vector) callback) {
    final rowIterator = rows.iterator;
    final minValues = List<double>.generate(
        rowsNum, (i) => callback((rowIterator..moveNext()).current));

    return callback(Vector.fromList(minValues, dtype: dtype));
  }

  Vector _reduce(Vector Function(Vector combine, Vector vector) combiner,
      int length, Vector Function(int index) getVector,
      {Vector? initValue}) {
    var reduced = initValue ?? getVector(0);
    final startIndex = initValue != null ? 0 : 1;

    for (var i = startIndex; i < length; i++) {
      reduced = combiner(reduced, getVector(i));
    }

    return reduced;
  }

  Matrix _matrixVectorMul(Vector vector) {
    if (vector.length != columnsNum) {
      throw Exception(
          'Matrix column count and vector length mismatch, matrix column count: $columnsNum, vector length: ${vector.length}');
    }

    final generateElement = (int i) => vector.dot(getRow(i));
    final source = List.generate(rowsNum, generateElement);
    final vectorColumn = Vector.fromList(source, dtype: dtype);

    return Matrix.fromColumns([vectorColumn], dtype: dtype);
  }

  Matrix _matrixMul(Matrix matrix) {
    checkColumnsAndRowsNumber(this, matrix);
    final source = rows.map((row) => row * matrix).toList();

    return Matrix.fromRows(source, dtype: dtype);
  }

  Matrix _matrixByVectorDiv(Vector vector) {
    if (isSquare) {
      throw SquareMatrixDivisionByVectorException(rowsNum, columnsNum);
    }

    if (vector.length == rowsNum) {
      return mapColumns((column) => column / vector);
    }

    if (vector.length == columnsNum) {
      return mapRows((row) => row / vector);
    }

    throw MatrixDivisionByVectorException(rowsNum, columnsNum, vector.length);
  }

  Matrix _matrixByMatrixDiv(Matrix matrix) {
    checkShape(this, matrix,
        errorMessage: 'Cannot perform matrix by matrix '
            'division');

    return _matrix2matrixOperation(
        matrix, (Vector first, Vector second) => first / second);
  }

  Matrix _matrixAdd(Matrix matrix) {
    checkShape(this, matrix, errorMessage: 'Cannot perform matrix addition');

    return _matrix2matrixOperation(
        matrix, (Vector first, Vector second) => first + second);
  }

  Matrix _matrixSub(Matrix matrix) {
    checkShape(this, matrix, errorMessage: 'Cannot perform matrix subtraction');

    return _matrix2matrixOperation(
        matrix, (Vector first, Vector second) => first - second);
  }

  Matrix _matrixScalarAdd(double scalar) => _matrix2scalarOperation(
      scalar, (double val, Vector vector) => vector + val);

  Matrix _matrixScalarSub(double scalar) => _matrix2scalarOperation(
      scalar, (double val, Vector vector) => vector - val);

  Matrix _matrixScalarMul(double scalar) => _matrix2scalarOperation(
      scalar, (double val, Vector vector) => vector * val);

  Matrix _matrixByScalarDiv(double scalar) => _matrix2scalarOperation(
      scalar, (double val, Vector vector) => vector / val);

  Matrix _matrix2matrixOperation(
      Matrix matrix, Vector Function(Vector first, Vector second) operation) {
    final elementGenFn = (int i) => operation(getRow(i), matrix.getRow(i));
    final source = List<Vector>.generate(rowsNum, elementGenFn);

    return Matrix.fromRows(source, dtype: dtype);
  }

  Matrix _matrix2scalarOperation(
      double scalar, Vector Function(double scalar, Vector vector) operation) {
    // TODO: use vectorized type (e.g. Float32x4) instead of `double`
    // TODO: use then `fastMap` to accelerate computations
    final elementGenFn = (int i) => operation(scalar, getRow(i));
    final source = List.generate(rowsNum, elementGenFn);

    return Matrix.fromRows(source, dtype: dtype);
  }
}
