import 'dart:collection';
import 'dart:core';
import 'dart:typed_data';

import 'package:linalg/src/matrix/matrix.dart';
import 'package:linalg/src/matrix/float32_matrix_iterator.dart';
import 'package:linalg/src/vector/float32x4_vector.dart';

class Float32x4Matrix extends Object with IterableMixin<Iterable<double>> implements
    Matrix<Float32x4, Float32x4Vector>, Iterable<Iterable<double>> {

  @override
  final int rowsNum;

  @override
  final int columnsNum;

  final ByteData _data;
  final List<Float32x4Vector> _columnsCache;
  final List<Float32x4Vector> _rowsCache;

  Float32x4Matrix.from(List<List<double>> source) :
        rowsNum = source.length,
        columnsNum = source.first.length,
        _data = ByteData(source.length * source.first.length * Float32List.bytesPerElement),
        _rowsCache = List<Float32x4Vector>(source.length),
        _columnsCache = List<Float32x4Vector>(source.first.length) {

    final flattened = _flatten2x2List(source);
    _data.buffer.asFloat32List().setAll(0, flattened);
  }

  @override
  List<double> operator [](int index) => _query(index * columnsNum, columnsNum);

  @override
  Float32x4Vector getRowVector(int index) {
    _rowsCache[index] ??= Float32x4Vector.from(this[index]);
    return _rowsCache[index];
  }

  @override
  Float32x4Vector getColumnVector(int index) {
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

  List<double> _flatten2x2List(List<List<double>> source) {
    final flattened = List<double>(columnsNum * rowsNum);
    for (int i = 0; i < source.length; i++) {
      for (int j = 0; j < source[i].length; j++) {
        flattened[i * columnsNum + j] = source[i][j];
      }
    }
    return flattened;
  }

  Float32List _query(int index, int length) =>
      _data.buffer.asFloat32List(index * Float32List.bytesPerElement, length);
}
