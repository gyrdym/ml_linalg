import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/matrix_norm.dart';
import 'package:ml_linalg/range.dart';
import 'package:ml_linalg/src/matrix/matrix_data_store.dart';
import 'package:ml_linalg/src/matrix/matrix_factory.dart';
import 'package:ml_linalg/src/matrix/matrix_validatior.dart';
import 'package:ml_linalg/src/vector/vector_factory.dart';
import 'package:ml_linalg/vector.dart';

mixin MatrixMixin<E, S extends List<E>>
    implements
        Iterable<Iterable<double>>,
        MatrixDataStore,
        MatrixFactory,
        VectorFactory<E, S>,
        MatrixValidator,
        Matrix {
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
  List<double> operator [](int index) => _query(index * columnsNum, columnsNum);

  @override
  Matrix transpose() {
    final source = List<Vector>.generate(rowsNum, getRow);
    return createMatrixFromColumns(source);
  }

  @override
  Vector getRow(int index, {bool tryCache = true, bool mutable = false}) {
    if (tryCache) {
      rowsCache[index] ??= createVectorFrom(this[index], mutable);
      return rowsCache[index];
    } else {
      return createVectorFrom(this[index], mutable);
    }
  }

  @override
  Vector getColumn(int index, {bool tryCache = true, bool mutable = false}) {
    if (columnsCache[index] == null || !tryCache) {
      final result = List<double>(rowsNum);
      for (int i = 0; i < rowsNum; i++) {
        //@TODO: find a more efficient way to get the single value
        result[i] = _query(i * columnsNum + index, 1)[0];
      }
      final column = createVectorFrom(result, mutable);
      if (!tryCache) {
        return column;
      }
      columnsCache[index] = column;
    }
    return columnsCache[index];
  }

  @override
  Matrix submatrix({Range rows, Range columns}) {
    rows ??= Range(0, rowsNum);
    columns ??= Range(0, columnsNum);

    final rowsNumber = rows.end - rows.start + (rows.endInclusive ? 1 : 0);
    final matrixSource = List<List<double>>(rowsNumber);
    final rowEndIdx = rows.endInclusive ? rows.end + 1 : rows.end;
    final columnsLength =
        columns.end - columns.start + (columns.endInclusive ? 1 : 0);
    for (int i = rows.start; i < rowEndIdx; i++) {
      matrixSource[i - rows.start] =
          _query(i * columnsNum + columns.start, columnsLength);
    }
    return createMatrixFrom(matrixSource);
  }

  @override
  Matrix pick({Iterable<Range> rowRanges, Iterable<Range> columnRanges}) {
    rowRanges ??= [Range(0, rowsNum)];
    columnRanges ??= [Range(0, columnsNum)];
    final rows = _collectVectors(rowRanges, getRow, rowsNum);
    final rowBasedMatrix = createMatrixFromRows(rows);
    final columns =
        _collectVectors(columnRanges, rowBasedMatrix.getColumn, columnsNum);
    return createMatrixFromColumns(columns);
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
      Matrix.columns(List<Vector>.generate(columnsNum,
              (int i) => mapper(getColumn(i))));

  @override
  Matrix mapRows(Vector mapper(Vector row)) =>
      Matrix.rows(List<Vector>.generate(rowsNum,
              (int i) => mapper(getRow(i))));

  @override
  Matrix uniqueRows() {
    final checked = <Vector>[];
    for (int i = 0; i < rowsNum; i++) {
      final row = getRow(i);
      if (!checked.contains(row)) {
        checked.add(row);
      }
    }
    return Matrix.rows(checked, dtype: dtype);
  }

  List<double> flatten2dimList(
      Iterable<Iterable<double>> rows, int Function(int i, int j) accessor) {
    int i = 0;
    int j = 0;
    final flattened = List<double>(columnsNum * rowsNum);
    for (final row in rows) {
      for (final value in row) {
        flattened[accessor(i, j)] = value;
        j++;
      }
      j = 0;
      i++;
    }
    return flattened;
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
    rowsCache.fillRange(0, rowsNum, null);
    columnsCache[columnNum] = columnValues is Vector
        ? columnValues : Vector.from(columnValues);
    final values = columnValues.toList(growable: false);
    for (int i = 0, j = 0; i < rowsNum * columnsNum; i++) {
      if (i == 0 && columnNum != 0) {
        continue;
      }
      if (i == columnNum || i % (j * columnsNum + columnNum) == 0) {
        updateByteData(i, values[j++]);
      }
    }
  }

  double _findExtrema(double callback(Vector vector)) {
    int i = 0;
    return callback(reduceRows((Vector result, Vector row) {
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
    final vectorColumn = createVectorFrom(source);
    return createMatrixFromColumns([vectorColumn]);
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
    return createMatrixFromFlattened(source, rowsNum, matrix.columnsNum);
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
    return createMatrixFromRows(source);
  }

  Matrix _matrix2scalarOperation(
      double scalar, Vector operation(double scalar, Vector vector)) {
    // TODO: use vectorized type (e.g. Float32x4) instead of `double`
    // TODO: use then `fastMap` to accelerate computations
    final elementGenFn = (int i) => operation(scalar, getRow(i));
    final source = List<Vector>.generate(rowsNum, elementGenFn);
    return createMatrixFromRows(source);
  }

  Float32List _query(int index, int length) =>
      data.buffer.asFloat32List(index * Float32List.bytesPerElement, length);

  List<Vector> _collectVectors(
      Iterable<Range> ranges, Vector getVector(int i), int maxValue) {
    final vectors = <Vector>[];
    for (final range in ranges) {
      if (range.end > maxValue) {
        throw RangeError.range(range.end, 0, maxValue);
      }
      final rowEndIdx = range.endInclusive ? range.end + 1 : range.end;
      for (int i = range.start; i < rowEndIdx; i++) {
        vectors.add(getVector(i));
      }
    }
    return vectors;
  }
}
