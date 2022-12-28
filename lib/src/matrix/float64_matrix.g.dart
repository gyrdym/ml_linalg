/* This file is auto generated, do not change it manually */
// ignore_for_file: unused_local_variable

import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ml_linalg/axis.dart';
import 'package:ml_linalg/decomposition.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/inverse.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/matrix_norm.dart';
import 'package:ml_linalg/sort_direction.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager_impl.dart';
import 'package:ml_linalg/src/common/exception/backward_substitution_non_square_matrix_exception.dart';
import 'package:ml_linalg/src/common/exception/cholesky_inappropriate_matrix_exception.dart';
import 'package:ml_linalg/src/common/exception/cholesky_non_square_matrix_exception.dart';
import 'package:ml_linalg/src/common/exception/forward_substitution_non_square_matrix_exception.dart';
import 'package:ml_linalg/src/common/exception/lu_decomposition_non_square_matrix_exception.dart';
import 'package:ml_linalg/src/common/exception/matrix_division_by_vector_exception.dart';
import 'package:ml_linalg/src/common/exception/square_matrix_division_by_vector_exception.dart';
import 'package:ml_linalg/src/matrix/eigen.dart';
import 'package:ml_linalg/src/matrix/eigen_method.dart';
import 'package:ml_linalg/src/matrix/helper/get_2d_iterable_length.dart';
import 'package:ml_linalg/src/matrix/helper/get_length_of_first_or_zero.dart';
import 'package:ml_linalg/src/matrix/helper/get_zero_based_indices.dart';
import 'package:ml_linalg/src/matrix/iterator/float64_matrix_iterator.g.dart';
import 'package:ml_linalg/src/matrix/matrix_cache_keys.dart';
import 'package:ml_linalg/src/matrix/mixin/matrix_validator_mixin.dart';
import 'package:ml_linalg/src/matrix/serialization/matrix_to_json.dart';
import 'package:ml_linalg/vector.dart';
import 'package:quiver/iterables.dart';

const _bytesPerElement = Float64List.bytesPerElement;
const _simdSize = Float64x2List.bytesPerElement ~/ Float64List.bytesPerElement;

