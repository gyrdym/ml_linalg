import 'dart:typed_data';

import 'package:ml_linalg/src/matrix/data_manager/data_manager.dart';
import 'package:ml_linalg/src/matrix/float32x4/float32_matrix_iterator.dart';
import 'package:ml_linalg/vector.dart';

typedef ByteBufferAsTypedListFn = List<double> Function(ByteBuffer buffer,
    int offset, int length);

typedef UpdateByteDataFn = void Function(ByteData data, int offset,
    double value, Endian endian);

class DataManagerImpl implements DataManager {
  DataManagerImpl.from(
      Iterable<Iterable<double>> source,
      int bytesPerElement,
      this._dtype,
      this._convertByteBufferToTypedList,
      this._updateByteData,
  ) :
        rowsNum = source.length,
        columnsNum = source.first.length,
        _rowsCache = List<Vector>(source.length),
        _columnsCache = List<Vector>(source.first.length),
        _data = ByteData(source.length * source.first.length *
            bytesPerElement),
        _bytesPerElement = bytesPerElement {
    final flattened = _flatten2dimList(source, (i, j) => i * columnsNum + j);
    updateAll(0, flattened);
  }

  DataManagerImpl.fromRows(
      Iterable<Vector> source,
      int bytesPerElement,
      this._dtype,
      this._convertByteBufferToTypedList,
      this._updateByteData,
  ) :
        rowsNum = source.length,
        columnsNum = source.first.length,
        _rowsCache = source.toList(growable: false),
        _columnsCache = List<Vector>(source.first.length),
        _data = ByteData(source.length * source.first.length *
            bytesPerElement),
        _bytesPerElement = bytesPerElement {
    final flattened = _flatten2dimList(source, (i, j) => i * columnsNum + j);
    updateAll(0, flattened);
  }

  DataManagerImpl.fromColumns(
      Iterable<Vector> source,
      int bytesPerElement,
      this._dtype,
      this._convertByteBufferToTypedList,
      this._updateByteData,
  ) :
        rowsNum = source.first.length,
        columnsNum = source.length,
        _rowsCache = List<Vector>(source.first.length),
        _columnsCache = source.toList(growable: false),
        _data = ByteData(source.length * source.first.length *
            bytesPerElement),
        _bytesPerElement = bytesPerElement {
    final flattened = _flatten2dimList(source, (i, j) => j * columnsNum + i);
    updateAll(0, flattened);
  }

  DataManagerImpl.fromFlattened(
      Iterable<double> source,
      int rowsNum,
      int colsNum,
      int bytesPerElement,
      this._dtype,
      this._convertByteBufferToTypedList,
      this._updateByteData,
  ) :
        rowsNum = rowsNum,
        columnsNum = colsNum,
        _rowsCache = List<Vector>(rowsNum),
        _columnsCache = List<Vector>(colsNum),
        _data = ByteData(rowsNum * colsNum * bytesPerElement),
        _bytesPerElement = bytesPerElement {
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

  final List<Vector> _rowsCache;
  final List<Vector> _columnsCache;
  final int _bytesPerElement;
  final ByteData _data;
  final Type _dtype;

  final ByteBufferAsTypedListFn _convertByteBufferToTypedList;
  final UpdateByteDataFn _updateByteData;

  @override
  Iterator<Iterable<double>> get dataIterator =>
      Float32MatrixIterator(_data, columnsNum);

  //TODO consider a check if the index is inside the _data
  @override
  List<double> getValues(int index, int length) =>
      _convertByteBufferToTypedList(_data.buffer, index * _bytesPerElement,
          length);

  //TODO consider a check if the index is inside the _data
  @override
  void update(int idx, double value) =>
      _updateByteData(_data, idx * _bytesPerElement, value, Endian.host);

  @override
  void updateAll(int idx, Iterable<double> values) =>
    _convertByteBufferToTypedList(_data.buffer, 0, rowsNum * columnsNum)
        .setAll(0, values);

  @override
  Vector getRow(int index, {bool tryCache = true, bool mutable = false}) {
    if (tryCache) {
      _rowsCache[index] ??= Vector.from(getValues(index * columnsNum,
          columnsNum), isMutable: mutable, dtype: _dtype);
      return _rowsCache[index];
    } else {
      return Vector.from(getValues(index * columnsNum, columnsNum),
          isMutable: mutable, dtype: _dtype);
    }
  }

  @override
  Vector getColumn(int index, {bool tryCache = true, bool mutable = false}) {
    if (_columnsCache[index] == null || !tryCache) {
      final result = List<double>(rowsNum);
      for (int i = 0; i < rowsNum; i++) {
        //@TODO: find a more efficient way to get the single value
        result[i] = getValues(i * columnsNum + index, 1).first;
      }
      final column = Vector.from(result, isMutable: mutable, dtype: _dtype);
      if (!tryCache) {
        return column;
      }
      _columnsCache[index] = column;
    }
    return _columnsCache[index];
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
