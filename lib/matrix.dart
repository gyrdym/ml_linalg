import 'dart:typed_data';

import 'package:ml_linalg/axis.dart';
import 'package:ml_linalg/decomposition.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/inverse.dart';
import 'package:ml_linalg/matrix_norm.dart';
import 'package:ml_linalg/sort_direction.dart';
import 'package:ml_linalg/src/matrix/helper/create_matrix.dart';
import 'package:ml_linalg/src/matrix/serialization/from_matrix_json.dart';
import 'package:ml_linalg/vector.dart';

/// An algebraic matrix with extended functionality, adapted for data science
/// applications
abstract class Matrix implements Iterable<Iterable<double>> {
  /// Creates a matrix from a two dimensional list, every nested list is a
  /// source for a matrix row.
  ///
  /// A simple usage example:
  ///
  /// ````dart
  /// import 'package:ml_linalg/matrix.dart';
  ///
  /// void main() {
  ///   final matrix = Matrix.fromList([
  ///     [1, 2, 3, 4, 5],
  ///     [6, 7, 8, 9, 0],
  ///   ]);
  ///
  ///   print(matrix);
  /// }
  /// ````
  ///
  /// The output:
  ///
  /// ```
  /// Matrix 2 x 5:
  /// (1.0, 2.0, 3.0, 4.0, 5.0)
  /// (6.0, 7.0, 8.0, 9.0, 0.0)
  /// ```
  factory Matrix.fromList(
    List<List<double>> source, {
    DType dtype = DType.float32,
  }) =>
      createMatrixFactory().fromList(dtype, source);

  /// Creates a matrix with predefined row vectors
  ///
  /// A simple usage example:
  ///
  /// ````dart
  /// import 'package:ml_linalg/matrix.dart';
  /// import 'package:ml_linalg/vector.dart';
  ///
  /// void main() {
  ///   final matrix = Matrix.fromRows([
  ///     Vector.fromList([1, 2, 3, 4, 5]),
  ///     Vector.fromList([6, 7, 8, 9, 0]),
  ///   ]);
  ///
  ///   print(matrix);
  /// }
  /// ````
  ///
  /// The output:
  ///
  /// ```
  /// Matrix 2 x 5:
  /// (1.0, 2.0, 3.0, 4.0, 5.0)
  /// (6.0, 7.0, 8.0, 9.0, 0.0)
  /// ```
  factory Matrix.fromRows(List<Vector> source, {DType dtype = DType.float32}) =>
      createMatrixFactory().fromRows(dtype, source);

  /// Creates a matrix with predefined column vectors
  ///
  /// A simple usage example:
  ///
  /// ````dart
  /// import 'package:ml_linalg/matrix.dart';
  /// import 'package:ml_linalg/vector.dart';
  ///
  /// void main() {
  ///   final matrix = Matrix.fromColumns([
  ///     Vector.fromList([1, 2, 3, 4, 5]),
  ///     Vector.fromList([6, 7, 8, 9, 0]),
  ///   ]);
  ///
  ///   print(matrix);
  /// }
  /// ````
  ///
  /// The output:
  ///
  /// ```
  /// Matrix 5 x 2:
  /// (1.0, 6.0)
  /// (2.0, 7.0)
  /// (3.0, 8.0)
  /// (4.0, 9.0)
  /// (5.0, 0.0)
  /// ```
  factory Matrix.fromColumns(
    List<Vector> source, {
    DType dtype = DType.float32,
  }) =>
      createMatrixFactory().fromColumns(dtype, source);

  /// Creates a matrix of shape 0 x 0 (no rows, no columns)
  ///
  /// A simple usage example:
  ///
  /// ````dart
  /// import 'package:ml_linalg/matrix.dart';
  ///
  /// void main() {
  ///   final matrix = Matrix.empty();
  ///
  ///   print(matrix);
  /// }
  /// ````
  ///
  /// The output:
  ///
  /// ```
  /// Matrix 0 x 0
  /// ```
  factory Matrix.empty({DType dtype = DType.float32}) =>
      createMatrixFactory().empty(dtype);

