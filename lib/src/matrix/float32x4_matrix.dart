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

  Float32x4Matrix.from(List<List<double>> source) :
        rowsNum = source.length,
        columnsNum = source.first.length,
        _data = ByteData(source.length * source.first.length * Float32List.bytesPerElement),
        _rowsCache = List<Vector<Float32x4>>(source.length),
        _columnsCache = List<Vector<Float32x4>>(source.first.length) {

    final flattened = _flatten2dimList(source);
    _data.buffer.asFloat32List().setAll(0, flattened);
  }

  @override
  List<double> operator [](int index) => _query(index * columnsNum, columnsNum);

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

  List<double> _flatten2dimList(List<List<double>> source) {
    final flattened = List<double>(columnsNum * rowsNum);
    for (int i = 0; i < source.length; i++) {
      for (int j = 0; j < source[i].length; j++) {
        flattened[i * columnsNum + j] = source[i][j];
      }
    }
    return flattened;
  }

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

  Vector<Float32x4> _reduce(Vector<Float32x4> Function(Vector<Float32x4> combine, Vector<Float32x4> vector) combiner,
      int length, Vector<Float32x4> Function(int index) getVector, {Vector<Float32x4> initValue}) {

    var reduced = initValue ?? getVector(0);
    final startIndex = initValue != null ? 0 : 1;
    for (int i = startIndex; i < length; i++) {
      reduced = combiner(reduced, getVector(i));
    }
    return reduced;
  }

  Float32List _query(int index, int length) =>
      _data.buffer.asFloat32List(index * Float32List.bytesPerElement, length);
}
