import 'dart:collection';
import 'dart:math' as math;

import 'package:ml_linalg/axis.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/matrix_norm.dart';
import 'package:ml_linalg/sort_direction.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager.dart';
import 'package:ml_linalg/src/common/exception/matrix_division_by_vector_exception.dart';
import 'package:ml_linalg/src/common/exception/square_matrix_division_by_vector_exception.dart';
import 'package:ml_linalg/src/matrix/data_manager/matrix_data_manager.dart';
import 'package:ml_linalg/src/matrix/matrix_cache_keys.dart';
import 'package:ml_linalg/src/matrix/mixin/matrix_validator_mixin.dart';
import 'package:ml_linalg/src/matrix/serialization/matrix_to_json.dart';
import 'package:ml_linalg/vector.dart';
import 'package:quiver/iterables.dart';

class MatrixImpl with IterableMixin<Iterable<double>>, MatrixValidatorMixin
    implements Matrix {

  MatrixImpl(this._dataManager, this._cacheManager);

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
    } else if (value is num) {
      return _matrixScalarAdd(value.toDouble());
    } else {
      throw UnsupportedError(
          'Cannot add a ${value.runtimeType} to a ${runtimeType}');
    }
  }

  @override
  Matrix operator -(Object value) {
    if (value is Matrix) {
      return _matrixSub(value);
    } else if (value is num) {
      return _matrixScalarSub(value.toDouble());
    } else {
      throw UnsupportedError(
          'Cannot subtract a ${value.runtimeType} from a ${runtimeType}');
    }
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
    } else if (value is Matrix) {
      return _matrixMul(value);
    } else if (value is num) {
      return _matrixScalarMul(value.toDouble());
    } else {
      throw UnsupportedError(
          'Cannot multiple a ${runtimeType} and a ${value.runtimeType}');
    }
  }

  /// Performs division of the matrix by vector, matrix or scalar
  @override
  Matrix operator /(Object value) {
    if (value is Vector) {
      return _matrixByVectorDiv(value);
    } else if (value is Matrix) {
      return _matrixByMatrixDiv(value);
    } else if (value is num) {
      return _matrixByScalarDiv(value.toDouble());
    } else {
      throw UnsupportedError(
          'Cannot divide a ${runtimeType} by a ${value.runtimeType}');
    }
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
    final rowsNumber = rowIndices.isEmpty
        ? rowsNum
        : rowIndices.length;

    final targetMatrixSource = List<Vector>(rowsNumber);
    for (final indexed in enumerate(rowIndices.isEmpty
        ? count(0).take(rowsNum).map((i) => i.toInt())
        : rowIndices)
    ) {
      final targetRowIndex = indexed.index;
      final sourceRowIndex = indexed.value;
      final sourceRow = getRow(sourceRowIndex);
      targetMatrixSource[targetRowIndex] = columnIndices.isEmpty
          ? sourceRow : sourceRow.sample(columnIndices);
    }
    return Matrix.fromRows(targetMatrixSource, dtype: dtype);
  }

  @override
  Vector reduceColumns(
          Vector Function(Vector combine, Vector vector) combiner,
          {Vector initValue}) =>
      _reduce(combiner, columnsNum, getColumn, initValue: initValue);

  @override
  Vector reduceRows(
          Vector Function(Vector combine, Vector vector) combiner,
          {Vector initValue}) =>
      _reduce(combiner, rowsNum, getRow, initValue: initValue);

  @override
  Matrix mapColumns(Vector mapper(Vector columns)) =>
      Matrix.fromColumns(List.generate(columnsNum,
              (int i) => mapper(getColumn(i))), dtype: dtype);

  @override
  Matrix mapRows(Vector mapper(Vector row)) =>
      Matrix.fromRows(List.generate(rowsNum,
              (int i) => mapper(getRow(i))), dtype: dtype);

  @override
  Matrix uniqueRows() {
    // TODO: consider using Set instead of List
    final checked = <Vector>[];
    for (final i in _dataManager.rowIndices) {
      final row = getRow(i);
      if (!checked.contains(row)) checked.add(row);
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
        return _cacheManager
            .retrieveValue(meansByColumnsKey, () => _mean(columns));

      case Axis.rows:
        return _cacheManager
            .retrieveValue(meansByRowsKey, () => _mean(rows));

      default:
        throw UnimplementedError('Mean values calculation for axis $axis is not '
            'implemented yet');
    }
  }

  Vector _mean(Iterable<Vector> vectors) =>
      Vector.fromList(
        vectors.map((vector) => vector.mean()).toList(),
        dtype: dtype);

  @override
  Vector deviation([Axis axis = Axis.columns]) {
    if (!hasData) {
      return Vector.empty(dtype: dtype);
    }

    final means = mean(axis);

    switch (axis) {
      case Axis.columns:
        return _cacheManager.retrieveValue(deviationByColumnsKey,
                () => _deviation(rows, means, rowsNum));

      case Axis.rows:
        return _cacheManager.retrieveValue(deviationByRowsKey,
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
    } else if (rowsNum == 1) {
      return getRow(0);
    }
    throw Exception(
        'Cannot convert ${rowsNum} x ${columnsNum} matrix into a vector');
  }

  @override
  String toString() {
    final columnsLimit = 5;
    final rowsLimit = 5;
    final eol = columnsNum > columnsLimit ? ', ...)' : ')';
    String result = 'Matrix $rowsNum x $columnsNum:\n';
    int i = 1;
    for (final row in this) {
      if (i > rowsLimit) {
        result += '...';
        break;
      }
      result =
          '$result${row.take(columnsLimit).toString()
              .replaceAll(RegExp(r'\)$'), '')}$eol\n';
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
        return math.sqrt(reduceRows((sum, row) => sum + row.toIntegerPower(2))
            .sum());
      default:
        throw UnsupportedError('Unsupported matrix norm type - $norm');
    }
  }

  @override
  Matrix insertColumns(int targetIdx, List<Vector> columns) {
    final newColumns = List<Vector>(columnsNum + columns.length)
      ..setRange(targetIdx, targetIdx + columns.length, columns);
    var i = 0;
    for (final column in this.columns) {
      if (i == targetIdx) i += columns.length;
      newColumns[i++] = column;
    }
    return Matrix.fromColumns(newColumns, dtype: dtype);
  }

  @override
  Matrix sort(double selectSortValue(Vector vector), [Axis axis = Axis.rows,
    SortDirection sortDir = SortDirection.asc]) {
    final doSort =
        (Iterable<Vector> source) => _doSort(source, sortDir, selectSortValue);
    switch (axis) {
      case Axis.rows:
        return Matrix.fromRows(doSort(rows), dtype: dtype);
      case Axis.columns:
        return Matrix.fromColumns(doSort(columns), dtype: dtype);
      default:
        throw UnsupportedError('Unsupported axis type ${axis}');
    }
  }

  List<Vector> _doSort(Iterable<Vector> source, SortDirection sortDir,
      double selector(Vector vector)) {
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
  Matrix fastMap<T>(T mapper(T element)) {
    final source = List.generate(
        rowsNum, (int i) => getRow(i).fastMap(mapper));
    return Matrix.fromRows(source, dtype: dtype);
  }

  @override
  Map<String, dynamic> toJson() => matrixToJson(this);

  double _findExtrema(double callback(Vector vector)) {
    int i = 0;
    final minValues = List<double>(rowsNum);
    for (final row in rows) {
      minValues[i++] = callback(row);
    }
    return callback(Vector.fromList(minValues, dtype: dtype));
  }

  Vector _reduce(
      Vector combiner(Vector combine, Vector vector),
      int length,
      Vector getVector(int index),
      {Vector initValue}) {
    var reduced = initValue ?? getVector(0);
    final startIndex = initValue != null ? 0 : 1;
    for (int i = startIndex; i < length; i++) {
      reduced = combiner(reduced, getVector(i));
    }
    return reduced;
  }

  Matrix _matrixVectorMul(Vector vector) {
    if (vector.length != columnsNum) {
      throw Exception(
          'The dimension of the vector ${vector} and the columns number of '
              'matrix ${this} mismatch');
    }
    final generateElement = (int i) => vector.dot(getRow(i));
    final source = List.generate(rowsNum, generateElement);
    final vectorColumn = Vector.fromList(source, dtype: dtype);
    return Matrix.fromColumns([vectorColumn], dtype: dtype);
  }

  Matrix _matrixMul(Matrix matrix) {
    checkColumnsAndRowsNumber(this, matrix);
    final source = List<double>(rowsNum * matrix.columnsNum);
    for (final i in _dataManager.rowIndices) {
      for (final j in (matrix as MatrixImpl)._dataManager.columnIndices) {
        final element = getRow(i).dot(matrix.getColumn(j));
        source[i * matrix.columnsNum + j] = element;
      }
    }
    return Matrix.fromFlattenedList(source, rowsNum, matrix.columnsNum,
        dtype: dtype);
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
    checkDimensions(this, matrix, errorTitle: 'Cannot perform matrix by matrix '
        'division');
    return _matrix2matrixOperation(
        matrix, (Vector first, Vector second) => first / second);
  }

  Matrix _matrixAdd(Matrix matrix) {
    checkDimensions(this, matrix, errorTitle: 'Cannot perform matrix addition');
    return _matrix2matrixOperation(
        matrix, (Vector first, Vector second) => first + second);
  }

  Matrix _matrixSub(Matrix matrix) {
    checkDimensions(this, matrix,
        errorTitle: 'Cannot perform matrix subtraction');
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
      Matrix matrix, Vector operation(Vector first, Vector second)) {
    final elementGenFn = (int i) => operation(getRow(i), matrix.getRow(i));
    final source = List<Vector>.generate(rowsNum, elementGenFn);
    return Matrix.fromRows(source, dtype: dtype);
  }

  Matrix _matrix2scalarOperation(
      double scalar, Vector operation(double scalar, Vector vector)) {
    // TODO: use vectorized type (e.g. Float32x4) instead of `double`
    // TODO: use then `fastMap` to accelerate computations
    final elementGenFn = (int i) => operation(scalar, getRow(i));
    final source = List.generate(rowsNum, elementGenFn);
    return Matrix.fromRows(source, dtype: dtype);
  }
}