  /// Creates a matrix from flattened list of length equal to
  /// [rowsNum] * [columnsNum]
  ///
  /// A simple usage example:
  ///
  /// ````dart
  /// import 'package:ml_linalg/matrix.dart';
  ///
  /// void main() {
  ///   final source = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
  ///
  ///   final matrix = Matrix.fromFlattenedList(source, 2, 5);
  ///
  ///   print(matrix);
  /// }
  /// ````
  ///
  /// The output:
  ///
  /// ```
  /// Matrix 2 x 5:
  /// (1.0, 2.0, 3.0, 4.0, 5.0)
  /// (6.0, 7.0, 8.0, 9.0, 0.0)
  /// ```
  factory Matrix.fromFlattenedList(
    List<double> source,
    int rowsNum,
    int columnsNum, {
    DType dtype = DType.float32,
  }) =>
      createMatrixFactory().fromFlattenedList(
        dtype,
        source,
        rowsNum,
        columnsNum,
      );

  /// Creates a matrix, where elements from [source] are the elements for the
  /// matrix main diagonal, the rest of the elements are zero
  ///
  /// ````dart
  /// import 'package:ml_linalg/matrix.dart';
  ///
  /// void main() {
  ///   final matrix = Matrix.diagonal([1, 2, 3, 4, 5]);
  ///
  ///   print(matrix);
  /// }
  /// ````
  ///
  /// The output:
  ///
  /// ```
  /// Matrix 5 x 5:
  /// (1.0, 0.0, 0.0, 0.0, 0.0)
  /// (0.0, 2.0, 0.0, 0.0, 0.0)
  /// (0.0, 0.0, 3.0, 0.0, 0.0)
  /// (0.0, 0.0, 0.0, 4.0, 0.0)
  /// (0.0, 0.0, 0.0, 0.0, 5.0)
  /// ```
  factory Matrix.diagonal(
    List<double> source, {
    DType dtype = DType.float32,
  }) =>
      createMatrixFactory().diagonal(dtype, source);

  /// Creates a matrix of [size] * [size] dimension, where all the main
  /// diagonal elements are equal to [scalar], the rest of the elements are 0
  ///
  /// ````dart
  /// import 'package:ml_linalg/matrix.dart';
  ///
  /// void main() {
  ///   final matrix = Matrix.scalar(3, 5);
  ///
  ///   print(matrix);
  /// }
  /// ````
  ///
  /// The output:
  ///
  /// ```
  /// Matrix 5 x 5:
  /// (3.0, 0.0, 0.0, 0.0, 0.0)
  /// (0.0, 3.0, 0.0, 0.0, 0.0)
  /// (0.0, 0.0, 3.0, 0.0, 0.0)
  /// (0.0, 0.0, 0.0, 3.0, 0.0)
  /// (0.0, 0.0, 0.0, 0.0, 3.0)
  /// ```
  factory Matrix.scalar(
    double scalar,
    int size, {
    DType dtype = DType.float32,
  }) =>
      createMatrixFactory().scalar(
        dtype,
        scalar,
        size,
      );

  /// Creates a matrix of [size] * [size] dimension, where all the main
  /// diagonal elements are equal to 1, the rest of the elements are 0
  ///
  /// ````dart
  /// import 'package:ml_linalg/matrix.dart';
  ///
  /// void main() {
  ///   final matrix = Matrix.identity(5);
  ///
  ///   print(matrix);
  /// }
  /// ````
  ///
  /// The output:
  ///
  /// ```
  /// Matrix 5 x 5:
  /// (1.0, 0.0, 0.0, 0.0, 0.0)
  /// (0.0, 1.0, 0.0, 0.0, 0.0)
  /// (0.0, 0.0, 1.0, 0.0, 0.0)
  /// (0.0, 0.0, 0.0, 1.0, 0.0)
  /// (0.0, 0.0, 0.0, 0.0, 1.0)
  /// ```
  factory Matrix.identity(
    int size, {
    DType dtype = DType.float32,
  }) =>
      createMatrixFactory().identity(dtype, size);

  /// Creates a matrix, consisting of just one row (aka `Row matrix`)
  ///
  /// ````dart
  /// import 'package:ml_linalg/matrix.dart';
  ///
  /// void main() {
  ///   final matrix = Matrix.row([1, 2, 3, 4, 5]);
  ///
  ///   print(matrix);
  /// }
  /// ````
  ///
  /// The output:
  ///
  /// ```
  /// Matrix 1 x 5:
  /// (1.0, 2.0, 3.0, 4.0, 5.0)
  /// ```
  factory Matrix.row(
    List<double> source, {
    DType dtype = DType.float32,
  }) =>
      createMatrixFactory().row(dtype, source);

