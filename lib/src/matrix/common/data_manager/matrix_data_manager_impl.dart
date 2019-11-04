import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/common/helper/get_2d_iterable_length.dart';
import 'package:ml_linalg/src/common/helper/get_zero_based_indices.dart';
import 'package:ml_linalg/src/common/helper/get_length_of_first_or_zero.dart';
import 'package:ml_linalg/src/common/typed_list_helper/typed_list_helper.dart';
import 'package:ml_linalg/src/matrix/common/data_manager/matrix_data_manager.dart';
import 'package:ml_linalg/src/matrix/common/matrix_iterator.dart';
import 'package:ml_linalg/vector.dart';

class MatrixDataManagerImpl implements MatrixDataManager {
  MatrixDataManagerImpl.fromList(
      List<List<double>> source,
      int bytesPerElement,
      this._dtype,
      this._typedListHelper,
  ) :
        rowsNum = get2dIterableLength(source),
        columnsNum = getLengthOfFirstOrZero(source),
        rowIndices = getZeroBasedIndices(get2dIterableLength(source)),
        columnIndices = getZeroBasedIndices(getLengthOfFirstOrZero(source)),
        _rowsCache = List<Vector>(source.length),
        _colsCache = List<Vector>(getLengthOfFirstOrZero(source)),
        _data = ByteData(source.length *
            getLengthOfFirstOrZero(source) * bytesPerElement) {
    _updateByteDataBy2dimIterable(source, (i, j) => i * columnsNum + j,
        bytesPerElement);
  }

  MatrixDataManagerImpl.fromRows(
      List<Vector> source,
      int bytesPerElement,
      this._dtype,
      this._typedListHelper,
  ) :
        rowsNum = get2dIterableLength(source),
        columnsNum = getLengthOfFirstOrZero(source),
        rowIndices = getZeroBasedIndices(get2dIterableLength(source)),
        columnIndices = getZeroBasedIndices(getLengthOfFirstOrZero(source)),
        _rowsCache = source.toList(growable: false),
        _colsCache = List<Vector>(getLengthOfFirstOrZero(source)),
        _data = ByteData(source.length *
            getLengthOfFirstOrZero(source) * bytesPerElement) {
    _updateByteDataBy2dimIterable(source, (i, j) => i * columnsNum + j,
        bytesPerElement);
  }

  MatrixDataManagerImpl.fromColumns(
      List<Vector> source,
      int bytesPerElement,
      this._dtype,
      this._typedListHelper,
  ) :
        rowsNum = getLengthOfFirstOrZero(source),
        columnsNum = get2dIterableLength(source),
        rowIndices = getZeroBasedIndices(getLengthOfFirstOrZero(source)),
        columnIndices = getZeroBasedIndices(get2dIterableLength(source)),
        _rowsCache = List<Vector>(getLengthOfFirstOrZero(source)),
        _colsCache = source.toList(growable: false),
        _data = ByteData(source.length *
            getLengthOfFirstOrZero(source) * bytesPerElement) {
    _updateByteDataBy2dimIterable(source, (i, j) => j * columnsNum + i,
        bytesPerElement);
  }

  MatrixDataManagerImpl.fromFlattened(
      List<double> source,
      int rowsNum,
      int colsNum,
      int bytesPerElement,
      this._dtype,
      this._typedListHelper,
  ) :
        rowsNum = rowsNum,
        columnsNum = colsNum,
        rowIndices = getZeroBasedIndices(rowsNum),
        columnIndices = getZeroBasedIndices(colsNum),
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

  MatrixDataManagerImpl.diagonal(
      List<double> source,
      int bytesPerElement,
      this._dtype,
      this._typedListHelper,
      ) :
        rowsNum = source.length,
        columnsNum = source.length,
        rowIndices = getZeroBasedIndices(source.length),
        columnIndices = getZeroBasedIndices(source.length),
        _rowsCache = List<Vector>(source.length),
        _colsCache = List<Vector>(source.length),
        _data = ByteData(source.length * source.length * bytesPerElement) {
    _updateByteDataForDiagonalMatrix(bytesPerElement, (i) => source[i]);
  }

  MatrixDataManagerImpl.scalar(
      double scalar,
      int size,
      int bytesPerElement,
      this._dtype,
      this._typedListHelper,
      ) :
        rowsNum = size,
        columnsNum = size,
        rowIndices = getZeroBasedIndices(size),
        columnIndices = getZeroBasedIndices(size),
        _rowsCache = List<Vector>(size),
        _colsCache = List<Vector>(size),
        _data = ByteData(size * size * bytesPerElement) {
    _updateByteDataForDiagonalMatrix(bytesPerElement, (i) => scalar);
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
  bool get hasData => rowsNum > 0 && columnsNum > 0;

  @override
  List<double> getValues(int index, int length) {
    if (!hasData) {
      throw Exception('Matrix is empty');
    }
    if (index  >= rowsNum * columnsNum) {
      throw RangeError.range(index, 0, rowsNum * columnsNum);
    }
    return _typedListHelper.getBufferAsList(_data.buffer, index, length);
  }

  @override
  Vector getRow(int index) {
    if (!hasData) {
      throw Exception('Matrix is empty');
    }
    _rowsCache[index] ??= Vector.fromList(getValues(index * columnsNum,
        columnsNum), dtype: _dtype);
    return _rowsCache[index];
  }

  @override
  Vector getColumn(int index) {
    if (!hasData) {
      throw Exception('Matrix is empty');
    }
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
      int flatten2dIndices(int i, int j), int bytesPerElement) {
    var i = 0;
    var j = 0;
    for (final row in rows) {
      for (final value in row) {
        _typedListHelper
            .setValue(_data, flatten2dIndices(i, j) * bytesPerElement, value);
        j++;
      }
      i++;
      j = 0;
    }
  }

  void _updateByteDataForDiagonalMatrix(int bytesPerElement,
      double generateValue(int i)) {
    for (int i = 0; i < rowsNum; i++) {
      for (int j = 0; j < columnsNum; j++) {
        final value = i == j ? generateValue(i) : 0.0;
        _typedListHelper
            .setValue(_data, (i * columnsNum + j) * bytesPerElement, value);
      }
    }
  }
}
