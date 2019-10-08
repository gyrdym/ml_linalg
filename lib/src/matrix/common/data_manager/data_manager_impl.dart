import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/common/helper/get_length_of_first_or_zero.dart';
import 'package:ml_linalg/src/common/typed_list_helper/typed_list_helper.dart';
import 'package:ml_linalg/src/matrix/common/data_manager/data_manager.dart';
import 'package:ml_linalg/src/matrix/common/matrix_iterator.dart';
import 'package:ml_linalg/vector.dart';
import 'package:xrange/integers.dart';

class DataManagerImpl implements DataManager {
  DataManagerImpl.fromList(
      List<List<double>> source,
      int bytesPerElement,
      this._dtype,
      this._typedListHelper,
  ) :
        rowsNum = source.isNotEmpty && source.first.isEmpty
            ? 0
            : source.length,
        columnsNum = getLengthOfFirstOrZero(source),
        rowIndices = integers(0, source.length, upperClosed: false),
        columnIndices = integers(0, getLengthOfFirstOrZero(source),
            upperClosed: false),
        _rowsCache = List<Vector>(source.length),
        _colsCache = List<Vector>(getLengthOfFirstOrZero(source)),
        _data = ByteData(source.length *
            getLengthOfFirstOrZero(source) * bytesPerElement) {
    _updateByteDataBy2dimIterable(source, (i, j) => i * columnsNum + j,
        bytesPerElement);
  }

  DataManagerImpl.fromRows(
      List<Vector> source,
      int bytesPerElement,
      this._dtype,
      this._typedListHelper,
  ) :
        rowsNum = source.isNotEmpty && source.first.isEmpty
            ? 0
            : source.length,
        columnsNum = getLengthOfFirstOrZero(source),
        rowIndices = integers(0, source.length, upperClosed: false),
        columnIndices = integers(0, getLengthOfFirstOrZero(source),
            upperClosed: false),
        _rowsCache = source.toList(growable: false),
        _colsCache = List<Vector>(getLengthOfFirstOrZero(source)),
        _data = ByteData(source.length *
            getLengthOfFirstOrZero(source) * bytesPerElement) {
    _updateByteDataBy2dimIterable(source, (i, j) => i * columnsNum + j,
        bytesPerElement);
  }

  DataManagerImpl.fromColumns(
      List<Vector> source,
      int bytesPerElement,
      this._dtype,
      this._typedListHelper,
  ) :
        rowsNum = getLengthOfFirstOrZero(source),
        columnsNum = source.isNotEmpty && source.first.isEmpty
            ? 0
            : source.length,
        rowIndices = integers(0, getLengthOfFirstOrZero(source),
            upperClosed: false),
        columnIndices = integers(0, source.length, upperClosed: false),
        _rowsCache = List<Vector>(getLengthOfFirstOrZero(source)),
        _colsCache = source.toList(growable: false),
        _data = ByteData(source.length *
            getLengthOfFirstOrZero(source) * bytesPerElement) {
    _updateByteDataBy2dimIterable(source, (i, j) => j * columnsNum + i,
        bytesPerElement);
  }

  DataManagerImpl.fromFlattened(
      List<double> source,
      int rowsNum,
      int colsNum,
      int bytesPerElement,
      this._dtype,
      this._typedListHelper,
  ) :
        rowsNum = rowsNum,
        columnsNum = colsNum,
        rowIndices = integers(0, rowsNum, upperClosed: false),
        columnIndices = integers(0, colsNum, upperClosed: false),
        _rowsCache = List<Vector>(rowsNum),
        _colsCache = List<Vector>(colsNum),
        _data = ByteData(rowsNum * colsNum * bytesPerElement) {
    if (source.length != rowsNum * colsNum) {
      throw Exception('Invalid matrix dimension has been provided - '
          '$rowsNum x $colsNum, but given a collection of length '
          '${source.length}');
    }
    _updateByteDataByFlattenedIterable(source);
  }

  @override
  final int columnsNum;

  @override
  final int rowsNum;

  @override
  final Iterable<int> rowIndices;

  @override
  final Iterable<int> columnIndices;

  final List<Vector> _rowsCache;
  final List<Vector> _colsCache;
  final ByteData _data;
  final DType _dtype;

  final TypedListHelper _typedListHelper;

  @override
  Iterator<Iterable<double>> get iterator =>
      MatrixIterator(_data, rowsNum, columnsNum, _typedListHelper);

  @override
  List<double> getValues(int index, int length) {
    if (index  >= rowsNum * columnsNum) {
      throw RangeError.range(index, 0, rowsNum * columnsNum);
    }
    return _typedListHelper.getBufferAsList(_data.buffer, index, length);
  }

  @override
  Vector getRow(int index) {
    _rowsCache[index] ??= Vector.fromList(getValues(index * columnsNum,
        columnsNum), dtype: _dtype);
    return _rowsCache[index];
  }

  @override
  Vector getColumn(int index) {
    if (_colsCache[index] == null) {
      final result = List<double>(rowsNum);
      for (final i in rowIndices) {
        //@TODO: find a more efficient way to get the single value
        result[i] = getValues(i * columnsNum + index, 1).first;
      }
      _colsCache[index] = Vector.fromList(result, dtype: _dtype);
    }
    return _colsCache[index];
  }

  void _updateByteDataByFlattenedIterable(List<double> values) =>
      _typedListHelper.getBufferAsList(_data.buffer).setAll(0, values);

  void _updateByteDataBy2dimIterable(Iterable<Iterable<double>> rows,
      int accessor(int i, int j), int bytesPerElement) {
    var i = 0;
    var j = 0;
    for (final row in rows) {
      for (final value in row) {
        _typedListHelper
            .setValue(_data, accessor(i, j) * bytesPerElement, value);
        j++;
      }
      i++;
      j = 0;
    }
  }
}