  /// Returns randomly filled matrix of [rowsNum]x[columnsCount] dimension
  factory Matrix.random(int rowsNum, int columnsCount,
          {DType dtype = DType.float32,
          num min = -1000,
          num max = 1000,
          int? seed}) =>
      createMatrixFactory()
          .random(dtype, rowsNum, columnsCount, max: max, min: min, seed: seed);

  /// Returns randomly filled symmetric and positive definite matrix of
  /// [size]x[size] dimension
  ///
  /// Keep in mind that [min] and [max] are constraints for a random
  /// intermediate matrix which is used to build the result matrix
  factory Matrix.randomSPD(int size,
          {DType dtype = DType.float32,
          num min = -1000,
          num max = 1000,
          int? seed}) =>
      createMatrixFactory()
          .randomSPD(dtype, size, max: max, min: min, seed: seed);

  /// Returns a restored matrix from a serializable map
  factory Matrix.fromJson(Map<String, dynamic> json) => fromMatrixJson(json)!;

  /// Creates a matrix, consisting of just one column (aka `Column matrix`)
  ///
  /// ````dart
  /// import 'package:ml_linalg/matrix.dart';
  ///
  /// void main() {
  ///   final matrix = Matrix.column([1, 2, 3, 4, 5]);
  ///
  ///   print(matrix);
  /// }
  /// ````
  ///
  /// The output:
  ///
  /// ```
  /// Matrix 5 x 1:
  /// (1.0)
  /// (2.0)
  /// (3.0)
  /// (4.0)
  /// (5.0)
  /// ```
  factory Matrix.column(List<double> source, {DType dtype = DType.float32}) =>
      createMatrixFactory().column(dtype, source);

  /// A data type of [Matrix] elements
  DType get dtype;

  /// Returns a lazy iterable of row vectors of the matrix
  Iterable<Vector> get rows;

  /// Returns a lazy iterable of column vectors of the matrix
  Iterable<Vector> get columns;

  /// Returns a lazy iterable of row indices
  Iterable<int> get rowIndices;

  /// Return a lazy iterable of column indices
  Iterable<int> get columnIndices;

  /// Returns a number of matrix row
  int get rowsNum;

  /// Returns a number of matrix columns
  int get columnsNum;

  /// Returns `true` if the [Matrix] is not empty. Use it instead of `isEmpty`
  /// getter from [Iterable] interface, since the latter may return falsy true
  bool get hasData;

  /// Returns `true` if the [Matrix]'s [columnsNum] and [rowsNum] are equal
  bool get isSquare;

  /// Returns a matrix row on an [index] (the operator is an alias for
  /// [getRow] method)
  Vector operator [](int index);

  /// Performs sum of the matrix and a matrix/ a vector/ a scalar/ whatever
  Matrix operator +(Object value);

  /// Performs subtraction of the matrix and a matrix/ a vector/ a scalar/
  /// whatever
  Matrix operator -(Object value);

  /// Performs multiplication of the matrix and a matrix/ a vector/ a scalar/
  /// whatever
  Matrix operator *(Object value);

  /// Performs division of the matrix by a matrix/ a vector/ a scalar
  ///
  /// If division by a matrix is taking place, each element of this [Matrix]
  /// will be divided by each element of another matrix. If the other matrix has
  /// a different shape, an exception will be thrown.
  ///
  /// If division by a vector is taking place, the direction of the division
  /// will be automatically detected:
  /// - if [rowsNum] is equal to the vector's length, the division will be
  /// applied column-wise
  /// - if [columnsNum] is equal to the vector's length, the division will be
  /// applied row-wise
  /// - if this [Matrix] is square, an exception will be thrown.
  ///
  /// If division by a scalar is taking place, each element of this [Matrix]
  /// will be divided by the scalar
  Matrix operator /(Object value);

  /// Performs transposition of the matrix
  Matrix transpose();

  /// Samples a new [Matrix] from parts of this [Matrix]
  Matrix sample({
    Iterable<int> rowIndices,
    Iterable<int> columnIndices,
  });

  /// Returns a column of the matrix on [index]
  Vector getColumn(int index);

  /// Returns a row of the matrix on [index]
  Vector getRow(int index);

