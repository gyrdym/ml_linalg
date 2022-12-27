/* This file is auto generated, do not change it manually */

import 'dart:typed_data';
import 'dart:math' as math;

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/matrix/data_manager/matrix_data_manager.dart';
import 'package:ml_linalg/src/matrix/helper/get_2d_iterable_length.dart';
import 'package:ml_linalg/src/matrix/helper/get_length_of_first_or_zero.dart';
import 'package:ml_linalg/src/matrix/helper/get_zero_based_indices.dart';
import 'package:ml_linalg/src/matrix/iterator/float64_matrix_iterator.g.dart';
import 'package:ml_linalg/vector.dart';

const _bytesPerElement = Float64List.bytesPerElement;
const _simdSize = Float64x2List.bytesPerElement ~/ Float64List.bytesPerElement;

class Float64MatrixDataManager
    implements MatrixDataManager<Float64x2, Float64x2List> {
  Float64MatrixDataManager.fromList(List<List<double>> source)
      : rowCount = get2dIterableLength(source),
        colCount = getLengthOfFirstOrZero(source),
        rowIndices = getZeroBasedIndices(get2dIterableLength(source)),
        columnIndices = getZeroBasedIndices(getLengthOfFirstOrZero(source)),
        _rowsCache = List<Vector?>.filled(source.length, null),
        _colsCache = List<Vector?>.filled(getLengthOfFirstOrZero(source), null),
        flattenedList =
            Float64List(source.length * getLengthOfFirstOrZero(source)),
        areAllRowsCached = false,
        areAllColumnsCached = false {
    for (var i = 0; i < source.length; i++) {
      if (source[i].length != colCount) {
        throw Exception('Wrong nested list length: ${source[i].length}, '
            'expected length: $colCount');
      }

      for (var j = 0; j < source[i].length; j++) {
        flattenedList[i * colCount + j] = source[i][j];
      }
    }
  }

  Float64MatrixDataManager.fromRows(List<Vector> source)
      : rowCount = get2dIterableLength(source),
        colCount = getLengthOfFirstOrZero(source),
        rowIndices = getZeroBasedIndices(get2dIterableLength(source)),
        columnIndices = getZeroBasedIndices(getLengthOfFirstOrZero(source)),
        _rowsCache = [...source],
        _colsCache = List<Vector?>.filled(getLengthOfFirstOrZero(source), null),
        flattenedList =
            Float64List(source.length * getLengthOfFirstOrZero(source)),
        areAllRowsCached = true,
        areAllColumnsCached = false {
    for (var i = 0, j = 0; i < source.length; i++, j = 0) {
      final row = source[i];

      if (row.length != colCount) {
        throw Exception('Vectors of different length are provided, expected '
            'vector length: `$colCount`, given: ${row.length}');
      }

      for (final value in row) {
        flattenedList[i * colCount + j] = value;
        j++;
      }
    }
  }

  Float64MatrixDataManager.fromColumns(List<Vector> source)
      : rowCount = getLengthOfFirstOrZero(source),
        colCount = get2dIterableLength(source),
        rowIndices = getZeroBasedIndices(getLengthOfFirstOrZero(source)),
        columnIndices = getZeroBasedIndices(get2dIterableLength(source)),
        _rowsCache = List<Vector?>.filled(getLengthOfFirstOrZero(source), null),
        _colsCache = [...source],
        flattenedList =
            Float64List(source.length * getLengthOfFirstOrZero(source)),
        areAllRowsCached = false,
        areAllColumnsCached = true {
    for (var i = 0, j = 0; i < source.length; i++, j = 0) {
      final column = source[i];

      if (column.length != rowCount) {
        throw Exception('Vectors of different length are provided, expected '
            'vector length: `$rowCount`, given: ${column.length}');
      }

      for (final value in column) {
        flattenedList[j * colCount + i] = value;
        j++;
      }
    }
  }

  Float64MatrixDataManager.fromFlattened(
      List<double> source, int rowsNum, int colsNum)
      : rowCount = rowsNum,
        colCount = colsNum,
        rowIndices = getZeroBasedIndices(rowsNum),
        columnIndices = getZeroBasedIndices(colsNum),
        _rowsCache = List<Vector?>.filled(rowsNum, null),
        _colsCache = List<Vector?>.filled(colsNum, null),
        flattenedList =
            source is Float64List ? source : Float64List.fromList(source),
        areAllRowsCached = false,
        areAllColumnsCached = false {
    if (source.length < rowsNum * colsNum) {
      throw Exception('Invalid matrix dimension has been provided - '
          '$rowsNum x $colsNum, but given a collection of length '
          '${source.length}');
    }
  }

  Float64MatrixDataManager.fromByteData(
      ByteData source, int rowsNum, int colsNum)
      : rowCount = rowsNum,
        colCount = colsNum,
        rowIndices = getZeroBasedIndices(rowsNum),
        columnIndices = getZeroBasedIndices(colsNum),
        _rowsCache = List<Vector?>.filled(rowsNum, null),
        _colsCache = List<Vector?>.filled(colsNum, null),
        flattenedList = source.buffer.asFloat64List(),
        areAllRowsCached = false,
        areAllColumnsCached = false {
    if (source.lengthInBytes != rowsNum * colsNum * _bytesPerElement) {
      throw Exception('Invalid matrix dimension has been provided - '
          '$rowsNum x $colsNum (${rowsNum * colCount} elements), but byte data of '
          '${source.lengthInBytes / _bytesPerElement} elements has been given');
    }
  }

  Float64MatrixDataManager.diagonal(List<double> source)
      : rowCount = source.length,
        colCount = source.length,
        rowIndices = getZeroBasedIndices(source.length),
        columnIndices = getZeroBasedIndices(source.length),
        _rowsCache = List<Vector?>.filled(source.length, null),
        _colsCache = List<Vector?>.filled(source.length, null),
        flattenedList = Float64List(source.length * source.length),
        areAllRowsCached = false,
        areAllColumnsCached = false {
    for (var i = 0; i < rowCount; i++) {
      flattenedList[i * colCount + i] = source[i];
    }
  }

  Float64MatrixDataManager.scalar(double scalar, int size)
      : rowCount = size,
        colCount = size,
        rowIndices = getZeroBasedIndices(size),
        columnIndices = getZeroBasedIndices(size),
        _rowsCache = List<Vector?>.filled(size, null),
        _colsCache = List<Vector?>.filled(size, null),
        flattenedList = Float64List(size * size),
        areAllRowsCached = false,
        areAllColumnsCached = false {
    for (var i = 0; i < size; i++) {
      flattenedList[i * colCount + i] = scalar;
    }
  }

  Float64MatrixDataManager.random(DType dtype, int rowsNum, int columnsNum,
      {num min = -1000, num max = 1000, int? seed})
      : rowCount = rowsNum,
        colCount = columnsNum,
        rowIndices = getZeroBasedIndices(rowsNum),
        columnIndices = getZeroBasedIndices(columnsNum),
        _rowsCache = List<Vector?>.filled(rowsNum, null),
        _colsCache = List<Vector?>.filled(columnsNum, null),
        flattenedList = Float64List(rowsNum * columnsNum),
        areAllRowsCached = false,
        areAllColumnsCached = false {
    if (min >= max) {
      throw ArgumentError.value(min,
          'Argument `min` should be less than `max`, min: $min, max: $max');
    }

    final generator = math.Random(seed);
    final diff = max - min;

    for (var i = 0; i < columnsNum * rowsNum; i++) {
      flattenedList[i] = generator.nextDouble() * diff + min;
    }
  }

  @override
  final Float64List flattenedList;

  @override
  final DType dtype = DType.float64;

  @override
  final int colCount;

  @override
  final int rowCount;

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

  @override
  Iterator<Iterable<double>> get iterator =>
      Float64MatrixIterator(flattenedList, rowCount, colCount);

  @override
  bool get hasData => rowCount > 0 && colCount > 0;

  @override
  Vector getRow(int index) {
    if (!hasData) {
      throw Exception('Matrix is empty');
    }

    final indexFrom = index * colCount;

    if (indexFrom >= rowCount * colCount) {
      throw RangeError.range(indexFrom, 0, rowCount * colCount);
    }

    if (_rowsCache[index] == null) {
      final values = flattenedList.sublist(indexFrom, indexFrom + colCount);

      _rowsCache[index] = Vector.fromList(values, dtype: dtype);
    }

    return _rowsCache[index]!;
  }

  @override
  Vector getColumn(int index) {
    if (!hasData) {
      throw Exception('Matrix is empty');
    }

    if (_colsCache[index] == null) {
      final column = Float64List(rowCount);

      for (var i = 0; i < rowCount; i++) {
        column[i] = flattenedList[i * colCount + index];
      }

      _colsCache[index] = Vector.fromList(column, dtype: dtype);
    }

    return _colsCache[index]!;
  }

  @override
  Float64x2List createEmptySimdList() {
    final realLength = rowCount * colCount;
    final residual = realLength % _simdSize;
    final dim = residual == 0
        ? realLength
        : (realLength + _simdSize - residual) ~/ _simdSize;

    return Float64x2List(dim);
  }

  @override
  Float64x2List getFlattenedSimdList() {
    if (_cachedSimdList == null) {
      final realLength = rowCount * colCount;
      final residual = realLength % _simdSize;

      if (residual != 0) {
        final lastSimdFirstIdx = flattenedList.length - residual;
        final x = flattenedList[lastSimdFirstIdx];
        final y = lastSimdFirstIdx + 1 < flattenedList.length
            ? flattenedList[lastSimdFirstIdx + 1]
            : 0.0;
        final z = lastSimdFirstIdx + 2 < flattenedList.length
            ? flattenedList[lastSimdFirstIdx + 2]
            : 0.0;

        lastSimd = Float64x2(x, y);
      }

      _cachedSimdList = flattenedList.buffer.asFloat64x2List();
    }

    return _cachedSimdList!;
  }

  Float64x2List? _cachedSimdList;

  @override
  Float64x2? lastSimd;
}
