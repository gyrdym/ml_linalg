import 'dart:typed_data';

import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/range.dart';
import 'package:ml_linalg/src/matrix/ml_matrix_data_store.dart';
import 'package:ml_linalg/src/matrix/ml_matrix_factory.dart';
import 'package:ml_linalg/src/matrix/ml_matrix_validatior.dart';
import 'package:ml_linalg/src/vector/ml_vector_factory.dart';
import 'package:ml_linalg/vector.dart';

abstract class MLMatrixMixin<E, S extends List<E>>
    implements
        Iterable<Iterable<double>>,
        MLMatrixDataStore,
        MLMatrixFactory,
        MLVectorFactory<E, S>,
        MLMatrixValidator,
        MLMatrix {
  @override
  MLMatrix operator +(Object value) {
    if (value is MLMatrix) {
      return _matrixAdd(value);
    } else if (value is num) {
      return _matrixScalarAdd(value.toDouble());
    } else {
      throw UnsupportedError(
          'Cannot add a ${value.runtimeType} to a ${runtimeType}');
    }
  }

  @override
  MLMatrix operator -(Object value) {
    if (value is MLMatrix) {
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
  MLMatrix operator *(Object value) {
    if (value is MLVector) {
      return _matrixVectorMul(value);
    } else if (value is MLMatrix) {
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
  MLMatrix operator /(Object value) {
    if (value is MLVector) {
      return _matrixByVectorDiv(value);
    } else if (value is MLMatrix) {
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
  MLMatrix transpose() {
    final source = List<MLVector>.generate(rowsNum, getRow);
    return createMatrixFromColumns(source);
  }

  @override
  MLVector getRow(int index, {bool tryCache = true, bool mutable = false}) {
    if (tryCache) {
      rowsCache[index] ??= createVectorFrom(this[index], mutable);
      return rowsCache[index];
    } else {
      return createVectorFrom(this[index], mutable);
    }
  }

  @override
  MLVector getColumn(int index, {bool tryCache = true, bool mutable = false}) {
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
  MLMatrix submatrix({Range rows, Range columns}) {
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
  MLMatrix pick({Iterable<Range> rowRanges, Iterable<Range> columnRanges}) {
    rowRanges ??= [Range(0, rowsNum)];
    columnRanges ??= [Range(0, columnsNum)];
    final rows = _collectVectors(rowRanges, getRow, rowsNum);
    final rowBasedMatrix = createMatrixFromRows(rows);
    final columns =
        _collectVectors(columnRanges, rowBasedMatrix.getColumn, columnsNum);
    return createMatrixFromColumns(columns);
  }

  @override
  MLVector reduceColumns(
          MLVector Function(MLVector combine, MLVector vector) combiner,
          {MLVector initValue}) =>
      _reduce(combiner, columnsNum, getColumn, initValue: initValue);

  @override
  MLVector reduceRows(
          MLVector Function(MLVector combine, MLVector vector) combiner,
          {MLVector initValue}) =>
      _reduce(combiner, rowsNum, getRow, initValue: initValue);

  @override
  MLMatrix mapColumns(MLVector mapper(MLVector columns)) =>
      MLMatrix.columns(List<MLVector>.generate(columnsNum,
              (int i) => mapper(getColumn(i))));

  @override
  MLMatrix mapRows(MLVector mapper(MLVector row)) =>
      MLMatrix.rows(List<MLVector>.generate(rowsNum,
              (int i) => mapper(getRow(i))));

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
  MLVector toVector({bool mutable = false}) {
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
  double max() => _findExtrema((MLVector row) => row.max());

  @override
  double min() => _findExtrema((MLVector row) => row.min());

  double _findExtrema(double callback(MLVector vector)) {
    int i = 0;
    return callback(reduceRows((MLVector result, MLVector row) {
      result[i++] = callback(row);
      return result;
    }, initValue: MLVector.zero(rowsNum, isMutable: true)));
  }

  MLVector _reduce(
      MLVector Function(MLVector combine, MLVector vector) combiner,
      int length,
      MLVector Function(int index) getVector,
      {MLVector initValue}) {
    var reduced = initValue ?? getVector(0);
    final startIndex = initValue != null ? 0 : 1;
    for (int i = startIndex; i < length; i++) {
      reduced = combiner(reduced, getVector(i));
    }
    return reduced;
  }

  MLMatrix _matrixVectorMul(MLVector vector) {
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

  MLMatrix _matrixMul(MLMatrix matrix) {
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

  MLMatrix _matrixByVectorDiv(MLVector vector) {
    if (vector.length == rowsNum) {
      return mapColumns((column) => column / vector);
    }
    if (vector.length == columnsNum) {
      return mapRows((row) => row / vector);
    }
    throw Exception('Cannot divide the $rowsNum x $columnsNum matrix by a '
        'vector of length equals ${vector.length}');
  }

  MLMatrix _matrixByMatrixDiv(MLMatrix matrix) {
    checkDimensions(this, matrix, errorTitle: 'Cannot perform matrix by matrix '
        'division');
    return _matrix2matrixOperation(
        matrix, (MLVector first, MLVector second) => first / second);
  }

  MLMatrix _matrixAdd(MLMatrix matrix) {
    checkDimensions(this, matrix, errorTitle: 'Cannot perform matrix addition');
    return _matrix2matrixOperation(
        matrix, (MLVector first, MLVector second) => first + second);
  }

  MLMatrix _matrixSub(MLMatrix matrix) {
    checkDimensions(this, matrix,
        errorTitle: 'Cannot perform matrix subtraction');
    return _matrix2matrixOperation(
        matrix, (MLVector first, MLVector second) => first - second);
  }

  MLMatrix _matrixScalarAdd(double scalar) => _matrix2scalarOperation(
      scalar, (double val, MLVector vector) => vector + val);

  MLMatrix _matrixScalarSub(double scalar) => _matrix2scalarOperation(
      scalar, (double val, MLVector vector) => vector - val);

  MLMatrix _matrixScalarMul(double scalar) => _matrix2scalarOperation(
      scalar, (double val, MLVector vector) => vector * val);

  MLMatrix _matrixByScalarDiv(double scalar) => _matrix2scalarOperation(
    scalar, (double val, MLVector vector) => vector / val);

  MLMatrix _matrix2matrixOperation(
      MLMatrix matrix, MLVector operation(MLVector first, MLVector second)) {
    final elementGenFn = (int i) => operation(getRow(i), matrix.getRow(i));
    final source = List<MLVector>.generate(rowsNum, elementGenFn);
    return createMatrixFromRows(source);
  }

  MLMatrix _matrix2scalarOperation(
      double scalar, MLVector operation(double scalar, MLVector vector)) {
    // TODO: use vectorized type (e.g. Float32x4) instead of `double`
    // TODO: use then `fastMap` to accelerate computations
    final elementGenFn = (int i) => operation(scalar, getRow(i));
    final source = List<MLVector>.generate(rowsNum, elementGenFn);
    return createMatrixFromRows(source);
  }

  Float32List _query(int index, int length) =>
      data.buffer.asFloat32List(index * Float32List.bytesPerElement, length);

  List<MLVector> _collectVectors(
      Iterable<Range> ranges, MLVector getVector(int i), int maxValue) {
    final vectors = <MLVector>[];
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
