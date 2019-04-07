import 'dart:typed_data';

import 'package:ml_linalg/src/matrix/byte_data_storage/data_manager.dart';
import 'package:ml_linalg/src/matrix/float32x4/float32_matrix_iterator.dart';
import 'package:ml_linalg/vector.dart';

class Float32DataManager implements DataManager {
  Float32DataManager.from(
      Iterable<Iterable<double>> source,
      int bytesPerElement,
  ) :
        rowsNum = source.length,
        columnsNum = source.first.length,
        rowsCache = List<Vector>(source.length),
        columnsCache = List<Vector>(source.first.length),
        _data = ByteData(source.length * source.first.length *
            bytesPerElement) {
    final flattened = _flatten2dimList(source, (i, j) => i * columnsNum + j);
    updateAll(0, flattened);
  }

  Float32DataManager.fromRows(
      Iterable<Vector> source,
      int bytesPerElement,
  ) :
        rowsNum = source.length,
        columnsNum = source.first.length,
        rowsCache = source.toList(growable: false),
        columnsCache = List<Vector>(source.first.length),
        _data = ByteData(source.length * source.first.length *
            bytesPerElement) {
    final flattened = _flatten2dimList(source, (i, j) => i * columnsNum + j);
    updateAll(0, flattened);
  }

  Float32DataManager.fromColumns(
      Iterable<Vector> source,
      int bytesPerElement,
  ) :
        rowsNum = source.first.length,
        columnsNum = source.length,
        rowsCache = List<Vector>(source.first.length),
        columnsCache = source.toList(growable: false),
        _data = ByteData(source.length * source.first.length *
            bytesPerElement) {
    final flattened = _flatten2dimList(source, (i, j) => j * columnsNum + i);
    updateAll(0, flattened);
  }

  Float32DataManager.fromFlattened(
      Iterable<double> source,
      int rowsNum,
      int colsNum,
      int bytesPerElement,
  ) :
        rowsNum = rowsNum,
        columnsNum = colsNum,
        rowsCache = List<Vector>(rowsNum),
        columnsCache = List<Vector>(colsNum),
        _data = ByteData(rowsNum * colsNum * bytesPerElement) {
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

  @override
  Vector getRow(int index, {bool tryCache = true, bool mutable = false}) {
    if (tryCache) {
      rowsCache[index] ??= Vector.from(getValues(index * columnsNum,
          columnsNum), isMutable: mutable, dtype: Float32x4);
      return rowsCache[index];
    } else {
      return Vector.from(getValues(index * columnsNum, columnsNum),
          isMutable: mutable, dtype: Float32x4);
    }
  }

  @override
  Vector getColumn(int index, {bool tryCache = true, bool mutable = false}) {
    if (columnsCache[index] == null || !tryCache) {
      final result = List<double>(rowsNum);
      for (int i = 0; i < rowsNum; i++) {
        //@TODO: find a more efficient way to get the single value
        result[i] = getValues(i * columnsNum + index, 1).first;
      }
      final column = Vector.from(result, isMutable: mutable, dtype: Float32x4);
      if (!tryCache) {
        return column;
      }
      columnsCache[index] = column;
    }
    return columnsCache[index];
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
        update(i, values[j++]);
      }
    }
  }

  List<double> _flatten2dimList(
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
