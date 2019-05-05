import 'dart:typed_data';

import 'package:ml_linalg/src/matrix/byte_data_helpers/byte_data_helpers.dart';
import 'package:ml_linalg/src/matrix/data_manager/data_manager.dart';
import 'package:ml_linalg/src/matrix/matrix_iterator.dart';
import 'package:ml_linalg/vector.dart';
import 'package:xrange/zrange.dart';

class DataManagerImpl implements DataManager {
  DataManagerImpl.from(
      List<List<double>> source,
      int bytesPerElement,
      this._dtype,
      this._convertByteBufferToTypedList,
  ) :
        rowsNum = source.length,
        columnsNum = source.first.length,
        _rowsIndicesRange = ZRange.closedOpen(0, source.length),
        _colsIndicesRange = ZRange.closedOpen(0, source.first.length),
        _rowsCache = List<Vector>(source.length),
        _colsCache = List<Vector>(source.first.length),
        _data = ByteData(source.length * source.first.length *
            bytesPerElement),
        _bytesPerElement = bytesPerElement {
    final flattened = _flatten2dimList(source, (i, j) => i * columnsNum + j);
    _updateAll(0, flattened);
  }

  DataManagerImpl.fromRows(
      List<Vector> source,
      int bytesPerElement,
      this._dtype,
      this._convertByteBufferToTypedList,
  ) :
        rowsNum = source.length,
        columnsNum = source.first.length,
        _rowsIndicesRange = ZRange.closedOpen(0, source.length),
        _colsIndicesRange = ZRange.closedOpen(0, source.first.length),
        _rowsCache = source.toList(growable: false),
        _colsCache = List<Vector>(source.first.length),
        _data = ByteData(source.length * source.first.length *
            bytesPerElement),
        _bytesPerElement = bytesPerElement {
    final flattened = _flatten2dimList(source, (i, j) => i * columnsNum + j);
    _updateAll(0, flattened);
  }

  DataManagerImpl.fromColumns(
      List<Vector> source,
      int bytesPerElement,
      this._dtype,
      this._convertByteBufferToTypedList,
  ) :
        rowsNum = source.first.length,
        columnsNum = source.length,
        _rowsIndicesRange = ZRange.closedOpen(0, source.first.length),
        _colsIndicesRange = ZRange.closedOpen(0, source.length),
        _rowsCache = List<Vector>(source.first.length),
        _colsCache = source.toList(growable: false),
        _data = ByteData(source.length * source.first.length *
            bytesPerElement),
        _bytesPerElement = bytesPerElement {
    final flattened = _flatten2dimList(source, (i, j) => j * columnsNum + i);
    _updateAll(0, flattened);
  }

  DataManagerImpl.fromFlattened(
      List<double> source,
      int rowsNum,
      int colsNum,
      int bytesPerElement,
      this._dtype,
      this._convertByteBufferToTypedList,
  ) :
        rowsNum = rowsNum,
        columnsNum = colsNum,
        _rowsIndicesRange = ZRange.closedOpen(0, rowsNum),
        _colsIndicesRange = ZRange.closedOpen(0, colsNum),
        _rowsCache = List<Vector>(rowsNum),
        _colsCache = List<Vector>(colsNum),
        _data = ByteData(rowsNum * colsNum * bytesPerElement),
        _bytesPerElement = bytesPerElement {
    if (source.length != rowsNum * colsNum) {
      throw Exception('Invalid matrix dimension has been provided - '
          '$rowsNum x $colsNum, but given a collection of length '
          '${source.length}');
    }
    _updateAll(0, source);
  }

  @override
  final int columnsNum;

  @override
  final int rowsNum;

  final ZRange _rowsIndicesRange;
  final ZRange _colsIndicesRange;
  final List<Vector> _rowsCache;
  final List<Vector> _colsCache;
  final int _bytesPerElement;
  final ByteData _data;
  final Type _dtype;

  final ByteBufferAsTypedListFn _convertByteBufferToTypedList;

  @override
  Iterator<Iterable<double>> get dataIterator =>
      MatrixIterator(_data, columnsNum, _bytesPerElement,
          _convertByteBufferToTypedList);

  @override
  Iterable<int> get colIndices => _colsIndicesRange.values();

  @override
  Iterable<int> get rowIndices => _rowsIndicesRange.values();

  @override
  List<double> getValues(int index, int length) {
    if (index * _bytesPerElement >= _data.buffer.lengthInBytes) {
      throw RangeError.range(index, 0, rowsNum * columnsNum);
    }
    return _convertByteBufferToTypedList(_data.buffer, index * _bytesPerElement,
        length);
  }

  @override
  Vector getRow(int index, {bool tryCache = true, bool mutable = false}) {
    if (tryCache) {
      _rowsCache[index] ??= Vector.fromList(getValues(index * columnsNum,
          columnsNum), dtype: _dtype);
      return _rowsCache[index];
    } else {
      return Vector.fromList(getValues(index * columnsNum, columnsNum),
          dtype: _dtype);
    }
  }

  @override
  Vector getColumn(int index, {bool tryCache = true, bool mutable = false}) {
    if (_colsCache[index] == null || !tryCache) {
      final result = List<double>(rowsNum);
      for (final i in rowIndices) {
        //@TODO: find a more efficient way to get the single value
        result[i] = getValues(i * columnsNum + index, 1).first;
      }
      final column = Vector.fromList(result, dtype: _dtype);
      if (!tryCache) {
        return column;
      }
      _colsCache[index] = column;
    }
    return _colsCache[index];
  }

  void _updateAll(int idx, Iterable<double> values) =>
      _convertByteBufferToTypedList(_data.buffer, 0, rowsNum * columnsNum)
          .setAll(0, values);

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
