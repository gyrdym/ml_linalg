import 'dart:collection';
import 'dart:math' as math;

import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/matrix_norm.dart';
import 'package:ml_linalg/src/matrix/byte_data_storage/data_manager.dart';
import 'package:ml_linalg/src/matrix/matrix_validator_mixin.dart';
import 'package:ml_linalg/vector.dart';
import 'package:xrange/zrange.dart';

abstract class BaseMatrix with
    IterableMixin<Iterable<double>>,
    MatrixValidatorMixin implements Matrix {

  BaseMatrix(this._dataManager);

  final DataManager _dataManager;

  @override
  int get rowsNum => _dataManager.rowsNum;

  @override
  int get columnsNum => _dataManager.columnsNum;

  List<Vector> get _columnsCache => _dataManager.columnsCache;

  List<Vector> get _rowsCache => _dataManager.rowsCache;

  @override
  Iterator<Iterable<double>> get iterator => _dataManager.dataIterator;

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
  List<double> operator [](int index) => _dataManager
      .getValues(index * columnsNum, columnsNum);

  @override
  Matrix transpose() {
    final source = List<Vector>.generate(rowsNum, getRow);
    return Matrix.fromColumns(source, dtype: dtype);
  }

  @override
  Vector getRow(int index, {bool tryCache = true, bool mutable = false}) {
    if (tryCache) {
      _rowsCache[index] ??= Vector.from(this[index], isMutable: mutable,
          dtype: dtype);
      return _rowsCache[index];
    } else {
      return Vector.from(this[index], isMutable: mutable, dtype: dtype);
    }
  }

  @override
  Vector getColumn(int index, {bool tryCache = true, bool mutable = false}) {
    if (_columnsCache[index] == null || !tryCache) {
      final result = List<double>(rowsNum);
      for (int i = 0; i < rowsNum; i++) {
        //@TODO: find a more efficient way to get the single value
        result[i] = _dataManager.getValues(i * columnsNum + index, 1).first;
      }
      final column = Vector.from(result, isMutable: mutable, dtype: dtype);
      if (!tryCache) {
        return column;
      }
      _columnsCache[index] = column;
    }
    return _columnsCache[index];
  }

  @override
  Matrix submatrix({ZRange rows, ZRange columns}) {
    rows ??= ZRange.closedOpen(0, rowsNum);
    columns ??= ZRange.closedOpen(0, columnsNum);
    final rowsNumber = rows.length;
    final columnsLength = columns.length;
    final matrixSource = List<Iterable<double>>(rowsNumber);
    for (final i in rows.values()) {
      matrixSource[i - rows.firstValue] =
          _dataManager.getValues(i * columnsNum + columns.firstValue,
              columnsLength);
    }
    return Matrix.from(matrixSource, dtype: dtype);
  }

  @override
  Matrix pick({Iterable<ZRange> rowRanges,
    Iterable<ZRange> columnRanges}) {
    rowRanges ??= [ZRange.closedOpen(0, rowsNum)];
    columnRanges ??= [ZRange.closedOpen(0, columnsNum)];
    final rows = _collectVectors(rowRanges, getRow);
    final rowBasedMatrix = Matrix.fromRows(rows, dtype: dtype);
    final columns =
        _collectVectors(columnRanges, rowBasedMatrix.getColumn);
    return Matrix.fromColumns(columns, dtype: dtype);
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
      Matrix.fromColumns(List<Vector>.generate(columnsNum,
              (int i) => mapper(getColumn(i))), dtype: dtype);

  @override
  Matrix mapRows(Vector mapper(Vector row)) =>
      Matrix.fromRows(List<Vector>.generate(rowsNum,
              (int i) => mapper(getRow(i))), dtype: dtype);

  @override
  Matrix uniqueRows() {
    final checked = <Vector>[];
    for (int i = 0; i < rowsNum; i++) {
      final row = getRow(i);
      if (!checked.contains(row)) {
        checked.add(row);
      }
    }
    return Matrix.fromRows(checked, dtype: dtype);
  }

  @override
  Vector toVector({bool mutable = false}) {
    if (columnsNum == 1) {
      return getColumn(0, tryCache: !mutable, mutable: mutable);
    } else if (rowsNum == 1) {
      return getRow(0, tryCache: !mutable, mutable: mutable);
    }
    throw Exception(
        'Cannot convert a ${rowsNum}x${columnsNum} matrix into a vector');
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
  void setColumn(int columnNum, Iterable<double> columnValues) {
    if (columnNum >= columnsNum) {
      throw RangeError.range(columnNum, 0, columnsNum - 1, 'Wrong column '
          'number');
    }
    if (columnValues.length != rowsNum) {
      throw Exception('New column has length ${columnValues.length}, but the '
          'matrix rows number is $rowsNum');
    }
    // clear rows cache
    _rowsCache.fillRange(0, rowsNum, null);
    _columnsCache[columnNum] = columnValues is Vector
        ? columnValues : Vector.from(columnValues);
    final values = columnValues.toList(growable: false);
    for (int i = 0, j = 0; i < rowsNum * columnsNum; i++) {
      if (i == 0 && columnNum != 0) {
        continue;
      }
      if (i == columnNum || i % (j * columnsNum + columnNum) == 0) {
        _dataManager.update(i, values[j++]);
      }
    }
  }

  @override
  Iterable<Vector> get rows => _generateVectors(_rowIndices, getRow);

  @override
  Iterable<Vector> get columns => _generateVectors(_columnIndices, getColumn);

  // TODO consider caching
  Iterable<int> get _rowIndices => ZRange.closedOpen(0, rowsNum).values();

  // TODO consider caching
  Iterable<int> get _columnIndices => ZRange.closedOpen(0, columnsNum).values();

  @override
  Matrix fastMap<T>(T mapper(T element)) {
    final source = List<Vector>.generate(
        rowsNum, (int i) => (getRow(i)).fastMap(
            (T element, int startOffset, int endOffset) => mapper(element)));
    return Matrix.fromRows(source, dtype: dtype);
  }

  Iterable<Vector> _generateVectors(Iterable<int> indices,
      Vector genFn(int idx)) sync * {
    for (final i in indices) yield genFn(i);
  }

  double _findExtrema(double callback(Vector vector)) {
    int i = 0;
    return callback(reduceRows((result, row) {
      result[i++] = callback(row);
      return result;
    }, initValue: Vector.zero(rowsNum, isMutable: true)));
  }

  Vector _reduce(
      Vector Function(Vector combine, Vector vector) combiner,
      int length,
      Vector Function(int index) getVector,
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
    final generateElementFn = (int i) => vector.dot(getRow(i));
    final source = List<double>.generate(rowsNum, generateElementFn);
    final vectorColumn = Vector.from(source, dtype: dtype);
    return Matrix.fromColumns([vectorColumn], dtype: dtype);
  }

  Matrix _matrixMul(Matrix matrix) {
    checkColumnsAndRowsNumber(this, matrix);
    final source = List<double>(rowsNum * matrix.columnsNum);
    for (int i = 0; i < rowsNum; i++) {
      for (int j = 0; j < matrix.columnsNum; j++) {
        final element = getRow(i).dot(matrix.getColumn(j));
        source[i * matrix.columnsNum + j] = element;
      }
    }
    return Matrix.flattened(source, rowsNum, matrix.columnsNum, dtype: dtype);
  }

  Matrix _matrixByVectorDiv(Vector vector) {
    if (vector.length == rowsNum) {
      return mapColumns((column) => column / vector);
    }
    if (vector.length == columnsNum) {
      return mapRows((row) => row / vector);
    }
    throw Exception('Cannot divide the $rowsNum x $columnsNum matrix by a '
        'vector of length equals ${vector.length}');
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
    final source = List<Vector>.generate(rowsNum, elementGenFn);
    return Matrix.fromRows(source, dtype: dtype);
  }

  List<Vector> _collectVectors(
      Iterable<ZRange> ranges, Vector getVector(int i)) {
    final vectors = <Vector>[];
    ranges.forEach((range) {
      for (final i in range.values()) {
        vectors.add(getVector(i));
      }
    });
    return vectors;
  }
}
