import 'dart:typed_data';

import 'package:ml_linalg/src/matrix/byte_data_storage/data_manager.dart';
import 'package:ml_linalg/src/matrix/float32x4/float32_matrix_iterator.dart';
import 'package:ml_linalg/vector.dart';

class Float32DataManager implements DataManager {
  Float32DataManager.from(Iterable<Iterable<double>> source) :
        rowsNum = source.length,
        columnsNum = source.first.length,
        rowsCache = List<Vector>(source.length),
        columnsCache = List<Vector>(source.first.length),
        _data = ByteData(source.length * source.first.length *
            Float32List.bytesPerElement) {
    final flattened = flatten2dimList(source, (i, j) => i * columnsNum + j);
    updateAll(0, flattened);
  }

  Float32DataManager.fromRows(Iterable<Vector> source) :
        rowsNum = source.length,
        columnsNum = source.first.length,
        rowsCache = source.toList(growable: false),
        columnsCache = List<Vector>(source.first.length),
        _data = ByteData(source.length * source.first.length *
            Float32List.bytesPerElement) {
    final flattened = flatten2dimList(source, (i, j) => i * columnsNum + j);
    updateAll(0, flattened);
  }

  Float32DataManager.fromColumns(Iterable<Vector> source) :
        rowsNum = source.first.length,
        columnsNum = source.length,
        rowsCache = List<Vector>(source.first.length),
        columnsCache = source.toList(growable: false),
        _data = ByteData(source.length * source.first.length *
            Float32List.bytesPerElement) {
    final flattened = flatten2dimList(source, (i, j) => j * columnsNum + i);
    updateAll(0, flattened);
  }

  Float32DataManager.fromFlattened(Iterable<double> source, int rowsNum,
      int colsNum) :
        rowsNum = rowsNum,
        columnsNum = colsNum,
        rowsCache = List<Vector>(rowsNum),
        columnsCache = List<Vector>(colsNum),
        _data = ByteData(rowsNum * colsNum * Float32List.bytesPerElement) {
    if (source.length != rowsNum * colsNum) {
      throw Exception('Invalid matrix dimension has been provided - '
          '$rowsNum x $colsNum, but given a collection of length '
          '${source.length}');
    }
    updateAll(0, source);
  }

  @override
  final int columnsNum;

  @override
  final int rowsNum;

  @override
  final List<Vector> rowsCache;

  @override
  final List<Vector> columnsCache;

  final ByteData _data;

  @override
  Iterator<Iterable<double>> get dataIterator =>
      Float32MatrixIterator(_data, columnsNum);

  //TODO consider a check if the index is inside the _data
  @override
  Float32List getValues(int index, int length) =>
      _data.buffer.asFloat32List(index * Float32List.bytesPerElement, length);

  //TODO consider a check if the index is inside the _data
  @override
  void update(int idx, double value) =>
    _data.setFloat32(idx * Float32List.bytesPerElement, value, Endian.host);

  @override
  void updateAll(int idx, Iterable<double> values) {
    _data.buffer.asFloat32List().setAll(0, values);
  }

  List<double> flatten2dimList(
      Iterable<Iterable<double>> rows, int accessor(int i, int j)) {
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
}