  /// Reduces all the matrix columns to only column, using [combiner] function
  Vector reduceColumns(Vector Function(Vector combine, Vector vector) combiner,
      {Vector? initValue});

  /// Reduces all the matrix rows to only row, using [combiner] function
  Vector reduceRows(Vector Function(Vector combine, Vector vector) combiner,
      {Vector? initValue});

  /// Performs element-wise mapping of this [Matrix] to a new one via passed
  /// [mapper] function
  Matrix mapElements(double Function(double element) mapper);

  /// Performs column-wise mapping of this [Matrix] to a new one via passed
  /// [mapper] function
  Matrix mapColumns(Vector Function(Vector column) mapper);

  /// Performs row-wise mapping of this [Matrix] to a new one via passed
  /// [mapper] function
  Matrix mapRows(Vector Function(Vector row) mapper);

  /// Creates a new matrix, efficiently iterating through all the matrix
  /// elements (several floating point elements in a time) and applying the
  /// [mapper] function
  ///
  /// Type [E] should be either [Float32x4] or [Float64x2], depends on [dtype]
  /// value
  Matrix fastMap<E>(E Function(E columnElement) mapper);

  /// Tries to convert the [Matrix] to a vector:
  ///
  /// ````dart
  /// import 'package:ml_linalg/matrix.dart';
  ///
  /// void main() {
  ///   final matrix = Matrix.column([1, 2, 3, 4, 5]);
  ///   final vector = matrix.toVector();
  ///
  ///   print(vector);
  /// }
  /// ````
  ///
  /// The output:
  ///
  /// ```
  /// (1.0, 2.0, 3.0, 4.0, 5.0)
  /// ```
  ///
  /// It fails, if both [columnsNum] and [rowsNum] are greater than `1`:
  ///
  /// ````dart
  /// import 'package:ml_linalg/matrix.dart';
  ///
  /// void main() {
  ///   final matrix = Matrix.fromList([
  ///     [1.0, 2.0, 3.0, 4.0],
  ///     [5.0, 6.0, 7.0, 8.0],
  ///   ]);
  ///
  ///   final vector = matrix.toVector();
  /// }
  /// ````
  ///
  /// The output:
  ///
  /// ```
  /// Exception: Cannot convert 2 x 4 matrix into a vector
  /// ```
  Vector toVector();

  /// Returns maximal value of the matrix
  double max();

  /// Return minimal value of the matrix
  double min();

  /// Returns a norm of a matrix
  double norm([MatrixNorm norm]);

  /// Returns a new matrix with inserted [columns]
  Matrix insertColumns(int index, List<Vector> columns);

  /// Extracts non-repeated matrix rows and pack them into matrix
  Matrix uniqueRows();

  /// Returns mean values of matrix column/rows
  Vector mean([Axis axis = Axis.columns]);

  /// Returns standard deviation values of matrix column/rows
  Vector deviation([Axis axis = Axis.columns]);

  /// Returns a new matrix with sorted elements from this [Matrix]
  Matrix sort(double Function(Vector vector) selectSortValue,
      [Axis axis = Axis.rows, SortDirection sortDir = SortDirection.asc]);

  /// Raise all the elements of the matrix to the power [exponent] and returns
  /// a new [Matrix] with these elements. Avoid raising a matrix to a float
  /// power, since it is a slow operation
  Matrix pow(num exponent);

  /// Creates a new [Matrix] composed of Euler's numbers raised to powers which
  /// are the elements of this [Matrix]
  Matrix exp({bool skipCaching = false});

  /// Creates a new [Matrix] composed of natural logarithms of the source
  /// matrix elements
  Matrix log({bool skipCaching = false});

  /// Performs Hadamard product - element-wise matrices multiplication
  Matrix multiply(Matrix other);

  /// Returns the sum of all the matrix elements
  double sum();

  /// Returns the product of all the matrix elements
  double prod();

  /// Decomposes the original matrix into several matrices whose product results in the original matrix
  /// Default value id [Decomposition.LU]
  Iterable<Matrix> decompose([Decomposition decompositionType]);

  /// Finds the inverse of the original matrix. Product of the inverse and the original matrix results in singular matrix
  /// Default value id [Inverse.LU]
  Matrix inverse([Inverse inverseType]);

  /// Returns a serializable map
  Map<String, dynamic> toJson();
}
