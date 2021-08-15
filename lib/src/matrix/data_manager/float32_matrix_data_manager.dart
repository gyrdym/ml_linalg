import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/matrix/data_manager/matrix_data_manager.dart';
import 'package:ml_linalg/src/matrix/helper/get_2d_iterable_length.dart';
import 'package:ml_linalg/src/matrix/helper/get_length_of_first_or_zero.dart';
import 'package:ml_linalg/src/matrix/helper/get_zero_based_indices.dart';
import 'package:ml_linalg/src/matrix/iterator/float32_matrix_iterator.dart';
import 'package:ml_linalg/vector.dart';

const _bytesPerElement = Float32List.bytesPerElement;

class Float32MatrixDataManager implements MatrixDataManager {
  Float32MatrixDataManager.fromList(List<List<double>> source)
      : rowsNum = get2dIterableLength(source),
        columnsNum = getLengthOfFirstOrZero(source),
        rowIndices = getZeroBasedIndices(get2dIterableLength(source)),
        columnIndices = getZeroBasedIndices(getLengthOfFirstOrZero(source)),
        _rowsCache = List<Vector?>.filled(source.length, null),
        _colsCache = List<Vector?>.filled(getLengthOfFirstOrZero(source), null),
        _data = ByteData(
            source.length * getLengthOfFirstOrZero(source) * _bytesPerElement),
        areAllRowsCached = false,
        areAllColumnsCached = false {
    final dataAsList = _data.buffer.asFloat32List();

    for (var i = 0; i < source.length; i++) {
      if (source[i].length != columnsNum) {
        throw Exception('Wrong nested list length: ${source[i].length}, '
            'expected length: $columnsNum');
      }

      for (var j = 0; j < source[i].length; j++) {
        dataAsList[i * columnsNum + j] = source[i][j];
      }
    }
  }

  Float32MatrixDataManager.fromRows(List<Vector> source)
      : rowsNum = get2dIterableLength(source),
        columnsNum = getLengthOfFirstOrZero(source),
        rowIndices = getZeroBasedIndices(get2dIterableLength(source)),
        columnIndices = getZeroBasedIndices(getLengthOfFirstOrZero(source)),
        _rowsCache = [...source],
        _colsCache = List<Vector?>.filled(getLengthOfFirstOrZero(source), null),
        _data = ByteData(
            source.length * getLengthOfFirstOrZero(source) * _bytesPerElement),
        areAllRowsCached = true,
        areAllColumnsCached = false {
    final dataAsList = _data.buffer.asFloat32List();

    // ignore: omit_local_variable_types
    for (int i = 0, j = 0; i < source.length; i++, j = 0) {
      final row = source[i];

      if (row.dtype != dtype) {
        throw Exception('Vectors of different type are provided, '
            'expected vector type: `$dtype`, given: ${row.dtype}');
      }

      if (row.length != columnsNum) {
        throw Exception('Vectors of different length are provided, expected '
            'vector length: `$columnsNum`, given: ${row.length}');
      }

      for (final value in source[i]) {
        dataAsList[i * columnsNum + j++] = value;
      }
    }
  }

  Float32MatrixDataManager.fromColumns(List<Vector> source)
      : rowsNum = getLengthOfFirstOrZero(source),
        columnsNum = get2dIterableLength(source),
        rowIndices = getZeroBasedIndices(getLengthOfFirstOrZero(source)),
        columnIndices = getZeroBasedIndices(get2dIterableLength(source)),
        _rowsCache = List<Vector?>.filled(getLengthOfFirstOrZero(source), null),
        _colsCache = [...source],
        _data = ByteData(
            source.length * getLengthOfFirstOrZero(source) * _bytesPerElement),
        areAllRowsCached = false,
        areAllColumnsCached = true {
    final dataAsList = _data.buffer.asFloat32List();

    // ignore: omit_local_variable_types
    for (int i = 0, j = 0; i < source.length; i++, j = 0) {
      final column = source[i];

      if (column.dtype != dtype) {
        throw Exception('Vectors of different type are provided, expected '
            'vector type: `$dtype`, given: ${column.dtype}');
      }

      if (column.length != rowsNum) {
        throw Exception('Vectors of different length are provided, expected '
            'vector length: `$rowsNum`, given: ${column.length}');
      }

      for (final value in column) {
        dataAsList[j++ * columnsNum + i] = value;
      }
    }
  }

