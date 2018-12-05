import 'dart:collection';
import 'dart:core';
import 'dart:typed_data';

import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/range.dart';
import 'package:ml_linalg/src/matrix/float32_matrix_iterator.dart';
import 'package:ml_linalg/src/matrix/matrix_validation_mixin.dart';
import 'package:ml_linalg/src/vector/float32x4_vector.dart';
import 'package:ml_linalg/vector.dart';

class Float32x4Matrix extends Object with
    IterableMixin<Iterable<double>>,
    MatrixValidationMixin<Float32x4, MLVector<Float32x4>> implements
    MLMatrix<Float32x4, MLVector<Float32x4>>, Iterable<Iterable<double>> {

  @override
  final int rowsNum;

  @override
  final int columnsNum;

  final ByteData _data;
  final List<MLVector<Float32x4>> _columnsCache;
  final List<MLVector<Float32x4>> _rowsCache;

  Float32x4Matrix.from(Iterable<Iterable<double>> source) :
        rowsNum = source.length,
        columnsNum = source.first.length,
        _data = ByteData(source.length * source.first.length * Float32List.bytesPerElement),
        _rowsCache = List<MLVector<Float32x4>>(source.length),
        _columnsCache = List<MLVector<Float32x4>>(source.first.length) {

    final flattened = _flatten2dimList(source, (i, j) => i * columnsNum + j);
    _data.buffer.asFloat32List().setAll(0, flattened);
  }

  /// vectors from [source] will serve as rows of the matrix
  Float32x4Matrix.rows(Iterable<MLVector<Float32x4>> source) :
        rowsNum = source.length,
        columnsNum = source.first.length,
        _data = ByteData(source.length * source.first.length * Float32List.bytesPerElement),
        _rowsCache = source.toList(growable: false),
        _columnsCache = List<MLVector<Float32x4>>(source.first.length) {

    final flattened = _flatten2dimList(source, (i, j) => i * columnsNum + j);
    _data.buffer.asFloat32List().setAll(0, flattened);
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
  Float32x4Matrix.columns(Iterable<MLVector<Float32x4>> source) :
        rowsNum = source.first.length,
        columnsNum = source.length,
        _data = ByteData(source.length * source.first.length * Float32List.bytesPerElement),
        _rowsCache = List<MLVector<Float32x4>>(source.first.length),
        _columnsCache = source.toList(growable: false) {

    final flattened = _flatten2dimList(source, (i, j) => j * columnsNum + i);
    _data.buffer.asFloat32List().setAll(0, flattened);
  }

  Float32x4Matrix.flattened(Iterable<double> source, this.rowsNum, this.columnsNum) :
        _data = ByteData(rowsNum * columnsNum * Float32List.bytesPerElement),
        _rowsCache = List<MLVector<Float32x4>>(rowsNum),
        _columnsCache = List<MLVector<Float32x4>>(columnsNum) {
    if (source.length != rowsNum * columnsNum) {
      throw Exception('Invalid number of rows and columns are provided');
    }
    _data.buffer.asFloat32List().setAll(0, source);
  }

  @override
  MLMatrix<Float32x4, MLVector<Float32x4>> operator +(Object value) {
    if (value is MLMatrix<Float32x4, MLVector<Float32x4>>) {
      return _matrixAdd(value);
    } else if (value is num) {
      return _matrixScalarAdd(value.toDouble());
    } else {
      throw UnsupportedError('Cannot add a ${value.runtimeType} to a ${runtimeType}');
    }
  }

  @override
  MLMatrix<Float32x4, MLVector<Float32x4>> operator -(Object value) {
    if (value is MLMatrix<Float32x4, MLVector<Float32x4>>) {
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
  MLMatrix<Float32x4, MLVector<Float32x4>> operator *(Object value) {
    if (value is MLVector<Float32x4>) {
      // by default any passed vector is considered column-vector, so its dimension must be equal to the matrix columns
      // number
      return _matrixVectorMul(value);
    } else if (value is MLMatrix<Float32x4, MLVector<Float32x4>>) {
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
  MLMatrix<Float32x4, MLVector<Float32x4>> transpose() {
    final source = List<MLVector<Float32x4>>.generate(rowsNum, getRowVector);
    return Float32x4Matrix.columns(source);
  }

  @override
  MLVector<Float32x4> getRowVector(int index) {
    _rowsCache[index] ??= Float32x4Vector.from(this[index]);
    return _rowsCache[index];
  }

  @override
  MLVector<Float32x4> getColumnVector(int index) {
    if (_columnsCache[index] == null) {
      final result = List<double>(rowsNum);
      for (int i = 0; i < rowsNum; i++) {
        //@TODO: find a more efficient way to get the single value
        result[i] = _query(i * columnsNum + index, 1)[0];
      }
      _columnsCache[index] = Float32x4Vector.from(result);
    }
    return _columnsCache[index];
  }

  @override
  Iterator<Iterable<double>> get iterator => Float32MatrixIterator(_data, columnsNum);

  @override
  MLMatrix<Float32x4, MLVector<Float32x4>> submatrix({Range rows, Range columns}) {
    rows ??= Range(0, rowsNum);
    columns ??= Range(0, columnsNum);

    final rowsNumber = rows.end - rows.start + (rows.endInclusive ? 1 : 0);
    final matrixSource = List<List<double>>(rowsNumber);
    final rowEndIdx = rows.endInclusive ? rows.end + 1 : rows.end;
    final columnsLength = columns.end - columns.start + (columns.endInclusive ? 1 : 0);
    for (int i = rows.start; i < rowEndIdx; i++) {
      matrixSource[i - rows.start] = _query(i * columnsNum + columns.start, columnsLength);
    }
    return Float32x4Matrix.from(matrixSource);
  }

  @override
  MLVector<Float32x4> reduceColumns(
      MLVector<Float32x4> Function(MLVector<Float32x4> combine, MLVector<Float32x4> vector) combiner,
      {MLVector<Float32x4> initValue}) => _reduce(combiner, columnsNum, getColumnVector, initValue: initValue);

  @override
  MLVector<Float32x4> reduceRows(MLVector<Float32x4> Function(MLVector<Float32x4> combine, MLVector<Float32x4> vector) combiner,
    {MLVector<Float32x4> initValue}) => _reduce(combiner, rowsNum, getRowVector, initValue: initValue);

  @override
  MLMatrix<Float32x4, MLVector<Float32x4>> mapColumns(Float32x4 mapper(Float32x4 element)) {
    final source = List<MLVector<Float32x4>>.generate(columnsNum, (int i) => getColumnVector(i).vectorizedMap(mapper));
    return Float32x4Matrix.columns(source);
  }

  @override
  MLMatrix<Float32x4, MLVector<Float32x4>> mapRows(Float32x4 mapper(Float32x4 element)) {
    final source = List<MLVector<Float32x4>>.generate(rowsNum, (int i) => getRowVector(i).vectorizedMap(mapper));
    return Float32x4Matrix.rows(source);
  }

  List<double> _flatten2dimList(Iterable<Iterable<double>> rows, int Function(int i, int j) accessor) {
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

  MLVector<Float32x4> _reduce(MLVector<Float32x4> Function(MLVector<Float32x4> combine, MLVector<Float32x4> vector) combiner,
      int length, MLVector<Float32x4> Function(int index) getVector, {MLVector<Float32x4> initValue}) {
    var reduced = initValue ?? getVector(0);
    final startIndex = initValue != null ? 0 : 1;
    for (int i = startIndex; i < length; i++) {
      reduced = combiner(reduced, getVector(i));
    }
    return reduced;
  }

  MLMatrix<Float32x4, MLVector<Float32x4>> _matrixVectorMul(MLVector<Float32x4> vector) {
    if (vector.length != columnsNum) {
      throw Exception('The dimension of the vector ${vector} and the columns number of matrix ${this} mismatch');
    }
    final generateElementFn = (int i) => vector.dot(getRowVector(i));
    final source = List<double>.generate(rowsNum, generateElementFn);
    final vectorColumn = Float32x4Vector.from(source);
    return Float32x4Matrix.columns([vectorColumn]);
  }

  MLMatrix<Float32x4, MLVector<Float32x4>> _matrixMul(MLMatrix<Float32x4, MLVector<Float32x4>> matrix) {
    checkColumnsAndRowsNumber(this, matrix);
    final source = List<double>(rowsNum * matrix.columnsNum);
    for (int i = 0; i < rowsNum; i++) {
      for (int j = 0; j < matrix.columnsNum; j++) {
        final element = getRowVector(i).dot(matrix.getColumnVector(j));
        source[i * matrix.columnsNum + j] = element;
      }
    }
    return Float32x4Matrix.flattened(source, rowsNum, matrix.columnsNum);
  }

  MLMatrix<Float32x4, MLVector<Float32x4>> _matrixAdd(MLMatrix<Float32x4, MLVector<Float32x4>> matrix) {
    checkDimensions(this, matrix, errorTitle: 'Cannot perform matrix addition');
    return _matrix2matrixOperation(matrix, (MLVector<Float32x4> first, MLVector<Float32x4> second) => first + second);
  }

  MLMatrix<Float32x4, MLVector<Float32x4>> _matrixSub(MLMatrix<Float32x4, MLVector<Float32x4>> matrix) {
    checkDimensions(this, matrix, errorTitle: 'Cannot perform matrix subtraction');
    return _matrix2matrixOperation(matrix, (MLVector<Float32x4> first, MLVector<Float32x4> second) => first - second);
  }

  MLMatrix<Float32x4, MLVector<Float32x4>> _matrixScalarAdd(double scalar) =>
      _matrix2scalarOperation(scalar, (double val, MLVector<Float32x4> vector) => vector + val);

  MLMatrix<Float32x4, MLVector<Float32x4>> _matrixScalarSub(double scalar) =>
    _matrix2scalarOperation(scalar, (double val, MLVector<Float32x4> vector) => vector - val);

  MLMatrix<Float32x4, MLVector<Float32x4>> _matrixScalarMul(double scalar) =>
      _matrix2scalarOperation(scalar, (double val, MLVector<Float32x4> vector) => vector * val);

  MLMatrix<Float32x4, MLVector<Float32x4>> _matrix2matrixOperation(MLMatrix<Float32x4, MLVector<Float32x4>> matrix,
      MLVector<Float32x4> operation(MLVector<Float32x4> first, MLVector<Float32x4> second)) {
    final elementGenFn = (int i) => operation(getRowVector(i), matrix.getRowVector(i));
    final source = List<MLVector<Float32x4>>.generate(rowsNum, elementGenFn);
    return Float32x4Matrix.rows(source);
  }

  MLMatrix<Float32x4, MLVector<Float32x4>> _matrix2scalarOperation(double scalar,
      MLVector<Float32x4> operation(double scalar, MLVector<Float32x4> vector)) {
    final elementGenFn = (int i) => operation(scalar, getRowVector(i));
    final source = List<MLVector<Float32x4>>.generate(rowsNum, elementGenFn);
    return Float32x4Matrix.rows(source);
  }

  Float32List _query(int index, int length) =>
      _data.buffer.asFloat32List(index * Float32List.bytesPerElement, length);
}