class Float64Matrix
    with IterableMixin<Iterable<double>>, MatrixValidatorMixin
    implements Matrix {
  Float64Matrix.fromList(List<List<double>> source)
      : rowCount = get2dIterableLength(source),
        colCount = getLengthOfFirstOrZero(source),
        rowIndices = getZeroBasedIndices(get2dIterableLength(source)),
        columnIndices = getZeroBasedIndices(getLengthOfFirstOrZero(source)),
        _rowsCache = List<Vector?>.filled(source.length, null),
        _colsCache = List<Vector?>.filled(getLengthOfFirstOrZero(source), null),
        _flattenedList =
            Float64List(source.length * getLengthOfFirstOrZero(source)),
        _areAllRowsCached = false {
    for (var i = 0; i < source.length; i++) {
      if (source[i].length != colCount) {
        throw Exception('Wrong nested list length: ${source[i].length}, '
            'expected length: $colCount');
      }

      for (var j = 0; j < source[i].length; j++) {
        _flattenedList[i * colCount + j] = source[i][j];
      }
    }
  }

  Float64Matrix.fromRows(List<Vector> source)
      : rowCount = get2dIterableLength(source),
        colCount = getLengthOfFirstOrZero(source),
        rowIndices = getZeroBasedIndices(get2dIterableLength(source)),
        columnIndices = getZeroBasedIndices(getLengthOfFirstOrZero(source)),
        _rowsCache = [...source],
        _colsCache = List<Vector?>.filled(getLengthOfFirstOrZero(source), null),
        _flattenedList =
            Float64List(source.length * getLengthOfFirstOrZero(source)),
        _areAllRowsCached = true {
    for (var i = 0, j = 0; i < source.length; i++, j = 0) {
      final row = source[i];

      if (row.length != colCount) {
        throw Exception('Vectors of different length are provided, expected '
            'vector length: `$colCount`, given: ${row.length}');
      }

      for (final value in row) {
        _flattenedList[i * colCount + j] = value;
        j++;
      }
    }
  }

  Float64Matrix.fromColumns(List<Vector> source)
      : rowCount = getLengthOfFirstOrZero(source),
        colCount = get2dIterableLength(source),
        rowIndices = getZeroBasedIndices(getLengthOfFirstOrZero(source)),
        columnIndices = getZeroBasedIndices(get2dIterableLength(source)),
        _rowsCache = List<Vector?>.filled(getLengthOfFirstOrZero(source), null),
        _colsCache = [...source],
        _flattenedList =
            Float64List(source.length * getLengthOfFirstOrZero(source)),
        _areAllRowsCached = false {
    for (var i = 0, j = 0; i < source.length; i++, j = 0) {
      final column = source[i];

      if (column.length != rowCount) {
        throw Exception('Vectors of different length are provided, expected '
            'vector length: `$rowCount`, given: ${column.length}');
      }

      for (final value in column) {
        _flattenedList[j * colCount + i] = value;
        j++;
      }
    }
  }

  Float64Matrix.fromFlattened(List<double> source, int rowCount, int colCount)
      : rowCount = rowCount,
        colCount = colCount,
        rowIndices = getZeroBasedIndices(rowCount),
        columnIndices = getZeroBasedIndices(colCount),
        _rowsCache = List<Vector?>.filled(rowCount, null),
        _colsCache = List<Vector?>.filled(colCount, null),
        _flattenedList =
            source is Float64List ? source : Float64List.fromList(source),
        _areAllRowsCached = false {
    if (source.length < rowCount * colCount) {
      throw Exception('Invalid matrix dimension has been provided - '
          '$rowCount x $colCount, but given a collection of length '
          '${source.length}');
    }
  }

  Float64Matrix.fromByteData(ByteData source, int rowCount, int columnCount)
      : rowCount = rowCount,
        colCount = columnCount,
        rowIndices = getZeroBasedIndices(rowCount),
        columnIndices = getZeroBasedIndices(columnCount),
        _rowsCache = List<Vector?>.filled(rowCount, null),
        _colsCache = List<Vector?>.filled(columnCount, null),
        _flattenedList = source.buffer.asFloat64List(),
        _areAllRowsCached = false {
    if (source.lengthInBytes != rowCount * columnCount * _bytesPerElement) {
      throw Exception('Invalid matrix dimension has been provided - '
          '$rowCount x $colCount (${rowCount * colCount} elements), but byte data of '
          '${source.lengthInBytes / _bytesPerElement} elements has been given');
    }
  }

  Float64Matrix.diagonal(List<double> source)
      : rowCount = source.length,
        colCount = source.length,
        rowIndices = getZeroBasedIndices(source.length),
        columnIndices = getZeroBasedIndices(source.length),
        _rowsCache = List<Vector?>.filled(source.length, null),
        _colsCache = List<Vector?>.filled(source.length, null),
        _flattenedList = Float64List(source.length * source.length),
        _areAllRowsCached = false {
    for (var i = 0; i < rowCount; i++) {
      _flattenedList[i * colCount + i] = source[i];
    }
  }

  Float64Matrix.scalar(double scalar, int size)
      : rowCount = size,
        colCount = size,
        rowIndices = getZeroBasedIndices(size),
        columnIndices = getZeroBasedIndices(size),
        _rowsCache = List<Vector?>.filled(size, null),
        _colsCache = List<Vector?>.filled(size, null),
        _flattenedList = Float64List(size * size),
        _areAllRowsCached = false {
    for (var i = 0; i < size; i++) {
      _flattenedList[i * colCount + i] = scalar;
    }
  }

  Float64Matrix.random(DType dtype, int rowCount, int colCount,
      {num min = -1000, num max = 1000, int? seed})
      : rowCount = rowCount,
        colCount = colCount,
        rowIndices = getZeroBasedIndices(rowCount),
        columnIndices = getZeroBasedIndices(colCount),
        _rowsCache = List<Vector?>.filled(rowCount, null),
        _colsCache = List<Vector?>.filled(colCount, null),
        _flattenedList = Float64List(rowCount * colCount),
        _areAllRowsCached = false {
    if (min >= max) {
      throw ArgumentError.value(min,
          'Argument `min` should be less than `max`, min: $min, max: $max');
    }

    final generator = math.Random(seed);
    final diff = max - min;

    for (var i = 0; i < colCount * rowCount; i++) {
      _flattenedList[i] = generator.nextDouble() * diff + min;
    }
  }

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

  final bool _areAllRowsCached;
  final List<Vector?> _rowsCache;
  final List<Vector?> _colsCache;
  final Float64List _flattenedList;
  final _cache = CacheManagerImpl(matrixCacheKeys);

  @override
  Iterator<Iterable<double>> get iterator =>
      Float64MatrixIterator(_flattenedList, rowCount, colCount);

  @override
  bool get hasData => rowCount > 0 && colCount > 0;

  @override
  int get rowsNum => rowCount;

  @override
  int get columnsNum => colCount;

  @override
  bool get isSquare => colCount == rowCount;

  @override
  Iterable<Vector> get rows => rowIndices.map(getRow);

  @override
  Iterable<Vector> get columns => columnIndices.map(getColumn);

  @override
  List<double> get asFlattenedList => _flattenedList;

  @override
  Matrix operator +(Object value) {
    if (value is Matrix) {
      return _matrixAdd(value);
    }

    if (value is num) {
      return _matrixScalarAdd(value.toDouble());
    }

    throw UnsupportedError(
        'Cannot add a ${value.runtimeType} to a $runtimeType');
  }

  @override
  Matrix operator -(Object value) {
    if (value is Matrix) {
      return _matrixSub(value);
    }

    if (value is num) {
      return _matrixScalarSub(value.toDouble());
    }

    throw UnsupportedError(
        'Cannot subtract a ${value.runtimeType} from a $runtimeType');
  }

  /// Mathematical matrix multiplication
  ///
  /// The main rule:
  ///
  /// let `N` be a number of columns, so the multiplication is
  /// available only for X by N * N by Y matrices, that causes X by Y matrix
  @override
  Matrix operator *(Object value) {
    if (value is Vector) {
      return _matrixVectorMul(value);
    }

    if (value is Matrix) {
      return _matrixMul(value);
    }

    if (value is num) {
      return _matrixScalarMul(value.toDouble());
    }

    throw UnsupportedError(
        'Cannot multiple a $runtimeType by a ${value.runtimeType}');
  }

  /// Performs division of the matrix by vector, matrix or scalar
  @override
  Matrix operator /(Object value) {
    if (value is Vector) {
      return _matrixByVectorDiv(value);
    }

    if (value is Matrix) {
      return _matrixByMatrixDiv(value);
    }

    if (value is num) {
      return _matrixByScalarDiv(value.toDouble());
    }

    throw UnsupportedError(
        'Cannot divide a $runtimeType by a ${value.runtimeType}');
  }

  @override
  Vector operator [](int index) => getRow(index);

  @override
  Matrix transpose() {
    final list = _flattenedList;
    final source = Float64List(colCount * rowCount);

    for (var i = 0; i < list.length; i++) {
      final rowIdx = i ~/ colCount;
      final colIdx = i - colCount * rowIdx;

      source[colIdx * rowCount + rowIdx] = list[i];
    }

    return Matrix.fromFlattenedList(source, colCount, rowCount, dtype: dtype);
  }

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
      final values = _flattenedList.sublist(indexFrom, indexFrom + colCount);

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
        column[i] = _flattenedList[i * colCount + index];
      }

      _colsCache[index] = Vector.fromList(column, dtype: dtype);
    }

    return _colsCache[index]!;
  }

  @override
  Matrix sample({
    Iterable<int> rowIndices = const [],
    Iterable<int> columnIndices = const [],
  }) {
    final indices = rowIndices.isEmpty
        ? count(0).take(rowCount).map((i) => i.toInt())
        : rowIndices;
    final targetMatrixSource = indices.map((index) {
      final sourceRow = getRow(index);

      return columnIndices.isEmpty
          ? sourceRow
          : sourceRow.sample(columnIndices);
    }).toList(growable: false);

    return Matrix.fromRows(targetMatrixSource, dtype: dtype);
  }

  @override
  Vector reduceColumns(
    Vector Function(Vector combine, Vector vector) combiner, {
    Vector? initValue,
  }) =>
      _reduce(
        combiner,
        colCount,
        getColumn,
        initValue: initValue,
      );

  @override
  Vector reduceRows(Vector Function(Vector combine, Vector vector) combiner,
          {Vector? initValue}) =>
      _reduce(
        combiner,
        rowCount,
        getRow,
        initValue: initValue,
      );

  @override
  Matrix mapElements(double Function(double element) mapper) =>
      _areAllRowsCached
          ? mapRows((row) => row.mapToVector(mapper))
          : mapColumns((column) => column.mapToVector(mapper));

  @override
  Matrix mapColumns(Vector Function(Vector columns) mapper) =>
      Matrix.fromColumns(
          List.generate(colCount, (int i) => mapper(getColumn(i))),
          dtype: dtype);

  @override
  Matrix filterColumns(bool Function(Vector column, int idx) predicate) {
    var i = 0;
    return Matrix.fromColumns(
        columns.where((column) => predicate(column, i++)).toList(),
        dtype: dtype);
  }

  @override
  Matrix mapRows(Vector Function(Vector row) mapper) =>
      Matrix.fromRows(List.generate(rowCount, (int i) => mapper(getRow(i))),
          dtype: dtype);

  @override
  Matrix uniqueRows() {
    final checked = <Vector>[];

    for (final i in rowIndices) {
      final row = getRow(i);

      if (!checked.contains(row)) {
        checked.add(row);
      }
    }

    return Matrix.fromRows(checked, dtype: dtype);
  }

  @override
  Vector mean([Axis axis = Axis.columns]) {
    if (!hasData) {
      return Vector.empty(dtype: dtype);
    }

    switch (axis) {
      case Axis.columns:
        return _cache.get(matrixMeansByColumnsKey, () => _mean(columns));

      case Axis.rows:
        return _cache.get(matrixMeansByRowsKey, () => _mean(rows));

      default:
        throw UnimplementedError(
            'Mean values calculation for axis $axis is not '
            'supported yet');
    }
  }

  Vector _mean(Iterable<Vector> vectors) =>
      Vector.fromList(vectors.map((vector) => vector.mean()).toList(),
          dtype: dtype);

  @override
  Vector deviation([Axis axis = Axis.columns]) {
    return variance(axis).sqrt();
  }

  @override
  Vector variance([Axis axis = Axis.columns]) {
    if (!hasData) {
      return Vector.empty(dtype: dtype);
    }

    final means = mean(axis);

    switch (axis) {
      case Axis.columns:
        return _cache.get(
            matrixVarianceByColumnsKey, () => _variance(rows, means, rowCount));

      case Axis.rows:
        return _cache.get(
            matrixVarianceByRowsKey, () => _variance(columns, means, colCount));

      default:
        throw UnimplementedError('Deviation calculation for axis $axis is not '
            'supported yet');
    }
  }

  Vector _variance(Iterable<Vector> vectors, Vector means, int vectorsNum) =>
      vectors
          .map((vector) => (vector - means) * (vector - means))
          .reduce((summed, vector) => summed + vector)
          .scalarDiv(vectorsNum);

  @override
  Vector toVector() {
    if (colCount == 1) {
      return getColumn(0);
    }

    if (rowCount == 1) {
      return getRow(0);
    }

    throw Exception(
        'Cannot convert $rowCount x $colCount matrix into a vector');
  }

  @override
  String toString() {
    final columnsLimit = 5;
    final rowsLimit = 5;
    final eol = colCount > columnsLimit ? ', ...)' : ')';
    var result = 'Matrix $rowCount x $colCount:\n';
    var i = 1;

    for (final row in this) {
      if (i > rowsLimit) {
        result += '...';
        break;
      }
      result =
          '$result${row.take(columnsLimit).toString().replaceAll(RegExp(r'\)$'), '')}$eol\n';
      i++;
    }

    return result;
  }

  @override
  double max() => _findExtrema((Vector row) => row.max());

  @override
  double min() => _findExtrema((Vector row) => row.min());

  @override
  double norm([MatrixNorm norm = MatrixNorm.frobenius]) {
    switch (norm) {
      case MatrixNorm.frobenius:
        // ignore: deprecated_member_use_from_same_package
        return math.sqrt(reduceRows((sum, row) => sum + row.pow(2)).sum());
      default:
        throw UnsupportedError('Unsupported matrix norm type: $norm');
    }
  }

  @override
  Matrix insertColumns(int targetIndex, List<Vector> columns) {
    final columnsIterator = columns.iterator;
    final indices =
        count(0).take(colCount + columns.length).map((i) => i.toInt());
    final newColumns = indices.map((index) {
      if (index < targetIndex) {
        return getColumn(index);
      }

      if (index < (targetIndex + columns.length)) {
        return (columnsIterator..moveNext()).current;
      }

      return getColumn(index - columns.length);
    }).toList(growable: false);

    return Matrix.fromColumns(newColumns, dtype: dtype);
  }

  @override
  Matrix sort(double Function(Vector vector) selectSortValue,
      [Axis axis = Axis.rows, SortDirection sortDir = SortDirection.asc]) {
    final doSort =
        (Iterable<Vector> source) => _doSort(source, sortDir, selectSortValue);

    switch (axis) {
      case Axis.rows:
        return Matrix.fromRows(doSort(rows), dtype: dtype);

      case Axis.columns:
        return Matrix.fromColumns(doSort(columns), dtype: dtype);

      default:
        throw UnsupportedError('Unsupported axis type $axis');
    }
  }

  List<Vector> _doSort(Iterable<Vector> source, SortDirection sortDir,
      double Function(Vector vector) selector) {
    final dir = sortDir == SortDirection.asc ? 1 : -1;

    return source.toList(growable: false)
      ..sort((row1, row2) => (selector(row1) - selector(row2)) ~/ dir);
  }

  @override
  Matrix fastMap<T>(T Function(T element) mapper) {
    final source =
        List.generate(rowCount, (int i) => getRow(i).fastMap(mapper));

    return Matrix.fromRows(source, dtype: dtype);
  }

  @override
  Matrix pow(num exponent) => _areAllRowsCached
      ? Matrix.fromRows(rows.map((row) => row.pow(exponent)).toList(),
          dtype: dtype)
      : Matrix.fromColumns(
          columns.map((column) => column.pow(exponent)).toList(),
          dtype: dtype);

  @override
  Matrix exp({bool skipCaching = false}) => _cache.get(
      matrixExpKey,
      () => _areAllRowsCached
          ? Matrix.fromRows(
              rows
                  .map((row) => row.exp(
                        skipCaching: skipCaching,
                      ))
                  .toList(),
              dtype: dtype)
          : Matrix.fromColumns(
              columns
                  .map((column) => column.exp(
                        skipCaching: skipCaching,
                      ))
                  .toList(),
              dtype: dtype),
      skipCaching: skipCaching);

  @override
  Matrix log({bool skipCaching = false}) => _cache.get(
      matrixLogKey,
      () => _areAllRowsCached
          ? Matrix.fromRows(
              rows
                  .map((row) => row.log(
                        skipCaching: skipCaching,
                      ))
                  .toList(),
              dtype: dtype)
          : Matrix.fromColumns(
              columns
                  .map((column) => column.log(
                        skipCaching: skipCaching,
                      ))
                  .toList(),
              dtype: dtype),
      skipCaching: skipCaching);

  @override
  Matrix multiply(Matrix other) {
    checkShape(this, other, errorMessage: 'Cannot find Hadamard product');

    return _areAllRowsCached
        ? Matrix.fromRows(
            zip([rows, other.rows])
                .map((pair) => pair.first * pair.last)
                .toList(),
            dtype: dtype)
        : Matrix.fromColumns(
            zip([columns, other.columns])
                .map((pair) => pair.first * pair.last)
                .toList(),
            dtype: dtype);
  }

  @override
  double sum() {
    if (!hasData) {
      return double.nan;
    }

    return _cache.get(
        matrixSumKey,
        () => _areAllRowsCached
            ? rows.fold(0, (result, row) => result + row.sum())
            : columns.fold(0, (result, column) => result + column.sum()));
  }

  @override
  double prod() {
    if (!hasData) {
      return double.nan;
    }

    return _cache.get(
        matrixProdKey,
        () => _areAllRowsCached
            ? rows.fold(0, (result, row) => result * row.prod())
            : columns.fold(0, (result, column) => result * column.prod()));
  }

  @override
  Iterable<Eigen> eigen(
      {EigenMethod method = EigenMethod.powerIteration,
      Vector? initial,
      int iterationCount = 10,
      int? seed}) {
    var eigenVector =
        (initial ?? Vector.randomFilled(colCount, dtype: dtype, seed: seed))
            .normalize();

    switch (method) {
      case EigenMethod.powerIteration:
        return _powerIteration(eigenVector, iterationCount);

      default:
        throw UnimplementedError('Eigen method $method isn\'t implemented yet');
    }
  }

  @override
  Iterable<Matrix> decompose(
      [Decomposition decompositionType = Decomposition.LU]) {
    switch (decompositionType) {
      case Decomposition.cholesky:
        return _choleskyDecomposition();

      case Decomposition.LU:
        return _luDecomposition();

      default:
        throw UnimplementedError(
            'Unimplemented decomposition type $decompositionType');
    }
  }

  @override
  Matrix inverse([Inverse inverseType = Inverse.LU]) {
    switch (inverseType) {
      case Inverse.cholesky:
        return _choleskyInverse();

      case Inverse.LU:
        return _luInverse();

      case Inverse.forwardSubstitution:
        return _forwardSubstitutionInverse();

      case Inverse.backwardSubstitution:
        return _backwardSubstitutionInverse();

      default:
        throw UnimplementedError('Unimplemented inverse type $inverseType');
    }
  }

  Matrix _choleskyInverse() {
    final matrices = decompose(Decomposition.cholesky);
    final lower = matrices.first;
    final lowerInverted = lower.inverse(Inverse.forwardSubstitution);

    return lowerInverted.transpose() * lowerInverted;
  }

  Matrix _luInverse() {
    final matrices = decompose(Decomposition.LU);
    final lower = matrices.first;
    final upper = matrices.last;

    return upper.inverse(Inverse.backwardSubstitution) *
        lower.inverse(Inverse.forwardSubstitution);
  }

  Matrix _forwardSubstitutionInverse() {
    if (!isSquare) {
      throw ForwardSubstitutionNonSquareMatrixException(rowCount, colCount);
    }

    final X = Float64List(rowCount * rowCount);
    final thisAsList = _flattenedList;

    for (var i = 0; i < rowCount; i++) {
      for (var row = 0; row < rowCount; row++) {
        var sum = 0.0;
        var b = row == i ? 1.0 : 0.0;

        for (var col = 0; col < row; col++) {
          sum += thisAsList[row * rowCount + col] * X[col * rowCount + i];
        }

        X[row * rowCount + i] = (b - sum) / thisAsList[row * rowCount + row];
      }
    }

    return Matrix.fromFlattenedList(X, rowCount, rowCount, dtype: dtype);
  }

  Matrix _backwardSubstitutionInverse() {
    if (!isSquare) {
      throw BackwardSubstitutionNonSquareMatrixException(rowCount, colCount);
    }

    final X = Float64List(rowCount * rowCount);
    final thisAsList = _flattenedList;

    for (var i = rowCount - 1; i >= 0; i--) {
      for (var row = rowCount - 1; row >= 0; row--) {
        var sum = 0.0;
        var b = row == i ? 1.0 : 0.0;

        for (var col = rowCount - 1; col > row; col--) {
          sum += thisAsList[row * rowCount + col] * X[col * rowCount + i];
        }

        X[row * rowCount + i] = (b - sum) / thisAsList[row * rowCount + row];
      }
    }

    return Matrix.fromFlattenedList(X, rowCount, rowCount, dtype: dtype);
  }

  Iterable<Matrix> _choleskyDecomposition() {
    if (!isSquare) {
      throw CholeskyNonSquareMatrixException(rowCount, colCount);
    }

    final L = Float64List(rowCount * rowCount);
    final U = Float64List(rowCount * rowCount);
    final thisAsList = _flattenedList;

    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j <= i; j++) {
        var sum = 0.0;

        for (var k = 0; k < j; k++) {
          sum += (L[i * rowCount + k] * L[j * rowCount + k]);
        }

        if (j == i) {
          final idx = j * rowCount + j;
          final value = math.sqrt(thisAsList[idx] - sum);

          L[idx] = value;
          U[idx] = value;

          if (value.isNaN) {
            throw CholeskyInappropriateMatrixException();
          }
        } else {
          final idx = i * colCount + j;
          final value = (thisAsList[idx] - sum) / L[j * rowCount + j];

          L[idx] = value;
          U[j * rowCount + i] = value;
        }
      }
    }

    return [
      Matrix.fromFlattenedList(L, rowCount, rowCount, dtype: dtype),
      Matrix.fromFlattenedList(U, rowCount, rowCount, dtype: dtype)
    ];
  }

  Iterable<Matrix> _luDecomposition() {
    if (!isSquare) {
      throw LUDecompositionNonSquareMatrixException(rowCount, colCount);
    }

    final L = Float64List(rowCount * rowCount);
    final U = Float64List(rowCount * rowCount);
    final thisAsList = _flattenedList;

    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < rowCount; j++) {
        final idx = i * rowCount + j;

        if (i == j) {
          L[idx] = 1;
        }

        var sum = 0.0;

        for (var k = 0; k < i; k++) {
          sum += L[i * rowCount + k] * U[k * rowCount + j];
        }

        if (i <= j) {
          U[idx] = thisAsList[idx] - sum;
        } else {
          L[idx] = (thisAsList[idx] - sum) / U[j * rowCount + j];
        }
      }
    }

    return [
      Matrix.fromFlattenedList(L, rowCount, rowCount, dtype: dtype),
      Matrix.fromFlattenedList(U, rowCount, rowCount, dtype: dtype)
    ];
  }

  @override
  Map<String, dynamic> toJson() => matrixToJson(this)!;

  Iterable<Eigen> _powerIteration(Vector initial, int iterationCount) {
    var eigenVector = initial;

    for (var i = 1; i < iterationCount; i++) {
      final candidate = this * eigenVector;

      eigenVector = (candidate / candidate.norm()).toVector();
    }

    return [Eigen(_rayleighQuotient(eigenVector), eigenVector)];
  }

  num _rayleighQuotient(Vector eigenVector) {
    return (Matrix.fromRows([eigenVector], dtype: dtype) * this)
            .toVector()
            .dot(eigenVector) /
        eigenVector.dot(eigenVector);
  }

  double _findExtrema(double Function(Vector vector) callback) {
    final rowIterator = rows.iterator;
    final minValues = List<double>.generate(
        rowCount, (i) => callback((rowIterator..moveNext()).current));

    return callback(Vector.fromList(minValues, dtype: dtype));
  }

  Vector _reduce(Vector Function(Vector combine, Vector vector) combiner,
      int length, Vector Function(int index) getVector,
      {Vector? initValue}) {
    var reduced = initValue ?? getVector(0);
    final startIndex = initValue != null ? 0 : 1;

    for (var i = startIndex; i < length; i++) {
      reduced = combiner(reduced, getVector(i));
    }

    return reduced;
  }

  Matrix _matrixVectorMul(Vector vector) {
    if (vector.length != colCount) {
      throw Exception(
          'Matrix column count and vector length mismatch, matrix column count: $columnsNum, vector length: ${vector.length}');
    }

    final source = Float64List(rowCount);

    for (var i = 0; i < source.length; i++) {
      source[i] = vector.dot(getRow(i));
    }

    final vectorColumn = Vector.fromList(source, dtype: dtype);

    return Matrix.fromColumns([vectorColumn], dtype: dtype);
  }

  Matrix _matrixMul(Matrix matrix) {
    checkColumnsAndRowsNumber(this, matrix);

    final source = List.generate(rowCount, (i) => getRow(i) * matrix);

    return Matrix.fromRows(source, dtype: dtype);
  }

  Matrix _matrixByVectorDiv(Vector vector) {
    if (isSquare) {
      throw SquareMatrixDivisionByVectorException(rowCount, colCount);
    }

    if (vector.length == rowCount) {
      return mapColumns((column) => column / vector);
    }

    if (vector.length == colCount) {
      return mapRows((row) => row / vector);
    }

    throw MatrixDivisionByVectorException(rowCount, colCount, vector.length);
  }

  Matrix _matrixByMatrixDiv(Matrix other) {
    checkShape(this, other,
        errorMessage: 'Cannot perform matrix by matrix '
            'division');

    final source = Float64List(rowCount * colCount);

    for (var i = 0; i < source.length; i++) {
      source[i] = asFlattenedList[i] / other.asFlattenedList[i];
    }

    return Matrix.fromFlattenedList(source, rowCount, colCount, dtype: dtype);
  }

  Matrix _matrixAdd(Matrix other) {
    checkShape(this, other, errorMessage: 'Cannot perform matrix addition');

    if (other is Float64Matrix) {
      final result = _createEmptySimdList();
      final thisAsSimdList = _getFlattenedSimdList();
      final otherAsSimdList = other._getFlattenedSimdList();

      for (var i = 0; i < thisAsSimdList.length; i++) {
        result[i] = thisAsSimdList[i] + otherAsSimdList[i];
      }

      if (lastSimd != null) {
        result[result.length - 1] = lastSimd! + other.lastSimd!;
      }

      return Matrix.fromFlattenedList(
          result.buffer.asFloat64List(), rowCount, colCount,
          dtype: dtype);
    }

    final source = Float64List(rowCount * colCount);

    for (var i = 0; i < source.length; i++) {
      source[i] = asFlattenedList[i] + other.asFlattenedList[i];
    }

    return Matrix.fromFlattenedList(source, rowCount, colCount, dtype: dtype);
  }

  Matrix _matrixSub(Matrix other) {
    checkShape(this, other, errorMessage: 'Cannot perform matrix subtraction');

    if (other is Float64Matrix) {
      final result = _createEmptySimdList();
      final thisAsSimdList = _getFlattenedSimdList();
      final otherAsSimdList = other._getFlattenedSimdList();

      for (var i = 0; i < thisAsSimdList.length; i++) {
        result[i] = thisAsSimdList[i] - otherAsSimdList[i];
      }

      if (lastSimd != null) {
        result[result.length - 1] = lastSimd! - other.lastSimd!;
      }

      return Matrix.fromFlattenedList(
          result.buffer.asFloat64List(), rowCount, colCount,
          dtype: dtype);
    }

    final source = Float64List(rowCount * colCount);

    for (var i = 0; i < source.length; i++) {
      source[i] = asFlattenedList[i] - other.asFlattenedList[i];
    }

    return Matrix.fromFlattenedList(source, rowCount, colCount, dtype: dtype);
  }

  Matrix _matrixScalarAdd(double scalar) {
    final result = _createEmptySimdList();
    final thisAsSimdList = _getFlattenedSimdList();
    final scalarAsSimd = Float64x2.splat(scalar);

    for (var i = 0; i < thisAsSimdList.length; i++) {
      result[i] = thisAsSimdList[i] + scalarAsSimd;
    }

    if (lastSimd != null) {
      result[result.length - 1] = lastSimd! + scalarAsSimd;
    }

    return Matrix.fromFlattenedList(
        result.buffer.asFloat64List(), rowCount, colCount,
        dtype: dtype);
  }

  Matrix _matrixScalarSub(double scalar) {
    final result = _createEmptySimdList();
    final thisAsSimdList = _getFlattenedSimdList();
    final scalarAsSimd = Float64x2.splat(scalar);

    for (var i = 0; i < thisAsSimdList.length; i++) {
      result[i] = thisAsSimdList[i] - scalarAsSimd;
    }

    if (lastSimd != null) {
      result[result.length - 1] = lastSimd! - scalarAsSimd;
    }

    return Matrix.fromFlattenedList(
        result.buffer.asFloat64List(), rowCount, colCount,
        dtype: dtype);
  }

  Matrix _matrixScalarMul(double scalar) {
    final result = _createEmptySimdList();
    final thisAsSimdList = _getFlattenedSimdList();
    final scalarAsSimd = Float64x2.splat(scalar);

    for (var i = 0; i < thisAsSimdList.length; i++) {
      result[i] = thisAsSimdList[i] * scalarAsSimd;
    }

    if (lastSimd != null) {
      result[result.length - 1] = lastSimd! * scalarAsSimd;
    }

    return Matrix.fromFlattenedList(
        result.buffer.asFloat64List(), rowCount, colCount,
        dtype: dtype);
  }

  Matrix _matrixByScalarDiv(double scalar) {
    final result = _createEmptySimdList();
    final thisAsSimdList = _getFlattenedSimdList();
    final scalarAsSimd = Float64x2.splat(scalar);

    for (var i = 0; i < thisAsSimdList.length; i++) {
      result[i] = thisAsSimdList[i] / scalarAsSimd;
    }

    if (lastSimd != null) {
      result[result.length - 1] = lastSimd! / scalarAsSimd;
    }

    return Matrix.fromFlattenedList(
        result.buffer.asFloat64List(), rowCount, colCount,
        dtype: dtype);
  }

  Float64x2List _createEmptySimdList() {
    final realLength = rowCount * colCount;
    final residual = realLength % _simdSize;
    final dim = residual == 0
        ? realLength
        : ((realLength + _simdSize - residual) / _simdSize).floor();

    return Float64x2List(dim);
  }

  Float64x2List _getFlattenedSimdList() {
    if (_cachedSimdList == null) {
      final realLength = rowCount * colCount;
      final residual = realLength % _simdSize;

      if (residual != 0) {
        final lastSimdFirstIdx = realLength - residual;
        final x = _flattenedList[lastSimdFirstIdx];
        final y = lastSimdFirstIdx + 1 < realLength
            ? _flattenedList[lastSimdFirstIdx + 1]
            : 0.0;
        final z = lastSimdFirstIdx + 2 < realLength
            ? _flattenedList[lastSimdFirstIdx + 2]
            : 0.0;

        lastSimd = Float64x2(x, y);
      }

      _cachedSimdList = _flattenedList.buffer.asFloat64x2List();
    }

    return _cachedSimdList!;
  }

  Float64x2List? _cachedSimdList;

  Float64x2? lastSimd;
}
