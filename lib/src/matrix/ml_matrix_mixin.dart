import 'dart:typed_data';

import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/range.dart';
import 'package:ml_linalg/src/matrix/ml_matrix_validatior.dart';
import 'package:ml_linalg/src/matrix/ml_matrix_data_store.dart';
import 'package:ml_linalg/src/matrix/ml_matrix_factory.dart';
import 'package:ml_linalg/src/vector/ml_vector_factory.dart';
import 'package:ml_linalg/vector.dart';

abstract class MLMatrixMixin<S extends List<E>, E>  implements
    Iterable<Iterable<double>>,
    MLMatrixDataStore<E>,
    MLMatrixFactory<E>,
    MLVectorFactory<S, E>,
    MLMatrixValidator<E>,
    MLMatrix<E> {

  @override
  MLMatrix<E> operator +(Object value) {
    if (value is MLMatrix<E>) {
      return _matrixAdd(value);
    } else if (value is num) {
      return _matrixScalarAdd(value.toDouble());
    } else {
      throw UnsupportedError('Cannot add a ${value.runtimeType} to a ${runtimeType}');
    }
  }

  @override
  MLMatrix<E> operator -(Object value) {
    if (value is MLMatrix<E>) {
      return _matrixSub(value);
    } else if (value is num) {
      return _matrixScalarSub(value.toDouble());
    } else {
      throw UnsupportedError('Cannot subtract a ${value.runtimeType} from a ${runtimeType}');
    }
  }

  /// Mathematical matrix multiplication
  /// The main rule: let N be a number of columns, so the multiplication is available only for
  /// XxN * NxY matrices, that causes XxY matrix
  @override
  MLMatrix<E> operator *(Object value) {
    if (value is MLVector<E>) {
      return _matrixVectorMul(value);
    } else if (value is MLMatrix<E>) {
      return _matrixMul(value);
    } else if (value is num) {
      return _matrixScalarMul(value.toDouble());
    } else {
      throw UnsupportedError('Cannot multiple a ${runtimeType} and a ${value.runtimeType}');
    }
  }

  @override
  List<double> operator [](int index) => _query(index * columnsNum, columnsNum);

  @override
  MLMatrix<E> transpose() {
    final source = List<MLVector<E>>.generate(rowsNum, getRow);
    return createMatrixFromColumns(source);
  }

  @override
  MLVector<E> getRow(int index, {bool tryCache = true, bool mutable = false}) {
    if (tryCache) {
      rowsCache[index] ??= createVectorFrom(this[index], mutable);
      return rowsCache[index];
    } else {
      return createVectorFrom(this[index], mutable);
    }
  }

  @override
  MLVector<E> getColumn(int index, {bool tryCache = true, bool mutable = false}) {
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
  MLMatrix<E> submatrix({Range rows, Range columns}) {
    rows ??= Range(0, rowsNum);
    columns ??= Range(0, columnsNum);

    final rowsNumber = rows.end - rows.start + (rows.endInclusive ? 1 : 0);
    final matrixSource = List<List<double>>(rowsNumber);
    final rowEndIdx = rows.endInclusive ? rows.end + 1 : rows.end;
    final columnsLength = columns.end - columns.start + (columns.endInclusive ? 1 : 0);
    for (int i = rows.start; i < rowEndIdx; i++) {
      matrixSource[i - rows.start] = _query(i * columnsNum + columns.start, columnsLength);
    }
    return createMatrixFrom(matrixSource);
  }

  @override
  MLMatrix<E> pick({Iterable<Range> rowRanges, Iterable<Range> columnRanges}) {
    rowRanges ??= [Range(0, rowsNum)];
    columnRanges ??= [Range(0, columnsNum)];
    final rows = _collectVectors(rowRanges, getRow, rowsNum);
    final rowBasedMatrix = createMatrixFromRows(rows);
    final columns = _collectVectors(columnRanges, rowBasedMatrix.getColumn, columnsNum);
    return createMatrixFromColumns(columns);
  }

  @override
  MLVector<E> reduceColumns(
      MLVector<E> Function(MLVector<E> combine, MLVector<E> vector) combiner,
      {MLVector<E> initValue}) => _reduce(combiner, columnsNum, getColumn, initValue: initValue);

  @override
  MLVector<E> reduceRows(MLVector<E> Function(MLVector<E> combine, MLVector<E> vector) combiner,
      {MLVector<E> initValue}) => _reduce(combiner, rowsNum, getRow, initValue: initValue);

  @override
  MLMatrix<E> vectorizedMap(E mapper(E element)) {
    final source = List<MLVector<E>>.generate(rowsNum, (int i) => getRow(i)
        .vectorizedMap((E element, [int startOffset, int endOffset]) => mapper(element)));
    return createMatrixFromRows(source);
  }

  List<double> flatten2dimList(Iterable<Iterable<double>> rows, int Function(int i, int j) accessor) {
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
  MLVector<E> toVector({bool mutable = false}) {
    if (columnsNum == 1) {
      return getColumn(0, tryCache: !mutable, mutable: mutable);
    } else if (rowsNum == 1) {
      return getRow(0, tryCache: !mutable, mutable: mutable);
    }
    throw Exception('Cannot convert a ${rowsNum}x${columnsNum} matrix into a vector');
  }

  MLVector<E> _reduce(MLVector<E> Function(MLVector<E> combine, MLVector<E> vector) combiner,
      int length, MLVector<E> Function(int index) getVector, {MLVector<E> initValue}) {
    var reduced = initValue ?? getVector(0);
    final startIndex = initValue != null ? 0 : 1;
    for (int i = startIndex; i < length; i++) {
      reduced = combiner(reduced, getVector(i));
    }
    return reduced;
  }

  MLMatrix<E> _matrixVectorMul(MLVector<E> vector) {
    if (vector.length != columnsNum) {
      throw Exception('The dimension of the vector ${vector} and the columns number of matrix ${this} mismatch');
    }
    final generateElementFn = (int i) => vector.dot(getRow(i));
    final source = List<double>.generate(rowsNum, generateElementFn);
    final vectorColumn = createVectorFrom(source);
    return createMatrixFromColumns([vectorColumn]);
  }

  MLMatrix<E> _matrixMul(MLMatrix<E> matrix) {
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

  MLMatrix<E> _matrixAdd(MLMatrix<E> matrix) {
    checkDimensions(this, matrix, errorTitle: 'Cannot perform matrix addition');
    return _matrix2matrixOperation(matrix, (MLVector<E> first, MLVector<E> second) => first + second);
  }

  MLMatrix<E> _matrixSub(MLMatrix<E> matrix) {
    checkDimensions(this, matrix, errorTitle: 'Cannot perform matrix subtraction');
    return _matrix2matrixOperation(matrix, (MLVector<E> first, MLVector<E> second) => first - second);
  }

  MLMatrix<E> _matrixScalarAdd(double scalar) =>
      _matrix2scalarOperation(scalar, (double val, MLVector<E> vector) => vector + val);

  MLMatrix<E> _matrixScalarSub(double scalar) =>
      _matrix2scalarOperation(scalar, (double val, MLVector<E> vector) => vector - val);

  MLMatrix<E> _matrixScalarMul(double scalar) =>
      _matrix2scalarOperation(scalar, (double val, MLVector<E> vector) => vector * val);

  MLMatrix<E> _matrix2matrixOperation(MLMatrix<E> matrix,
      MLVector<E> operation(MLVector<E> first, MLVector<E> second)) {
    final elementGenFn = (int i) => operation(getRow(i), matrix.getRow(i));
    final source = List<MLVector<E>>.generate(rowsNum, elementGenFn);
    return createMatrixFromRows(source);
  }

  MLMatrix<E> _matrix2scalarOperation(double scalar,
      MLVector<E> operation(double scalar, MLVector<E> vector)) {
    final elementGenFn = (int i) => operation(scalar, getRow(i));
    final source = List<MLVector<E>>.generate(rowsNum, elementGenFn);
    return createMatrixFromRows(source);
  }

  Float32List _query(int index, int length) =>
      data.buffer.asFloat32List(index * Float32List.bytesPerElement, length);

  List<MLVector<E>> _collectVectors(Iterable<Range> ranges, MLVector<E> getVector(int i), int maxValue) {
    final vectors = <MLVector<E>>[];
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
