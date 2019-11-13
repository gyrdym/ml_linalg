import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/matrix/common/matrix_data_manager.dart';
import 'package:ml_linalg/src/matrix/float32_matrix_iterator.dart';
import 'package:ml_linalg/src/matrix/helpers/get_2d_iterable_length.dart';
import 'package:ml_linalg/src/matrix/helpers/get_length_of_first_or_zero.dart';
import 'package:ml_linalg/src/matrix/helpers/get_zero_based_indices.dart';
import 'package:ml_linalg/vector.dart';

const _bytesPerElement = Float32List.bytesPerElement;

class Float32MatrixDataManager implements MatrixDataManager {
  Float32MatrixDataManager.fromList(List<List<double>> source) :
        rowsNum = get2dIterableLength(source),
        columnsNum = getLengthOfFirstOrZero(source),
        rowIndices = getZeroBasedIndices(get2dIterableLength(source)),
        columnIndices = getZeroBasedIndices(getLengthOfFirstOrZero(source)),
        _rowsCache = List<Vector>(source.length),
        _colsCache = List<Vector>(getLengthOfFirstOrZero(source)),
        _data = ByteData(source.length *
            getLengthOfFirstOrZero(source) * _bytesPerElement) {
    var i = 0;
    var j = 0;
    final dataAsList = _data.buffer.asFloat32List();
    for (final row in source) {
      for (final value in row) {
        dataAsList[i * columnsNum + j++] = value;
      }
      i++;
      j = 0;
    }
  }

  Float32MatrixDataManager.fromRows(List<Vector> source) :
        rowsNum = get2dIterableLength(source),
        columnsNum = getLengthOfFirstOrZero(source),
        rowIndices = getZeroBasedIndices(get2dIterableLength(source)),
        columnIndices = getZeroBasedIndices(getLengthOfFirstOrZero(source)),
        _rowsCache = source,
        _colsCache = List<Vector>(getLengthOfFirstOrZero(source)),
        _data = ByteData(source.length *
            getLengthOfFirstOrZero(source) * _bytesPerElement) {
    var i = 0;
    var j = 0;
    final dataAsList = _data.buffer.asFloat32List();
    for (final row in source) {
      for (final value in row) {
        dataAsList[i * columnsNum + j++] = value;
      }
      i++;
      j = 0;
    }
  }

  Float32MatrixDataManager.fromColumns(List<Vector> source) :
        rowsNum = getLengthOfFirstOrZero(source),
        columnsNum = get2dIterableLength(source),
        rowIndices = getZeroBasedIndices(getLengthOfFirstOrZero(source)),
        columnIndices = getZeroBasedIndices(get2dIterableLength(source)),
        _rowsCache = List<Vector>(getLengthOfFirstOrZero(source)),
        _colsCache = source,
        _data = ByteData(source.length *
            getLengthOfFirstOrZero(source) * _bytesPerElement) {
    var i = 0;
    var j = 0;
    final dataAsList = _data.buffer.asFloat32List();
    for (final column in source) {
      for (final value in column) {
        dataAsList[j++ * columnsNum + i] = value;
      }
      i++;
      j = 0;
    }
  }

  Float32MatrixDataManager.fromFlattened(List<double> source, int rowsNum,
      int colsNum) :
        rowsNum = rowsNum,
        columnsNum = colsNum,
        rowIndices = getZeroBasedIndices(rowsNum),
        columnIndices = getZeroBasedIndices(colsNum),
        _rowsCache = List<Vector>(rowsNum),
        _colsCache = List<Vector>(colsNum),
        _data = Float32List.fromList(source).buffer.asByteData() {
    if (source.length != rowsNum * colsNum) {
      throw Exception('Invalid matrix dimension has been provided - '
          '$rowsNum x $colsNum, but given a collection of length '
          '${source.length}');
    }
  }

  Float32MatrixDataManager.diagonal(List<double> source) :
        rowsNum = source.length,
        columnsNum = source.length,
        rowIndices = getZeroBasedIndices(source.length),
        columnIndices = getZeroBasedIndices(source.length),
        _rowsCache = List<Vector>(source.length),
        _colsCache = List<Vector>(source.length),
        _data = ByteData(source.length * source.length * _bytesPerElement) {
    _updateByteDataForDiagonalMatrix((i) => source[i]);
  }

  Float32MatrixDataManager.scalar(double scalar, int size) :
        rowsNum = size,
        columnsNum = size,
        rowIndices = getZeroBasedIndices(size),
        columnIndices = getZeroBasedIndices(size),
        _rowsCache = List<Vector>(size),
        _colsCache = List<Vector>(size),
        _data = ByteData(size * size * _bytesPerElement) {
    _updateByteDataForDiagonalMatrix((i) => scalar);
  }

  @override
  final DType dtype = DType.float32;

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

  @override
  Iterator<Iterable<double>> get iterator =>
      Float32MatrixIterator(_data, rowsNum, columnsNum);

  @override
  bool get hasData => rowsNum > 0 && columnsNum > 0;

  @override
  List<double> getValues(int indexFrom, int count) {
    if (!hasData) {
      throw Exception('Matrix is empty');
    }
    if (indexFrom  >= rowsNum * columnsNum) {
      throw RangeError.range(indexFrom, 0, rowsNum * columnsNum);
    }
    return _data.buffer.asFloat32List(indexFrom * _bytesPerElement, count);
  }

  @override
  Vector getRow(int index) {
    if (!hasData) {
      throw Exception('Matrix is empty');
    }
    _rowsCache[index] ??= Vector.fromList(getValues(index * columnsNum,
        columnsNum), dtype: dtype);
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
      _colsCache[index] = Vector.fromList(result, dtype: dtype);
    }
    return _colsCache[index];
  }

  void _updateByteDataForDiagonalMatrix(double generateValue(int i)) {
    for (int i = 0; i < rowsNum; i++) {
      for (int j = 0; j < columnsNum; j++) {
        final value = i == j ? generateValue(i) : 0.0;
        _data.setFloat32((i * columnsNum + j) * _bytesPerElement, value,
            Endian.host);
      }
    }
  }
}