  Float32MatrixDataManager.fromFlattened(
      List<double> source, int rowsNum, int colsNum)
      : rowsNum = rowsNum,
        columnsNum = colsNum,
        rowIndices = getZeroBasedIndices(rowsNum),
        columnIndices = getZeroBasedIndices(colsNum),
        _rowsCache = List<Vector?>.filled(rowsNum, null),
        _colsCache = List<Vector?>.filled(colsNum, null),
        _data = Float32List.fromList(source).buffer.asByteData(),
        areAllRowsCached = false,
        areAllColumnsCached = false {
    if (source.length != rowsNum * colsNum) {
      throw Exception('Invalid matrix dimension has been provided - '
          '$rowsNum x $colsNum, but given a collection of length '
          '${source.length}');
    }
  }

  Float32MatrixDataManager.diagonal(List<double> source)
      : rowsNum = source.length,
        columnsNum = source.length,
        rowIndices = getZeroBasedIndices(source.length),
        columnIndices = getZeroBasedIndices(source.length),
        _rowsCache = List<Vector?>.filled(source.length, null),
        _colsCache = List<Vector?>.filled(source.length, null),
        _data = ByteData(source.length * source.length * _bytesPerElement),
        areAllRowsCached = false,
        areAllColumnsCached = false {
    for (var i = 0; i < rowsNum; i++) {
      _data.setFloat32(
          (i * columnsNum + i) * _bytesPerElement, source[i], Endian.host);
    }
  }

  Float32MatrixDataManager.scalar(double scalar, int size)
      : rowsNum = size,
        columnsNum = size,
        rowIndices = getZeroBasedIndices(size),
        columnIndices = getZeroBasedIndices(size),
        _rowsCache = List<Vector?>.filled(size, null),
        _colsCache = List<Vector?>.filled(size, null),
        _data = ByteData(size * size * _bytesPerElement),
        areAllRowsCached = false,
        areAllColumnsCached = false {
    for (var i = 0; i < size; i++) {
      _data.setFloat32(
          (i * columnsNum + i) * _bytesPerElement, scalar, Endian.host);
    }
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

  @override
  final bool areAllRowsCached;

  @override
  final bool areAllColumnsCached;

  final List<Vector?> _rowsCache;
  final List<Vector?> _colsCache;
  final ByteData _data;

  @override
  Iterator<Iterable<double>> get iterator =>
      Float32MatrixIterator(_data, rowsNum, columnsNum);

  @override
  bool get hasData => rowsNum > 0 && columnsNum > 0;

  @override
  Vector getRow(int index) {
    if (!hasData) {
      throw Exception('Matrix is empty');
    }

    final indexFrom = index * columnsNum;

    if (indexFrom >= rowsNum * columnsNum) {
      throw RangeError.range(indexFrom, 0, rowsNum * columnsNum);
    }

    final values =
        _data.buffer.asFloat32List(indexFrom * _bytesPerElement, columnsNum);
    _rowsCache[index] ??= Vector.fromList(values, dtype: dtype);

    return _rowsCache[index]!;
  }

  @override
  Vector getColumn(int index) {
    if (!hasData) {
      throw Exception('Matrix is empty');
    }

    if (_colsCache[index] == null) {
      final result = List<num>.generate(
          rowsNum,
          (i) => _data.getFloat32(
              (i * columnsNum + index) * _bytesPerElement, Endian.host));

      _colsCache[index] = Vector.fromList(result, dtype: dtype);
    }

    return _colsCache[index]!;
  }
}
