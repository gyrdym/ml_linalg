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
import 'package:ml_linalg/src/matrix/iterator/float32_matrix_iterator.dart';
import 'package:ml_linalg/src/matrix/matrix_cache_keys.dart';
import 'package:ml_linalg/src/matrix/mixin/matrix_shape_validation_mixin.dart';
import 'package:ml_linalg/src/matrix/serialization/matrix_to_json.dart';
import 'package:ml_linalg/vector.dart';
import 'package:quiver/iterables.dart' as quiver;

const _bytesPerElement = Float32List.bytesPerElement;
const _simdSize = Float32x4List.bytesPerElement ~/ Float32List.bytesPerElement;

class Float32Matrix
    with IterableMixin<Iterable<double>>, MatrixShapeValidationMixin
    implements Matrix {
  Float32Matrix.fromList(List<List<double>> source)
      : rowCount = get2dIterableLength(source),
        columnCount = getLengthOfFirstOrZero(source),
        rowIndices = getZeroBasedIndices(get2dIterableLength(source)),
        columnIndices = getZeroBasedIndices(getLengthOfFirstOrZero(source)),
        _rowCache = List<Vector?>.filled(source.length, null),
        _colCache = List<Vector?>.filled(getLengthOfFirstOrZero(source), null),
        _flattenedList =
            Float32List(source.length * getLengthOfFirstOrZero(source)),
        _areAllRowsCached = false {
    for (var i = 0; i < source.length; i++) {
      if (source[i].length != columnCount) {
        throw Exception('Wrong nested list length: ${source[i].length}, '
            'expected length: $columnCount');
      }

      for (var j = 0; j < source[i].length; j++) {
        _flattenedList[i * columnCount + j] = source[i][j];
      }
    }
  }

  Float32Matrix.fromRows(List<Vector> source)
      : rowCount = get2dIterableLength(source),
        columnCount = getLengthOfFirstOrZero(source),
        rowIndices = getZeroBasedIndices(get2dIterableLength(source)),
        columnIndices = getZeroBasedIndices(getLengthOfFirstOrZero(source)),
        _rowCache = [...source],
        _colCache = List<Vector?>.filled(getLengthOfFirstOrZero(source), null),
        _flattenedList =
            Float32List(source.length * getLengthOfFirstOrZero(source)),
        _areAllRowsCached = true {
    for (var i = 0, j = 0; i < source.length; i++, j = 0) {
      final row = source[i];

      if (row.length != columnCount) {
        throw Exception('Vectors of different length are provided, expected '
            'vector length: `$columnCount`, given: ${row.length}');
      }

      for (final value in row) {
        _flattenedList[i * columnCount + j] = value;
        j++;
      }
    }
  }

  Float32Matrix.fromColumns(List<Vector> source)
      : rowCount = getLengthOfFirstOrZero(source),
        columnCount = get2dIterableLength(source),
        rowIndices = getZeroBasedIndices(getLengthOfFirstOrZero(source)),
        columnIndices = getZeroBasedIndices(get2dIterableLength(source)),
        _rowCache = List<Vector?>.filled(getLengthOfFirstOrZero(source), null),
        _colCache = [...source],
        _flattenedList =
            Float32List(source.length * getLengthOfFirstOrZero(source)),
        _areAllRowsCached = false {
    for (var i = 0, j = 0; i < source.length; i++, j = 0) {
      final column = source[i];

      if (column.length != rowCount) {
        throw Exception('Vectors of different length are provided, expected '
            'vector length: `$rowCount`, given: ${column.length}');
      }

      for (final value in column) {
        _flattenedList[j * columnCount + i] = value;
        j++;
      }
    }
  }

  Float32Matrix.fromFlattenedList(
      List<double> source, int rowCount, int colCount)
      : rowCount = rowCount,
        columnCount = colCount,
        rowIndices = getZeroBasedIndices(rowCount),
        columnIndices = getZeroBasedIndices(colCount),
        _rowCache = List<Vector?>.filled(rowCount, null),
        _colCache = List<Vector?>.filled(colCount, null),
        _flattenedList =
            source is Float32List ? source : Float32List.fromList(source),
        _areAllRowsCached = false {
    if (source.length < rowCount * colCount) {
      throw Exception('Invalid matrix dimension has been provided - '
          '$rowCount x $colCount, but given a collection of length '
          '${source.length}');
    }
  }

  Float32Matrix.fromByteData(ByteData source, int rowCount, int colCount)
      : rowCount = rowCount,
        columnCount = colCount,
        rowIndices = getZeroBasedIndices(rowCount),
        columnIndices = getZeroBasedIndices(colCount),
        _rowCache = List<Vector?>.filled(rowCount, null),
        _colCache = List<Vector?>.filled(colCount, null),
        _flattenedList = source.buffer.asFloat32List(),
        _areAllRowsCached = false {
    if (source.lengthInBytes != rowCount * colCount * _bytesPerElement) {
      throw Exception('Invalid matrix dimension has been provided - '
          '$rowCount x $columnCount (${rowCount * columnCount} elements), but byte data of '
          '${source.lengthInBytes / _bytesPerElement} elements has been given');
    }
  }

  Float32Matrix.diagonal(List<double> source)
      : rowCount = source.length,
        columnCount = source.length,
        rowIndices = getZeroBasedIndices(source.length),
        columnIndices = getZeroBasedIndices(source.length),
        _rowCache = List<Vector?>.filled(source.length, null),
        _colCache = List<Vector?>.filled(source.length, null),
        _flattenedList = Float32List(source.length * source.length),
        _areAllRowsCached = false {
    for (var i = 0; i < rowCount; i++) {
      _flattenedList[i * columnCount + i] = source[i];
    }
  }

  Float32Matrix.scalar(double scalar, int size)
      : rowCount = size,
        columnCount = size,
        rowIndices = getZeroBasedIndices(size),
        columnIndices = getZeroBasedIndices(size),
        _rowCache = List<Vector?>.filled(size, null),
        _colCache = List<Vector?>.filled(size, null),
        _flattenedList = Float32List(size * size),
        _areAllRowsCached = false {
    for (var i = 0; i < size; i++) {
      _flattenedList[i * columnCount + i] = scalar;
    }
  }

  Float32Matrix.random(DType dtype, int rowCount, int colCount,
      {num min = -1000, num max = 1000, int? seed})
      : rowCount = rowCount,
        columnCount = colCount,
        rowIndices = getZeroBasedIndices(rowCount),
        columnIndices = getZeroBasedIndices(colCount),
        _rowCache = List<Vector?>.filled(rowCount, null),
        _colCache = List<Vector?>.filled(colCount, null),
        _flattenedList = Float32List(rowCount * colCount),
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
  final DType dtype = DType.float32;

  @override
  final int rowCount;

  @override
  final int columnCount;

  @override
  final Iterable<int> rowIndices;

  @override
  final Iterable<int> columnIndices;

  final bool _areAllRowsCached;
  final List<Vector?> _rowCache;
  final List<Vector?> _colCache;
  final Float32List _flattenedList;
  final _cache = CacheManagerImpl(matrixCacheKeys);

  Float32x4List? _cachedSimdList;
  Float32x4? _lastSimd;

  @override
  Iterator<Iterable<double>> get iterator =>
      Float32MatrixIterator(_flattenedList, rowCount, columnCount);

  @override
  bool get hasData => rowCount > 0 && columnCount > 0;

  @override
  int get rowsNum => rowCount;

  @override
  int get columnsNum => columnCount;

  @override
  bool get isSquare => columnCount == rowCount;

  @override
  Iterable<Vector> get rows => rowIndices.map(getRow);

  @override
  Iterable<Vector> get columns => columnIndices.map(getColumn);

  @override
  List<double> get asFlattenedList => _flattenedList;

  int get elementCount => rowCount * columnCount;

  @override
  Matrix operator +(Object value) {
    if (value is Matrix) {
      return _matrixMatrixAdd(value);
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
      return _matrixMatrixSub(value);
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
      return _matrixByVectorMult(value);
    }

    if (value is Matrix) {
      return _matrixByMatrixMult(value);
    }

    if (value is num) {
      return _matrixByScalarMult(value.toDouble());
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
    final transposed = Float32List(elementCount);

    for (var i = 0; i < transposed.length; i++) {
      final rowIdx = i ~/ columnCount;
      final colIdx = i - columnCount * rowIdx;

      transposed[colIdx * rowCount + rowIdx] = _flattenedList[i];
    }

    return Matrix.fromFlattenedList(transposed, columnCount, rowCount,
        dtype: dtype);
  }

  @override
  Vector getRow(int index) {
    if (_rowCache[index] == null) {
      final indexFrom = index * columnCount;

      if (indexFrom >= rowCount * columnCount) {
        throw RangeError.range(indexFrom, 0, rowCount * columnCount);
      }

      final values = _flattenedList.sublist(indexFrom, indexFrom + columnCount);

      _rowCache[index] = Vector.fromList(values, dtype: dtype);
    }

    return _rowCache[index]!;
  }

  @override
  Vector getColumn(int index) {
    if (_colCache[index] == null) {
      final column = Float32List(rowCount);

      for (var i = 0; i < rowCount; i++) {
        column[i] = _flattenedList[i * columnCount + index];
      }

      _colCache[index] = Vector.fromList(column, dtype: dtype);
    }

    return _colCache[index]!;
  }

  @override
  Matrix sample({
    Iterable<int> rowIndices = const [],
    Iterable<int> columnIndices = const [],
  }) {
    if (rowIndices.isNotEmpty) {
      final maxRowIdx = quiver.max(rowIndices);

      if (maxRowIdx != null && maxRowIdx >= rowCount) {
        throw RangeError.range(maxRowIdx, 0, rowCount - 1);
      }
    }

    if (columnIndices.isNotEmpty) {
      var maxColIdx = 0;
      var minColIdx = 0;

      columnIndices.forEach((idx) {
        maxColIdx = idx > maxColIdx ? idx : maxColIdx;
        minColIdx = idx < minColIdx ? idx : minColIdx;
      });

      if (maxColIdx >= columnCount) {
        throw RangeError.range(maxColIdx, 0, columnCount - 1);
      }

      if (minColIdx < 0) {
        throw RangeError.range(minColIdx, 0, columnCount - 1);
      }
    }

    final rowIndicesList = (rowIndices.isEmpty ? this.rowIndices : rowIndices)
        .toList(growable: false);
    final colIndicesAsList =
        (columnIndices.isEmpty ? this.columnIndices : columnIndices)
            .toList(growable: false);
    final sampledRowCount = rowIndicesList.length;
    final sampledColCount = colIndicesAsList.length;
    final sampled = Float32List(sampledRowCount * sampledColCount);

    for (var i = 0; i < sampled.length; i++) {
      final rowIdx = i ~/ sampledColCount;
      final colIdx = i - sampledColCount * rowIdx;
      final thisRowIdx = rowIndicesList[rowIdx];
      final thisColIdx = colIndicesAsList[colIdx];

      sampled[i] = _flattenedList[thisRowIdx * columnCount + thisColIdx];
    }

    return Matrix.fromFlattenedList(sampled, sampledRowCount, sampledColCount,
        dtype: dtype);
  }

  @override
  Vector reduceColumns(
    Vector Function(Vector combine, Vector vector) combiner, {
    Vector? initValue,
  }) =>
      _reduce(
        combiner,
        columnCount,
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
          List.generate(columnCount, (int i) => mapper(getColumn(i))),
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
        return _cache.get(matrixVarianceByRowsKey,
            () => _variance(columns, means, columnCount));

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
    if (columnCount == 1) {
      return getColumn(0);
    }

    if (rowCount == 1) {
      return getRow(0);
    }

    throw Exception(
        'Cannot convert $rowCount x $columnCount matrix into a vector');
  }

  @override
  String toString() {
    final columnsLimit = 5;
    final rowsLimit = 5;
    final eol = columnCount > columnsLimit ? ', ...)' : ')';
    var result = 'Matrix $rowCount x $columnCount:\n';
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
    final indices = quiver
        .count(0)
        .take(columnCount + columns.length)
        .map((i) => i.toInt());
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
    validateMatricesShapeEquality(this, other,
        errorMessage: 'Cannot find Hadamard product');

    return _areAllRowsCached
        ? Matrix.fromRows(
            quiver
                .zip([rows, other.rows])
                .map((pair) => pair.first * pair.last)
                .toList(),
            dtype: dtype)
        : Matrix.fromColumns(
            quiver
                .zip([columns, other.columns])
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
        (initial ?? Vector.randomFilled(columnCount, dtype: dtype, seed: seed))
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
      throw ForwardSubstitutionNonSquareMatrixException(rowCount, columnCount);
    }

    final X = Float32List(rowCount * rowCount);
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
      throw BackwardSubstitutionNonSquareMatrixException(rowCount, columnCount);
    }

    final X = Float32List(rowCount * rowCount);
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
      throw CholeskyNonSquareMatrixException(rowCount, columnCount);
    }

    final L = Float32List(rowCount * rowCount);
    final U = Float32List(rowCount * rowCount);
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
          final idx = i * columnCount + j;
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
      throw LUDecompositionNonSquareMatrixException(rowCount, columnCount);
    }

    final L = Float32List(rowCount * rowCount);
    final U = Float32List(rowCount * rowCount);
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

  Matrix _matrixByVectorMult(Vector vector) {
    if (vector.length != columnCount) {
      throw Exception(
          'Matrix column count and vector length mismatch, matrix column count: $columnsNum, vector length: ${vector.length}');
    }

    final source = Float32List(rowCount);

    for (var i = 0; i < source.length; i++) {
      source[i] = vector.dot(getRow(i));
    }

    final vectorColumn = Vector.fromList(source, dtype: dtype);

    return Matrix.fromColumns([vectorColumn], dtype: dtype);
  }

  Matrix _matrixByMatrixMult(Matrix matrix) {
    validateMatricesMultEligibility(this, matrix);

    final source = List.generate(rowCount, (i) => getRow(i) * matrix);

    return Matrix.fromRows(source, dtype: dtype);
  }

  Matrix _matrixByVectorDiv(Vector vector) {
    if (isSquare) {
      throw SquareMatrixDivisionByVectorException(rowCount, columnCount);
    }

    if (vector.length == rowCount) {
      return mapColumns((column) => column / vector);
    }

    if (vector.length == columnCount) {
      return mapRows((row) => row / vector);
    }

    throw MatrixDivisionByVectorException(rowCount, columnCount, vector.length);
  }

  Matrix _matrixByMatrixDiv(Matrix other) {
    validateMatricesShapeEquality(this, other,
        errorMessage: 'Cannot perform matrix by matrix '
            'division');

    if (other is Float32Matrix) {
      final result = _createEmptySimdList();
      final thisAsSimdList = _getFlattenedSimdList();
      final otherAsSimdList = other._getFlattenedSimdList();

      for (var i = 0; i < thisAsSimdList.length; i++) {
        result[i] = thisAsSimdList[i] / otherAsSimdList[i];
      }

      if (_lastSimd != null) {
        result[result.length - 1] = _lastSimd! / other._lastSimd!;
      }

      return Matrix.fromFlattenedList(
          result.buffer.asFloat32List(), rowCount, columnCount,
          dtype: dtype);
    }

    final source = Float32List(rowCount * columnCount);

    for (var i = 0; i < source.length; i++) {
      source[i] = asFlattenedList[i] / other.asFlattenedList[i];
    }

    return Matrix.fromFlattenedList(source, rowCount, columnCount,
        dtype: dtype);
  }

  Matrix _matrixMatrixAdd(Matrix other) {
    validateMatricesShapeEquality(this, other,
        errorMessage: 'Cannot perform matrix addition');

    if (other is Float32Matrix) {
      final result = _createEmptySimdList();
      final thisAsSimdList = _getFlattenedSimdList();
      final otherAsSimdList = other._getFlattenedSimdList();

      for (var i = 0; i < thisAsSimdList.length; i++) {
        result[i] = thisAsSimdList[i] + otherAsSimdList[i];
      }

      if (_lastSimd != null) {
        result[result.length - 1] = _lastSimd! + other._lastSimd!;
      }

      return Matrix.fromFlattenedList(
          result.buffer.asFloat32List(), rowCount, columnCount,
          dtype: dtype);
    }

    final source = Float32List(rowCount * columnCount);

    for (var i = 0; i < source.length; i++) {
      source[i] = asFlattenedList[i] + other.asFlattenedList[i];
    }

    return Matrix.fromFlattenedList(source, rowCount, columnCount,
        dtype: dtype);
  }

  Matrix _matrixMatrixSub(Matrix other) {
    validateMatricesShapeEquality(this, other,
        errorMessage: 'Cannot perform matrix subtraction');

    if (other is Float32Matrix) {
      final result = _createEmptySimdList();
      final thisAsSimdList = _getFlattenedSimdList();
      final otherAsSimdList = other._getFlattenedSimdList();

      for (var i = 0; i < thisAsSimdList.length; i++) {
        result[i] = thisAsSimdList[i] - otherAsSimdList[i];
      }

      if (_lastSimd != null) {
        result[result.length - 1] = _lastSimd! - other._lastSimd!;
      }

      return Matrix.fromFlattenedList(
          result.buffer.asFloat32List(), rowCount, columnCount,
          dtype: dtype);
    }

    final source = Float32List(rowCount * columnCount);

    for (var i = 0; i < source.length; i++) {
      source[i] = asFlattenedList[i] - other.asFlattenedList[i];
    }

    return Matrix.fromFlattenedList(source, rowCount, columnCount,
        dtype: dtype);
  }

  Matrix _matrixScalarAdd(double scalar) {
    final result = _createEmptySimdList();
    final thisAsSimdList = _getFlattenedSimdList();
    final scalarAsSimd = Float32x4.splat(scalar);

    for (var i = 0; i < thisAsSimdList.length; i++) {
      result[i] = thisAsSimdList[i] + scalarAsSimd;
    }

    if (_lastSimd != null) {
      result[result.length - 1] = _lastSimd! + scalarAsSimd;
    }

    return Matrix.fromFlattenedList(
        result.buffer.asFloat32List(), rowCount, columnCount,
        dtype: dtype);
  }

  Matrix _matrixScalarSub(double scalar) {
    final result = _createEmptySimdList();
    final thisAsSimdList = _getFlattenedSimdList();
    final scalarAsSimd = Float32x4.splat(scalar);

    for (var i = 0; i < thisAsSimdList.length; i++) {
      result[i] = thisAsSimdList[i] - scalarAsSimd;
    }

    if (_lastSimd != null) {
      result[result.length - 1] = _lastSimd! - scalarAsSimd;
    }

    return Matrix.fromFlattenedList(
        result.buffer.asFloat32List(), rowCount, columnCount,
        dtype: dtype);
  }

  Matrix _matrixByScalarMult(double scalar) {
    final result = _createEmptySimdList();
    final thisAsSimdList = _getFlattenedSimdList();
    final scalarAsSimd = Float32x4.splat(scalar);

    for (var i = 0; i < thisAsSimdList.length; i++) {
      result[i] = thisAsSimdList[i] * scalarAsSimd;
    }

    if (_lastSimd != null) {
      result[result.length - 1] = _lastSimd! * scalarAsSimd;
    }

    return Matrix.fromFlattenedList(
        result.buffer.asFloat32List(), rowCount, columnCount,
        dtype: dtype);
  }

  Matrix _matrixByScalarDiv(double scalar) {
    final result = _createEmptySimdList();
    final thisAsSimdList = _getFlattenedSimdList();
    final scalarAsSimd = Float32x4.splat(scalar);

    for (var i = 0; i < thisAsSimdList.length; i++) {
      result[i] = thisAsSimdList[i] / scalarAsSimd;
    }

    if (_lastSimd != null) {
      result[result.length - 1] = _lastSimd! / scalarAsSimd;
    }

    return Matrix.fromFlattenedList(
        result.buffer.asFloat32List(), rowCount, columnCount,
        dtype: dtype);
  }

  Float32x4List _createEmptySimdList() {
    final realLength = rowCount * columnCount;
    final residual = realLength % _simdSize;
    final dim = residual == 0
        ? realLength
        : ((realLength + _simdSize - residual) / _simdSize).floor();

    return Float32x4List(dim);
  }

  Float32x4List _getFlattenedSimdList() {
    if (_cachedSimdList == null) {
      final realLength = rowCount * columnCount;
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

        _lastSimd = Float32x4(x, y, z, 0.0);
      }

      _cachedSimdList =
          _flattenedList.buffer.asFloat32x4List(0, realLength ~/ _simdSize);
    }

    return _cachedSimdList!;
  }
}
