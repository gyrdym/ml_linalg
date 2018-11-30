import 'dart:collection';
import 'dart:core';
import 'dart:typed_data';

import 'package:linalg/linalg.dart';
import 'package:linalg/src/matrix/matrix.dart';
import 'package:linalg/src/matrix/float32_matrix_iterator.dart';
import 'package:linalg/src/matrix/range.dart';
import 'package:linalg/src/vector/float32x4_vector.dart';

class Float32x4Matrix extends Object with IterableMixin<Iterable<double>> implements
    Matrix<Float32x4, Vector<Float32x4>>, Iterable<Iterable<double>> {

  @override
  final int rowsNum;

  @override
  final int columnsNum;

  final ByteData _data;
  final List<Vector<Float32x4>> _columnsCache;
  final List<Vector<Float32x4>> _rowsCache;

  Float32x4Matrix.from(Iterable<Iterable<double>> source) :
        rowsNum = source.length,
        columnsNum = source.first.length,
        _data = ByteData(source.length * source.first.length * Float32List.bytesPerElement),
        _rowsCache = List<Vector<Float32x4>>(source.length),
        _columnsCache = List<Vector<Float32x4>>(source.first.length) {

    final flattened = _flatten2dimList(source);
    _data.buffer.asFloat32List().setAll(0, flattened);
  }

  /// vectors from [source] will serve as rows of the matrix
  Float32x4Matrix.rows(Iterable<Vector<Float32x4>> source) :
        rowsNum = source.length,
        columnsNum = source.first.length,
        _data = ByteData(source.length * source.first.length * Float32List.bytesPerElement),
        _rowsCache = source.toList(growable: false),
        _columnsCache = List<Vector<Float32x4>>(source.first.length) {

    final flattened = _flatten2dimList(source);
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
  Float32x4Matrix.columns(Iterable<Vector<Float32x4>> source) :
        rowsNum = source.first.length,
        columnsNum = source.length,
        _data = ByteData(source.length * source.first.length * Float32List.bytesPerElement),
        _rowsCache = List<Vector<Float32x4>>(source.first.length),
        _columnsCache = source.toList(growable: false) {

    final flattened = _flatten2dimList(source);
    _data.buffer.asFloat32List().setAll(0, flattened);
  }

  /// Mathematical matrix multiplication
  /// The main rule: let M be a number of rows, N - a number of columns, so the multiplication is available only for
  /// MxN * N*M matrices
  @override
  Matrix<Float32x4, Vector<Float32x4>> operator *(Object value) {
    if (value is Vector<Float32x4>) {
      return _vector2MatrixMul(value);
    } else if (value is Matrix<Float32x4, Vector<Float32x4>>) {
      return _matrix2matrixMul(value);
    } else {
      throw UnsupportedError('Cannot multiple a ${runtimeType} and a ${value.runtimeType}');
    }
   }

  @override
  List<double> operator [](int index) => _query(index * columnsNum, columnsNum);

  @override
  Matrix<Float32x4, Vector<Float32x4>> transpose() {

  }

  @override
  Vector<Float32x4> getRowVector(int index) {
    _rowsCache[index] ??= Float32x4Vector.from(this[index]);
    return _rowsCache[index];
  }

  @override
  Vector<Float32x4> getColumnVector(int index) {
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
  Matrix<Float32x4, Vector<Float32x4>> submatrix({Range rows, Range columns}) {
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
  Vector<Float32x4> reduceColumns(
      Vector<Float32x4> Function(Vector<Float32x4> combine, Vector<Float32x4> vector) combiner,
      {Vector<Float32x4> initValue}) => _reduce(combiner, columnsNum, getColumnVector, initValue: initValue);

  @override
  Vector<Float32x4> reduceRows(Vector<Float32x4> Function(Vector<Float32x4> combine, Vector<Float32x4> vector) combiner,
    {Vector<Float32x4> initValue}) => _reduce(combiner, rowsNum, getRowVector, initValue: initValue);

  List<double> _flatten2dimList(Iterable<Iterable<double>> source) {
    int i = 0;
    int j = 0;
    final flattened = List<double>(columnsNum * rowsNum);
    for (final row in source) {
      for (final value in row) {
        flattened[i * columnsNum + j] = value;
        j++;
      }
      j = 0;
      i++;
    }
    return flattened;
  }

  Vector<Float32x4> _reduce(Vector<Float32x4> Function(Vector<Float32x4> combine, Vector<Float32x4> vector) combiner,
      int length, Vector<Float32x4> Function(int index) getVector, {Vector<Float32x4> initValue}) {
    var reduced = initValue ?? getVector(0);
    final startIndex = initValue != null ? 0 : 1;
    for (int i = startIndex; i < length; i++) {
      reduced = combiner(reduced, getVector(i));
    }
    return reduced;
  }

  Matrix<Float32x4, Vector<Float32x4>> _vector2MatrixMul(Vector<Float32x4> vector) {
    if (vector.length != rowsNum) {
      throw Exception('The dimensions of the vector ${vector} and the matrix ${this} mismatch');
    }
    final generateElementFn = (int i) => vector.dot(getRowVector(i));
    final source = List<double>.generate(rowsNum, generateElementFn);
    final vectorColumn = Float32x4Vector.from(source);
    return Float32x4Matrix.columns([vectorColumn]);
  }

  Matrix<Float32x4, Vector<Float32x4>> _matrix2matrixMul(Matrix<Float32x4, Vector<Float32x4>> matrix) {

  }

  Float32List _query(int index, int length) =>
      _data.buffer.asFloat32List(index * Float32List.bytesPerElement, length);
}
