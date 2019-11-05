import 'package:ml_linalg/axis.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix_norm.dart';
import 'package:ml_linalg/sort_direction.dart';
import 'package:ml_linalg/src/matrix/float32/float32_matrix.dart';
import 'package:ml_linalg/vector.dart';

/// An algebraic matrix
abstract class Matrix  implements Iterable<Iterable<double>> {
  /// Creates a matrix from a two dimensional list, every nested list is a
  /// source for a matrix row.
  ///
  /// There is no check of nested lists lengths in the [source] due to
  /// performance, keep it in mind, don't create a matrix from nested lists of
  /// different lengths
  factory Matrix.fromList(List<List<double>> source,
      {DType dtype = DType.float32}) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix.fromList(source);
      default:
        throw UnimplementedError('Matrix of type $dtype is not implemented yet');
    }
  }

  /// Creates a matrix with predefined row vectors
  ///
  /// There is no check of nested vectors lengths in the [source] due to
  /// performance, keep it in mind, don't create a matrix from vectors lists of
  /// different lengths
  factory Matrix.fromRows(List<Vector> source, {DType dtype = DType.float32}) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix.rows(source);
      default:
        throw UnimplementedError('Matrix of type $dtype is not implemented yet');
    }
  }

  /// Creates a matrix with predefined column vectors
  ///
  /// There is no check of nested vectors lengths in the [source] due to
  /// performance, keep it in mind, don't create a matrix from nested vectors of
  /// different lengths
  factory Matrix.fromColumns(List<Vector> source,
      {DType dtype = DType.float32}) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix.columns(source);
      default:
        throw UnimplementedError('Matrix of type $dtype is not implemented yet');
    }
  }

  /// Creates a matrix of shape 0 x 0 (no rows, no columns)
  factory Matrix.empty({DType dtype = DType.float32}) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix.empty();
      default:
        throw UnimplementedError('Matrix of type $dtype is not implemented yet');
    }
  }

  /// Creates a matrix from flattened list of length equal to
  /// [rowsNum] * [columnsNum]
  factory Matrix.fromFlattenedList(List<double> source, int rowsNum,
      int columnsNum, {DType dtype = DType.float32}) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix.flattened(source, rowsNum, columnsNum);
      default:
        throw UnimplementedError('Matrix of type $dtype is not implemented yet');
    }
  }

  /// Creates a matrix, where elements from [source] are the elements for the
  /// matrix main diagonal, the rest of the elements are zero
  ///
  /// ````dart
  /// final matrix = Matrix.diagonal([1, 2, 3, 4, 5]);
  ///
  /// print(matrix);
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
  factory Matrix.diagonal(List<double> source, {DType dtype = DType.float32}) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix.diagonal(source);
      default:
        throw UnimplementedError('Matrix of type $dtype is not implemented yet');
    }
  }

  /// Creates a matrix of [size] * [size] dimension, where all the main
  /// diagonal elements are equal to [scalar], the rest of the elements are 0
  ///
  /// ````dart
  /// final matrix = Matrix.scalar(3, 5);
  ///
  /// print(matrix);
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
  factory Matrix.scalar(double scalar, int size, {DType dtype = DType.float32}) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix.scalar(scalar, size);
      default:
        throw UnimplementedError('Matrix of type $dtype is not implemented yet');
    }
  }

  /// Creates a matrix of [size] * [size] dimension, where all the main
  /// diagonal elements are equal to 1, the rest of the elements are 0
  ///
  /// ````dart
  /// final matrix = Matrix.identity(5);
  ///
  /// print(matrix);
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
  factory Matrix.identity(int size, {DType dtype = DType.float32}) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix.scalar(1.0, size);
      default:
        throw UnimplementedError('Matrix of type $dtype is not implemented yet');
    }
  }

  /// Creates a matrix, consisting of just one row (aka `Row matrix`)
  ///
  /// ````dart
  /// final matrix = Matrix.row([1, 2, 3, 4, 5]);
  ///
  /// print(matrix);
  /// ````
  ///
  /// The output:
  ///
  /// ```
  /// Matrix 1 x 5:
  /// (1.0, 2.0, 3.0, 4.0, 5.0)
  /// ```
  factory Matrix.row(List<double> source, {DType dtype = DType.float32}) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix.rows([Vector.fromList(source, dtype: dtype)]);
      default:
        throw UnimplementedError(
            'Matrix of type $dtype is not implemented yet');
    }
  }

  /// Creates a matrix, consisting of just one column (aka `Column matrix`)
  ///
  /// ````dart
  /// final matrix = Matrix.column([1, 2, 3, 4, 5]);
  ///
  /// print(matrix);
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
  factory Matrix.column(List<double> source, {DType dtype = DType.float32}) {
    switch (dtype) {
      case DType.float32:
        return Float32Matrix.columns([Vector.fromList(source, dtype: dtype)]);
      default:
        throw UnimplementedError(
            'Matrix of type $dtype is not implemented yet');
    }
  }

  /// A data type of [Matrix] elements
  DType get dtype;

  /// Returns a lazy iterable of immutable row vectors of the matrix
  Iterable<Vector> get rows;

  /// Returns a lazy iterable of immutable column vectors of the matrix
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

  /// Performs division of the matrix by a matrix/ a vector/ a scalar/
  /// whatever
  Matrix operator /(Object value);

  /// Performs transposition of the matrix
  Matrix transpose();

  /// Samples a new [Matrix] from parts of this [Matrix]
  Matrix sample({
    Iterable<int> rowIndices,
    Iterable<int> columnIndices,
  });

  /// Returns a column of the matrix, resided on [index]
  Vector getColumn(int index);

  /// Returns a row of the matrix, resided on [index]
  Vector getRow(int index);

  /// Reduces all the matrix columns to only column, using [combiner] function
  Vector reduceColumns(Vector combiner(Vector combine, Vector vector),
      {Vector initValue});

  /// Reduces all the matrix rows to only row, using [combiner] function
  Vector reduceRows(Vector combiner(Vector combine, Vector vector),
      {Vector initValue});

  /// Performs column-wise mapping of this matrix to a new one via passed
  /// [mapper] function
  Matrix mapColumns(Vector mapper(Vector column));

  /// Performs row-wise mapping of this matrix to a new one via passed
  /// [mapper] function
  Matrix mapRows(Vector mapper(Vector row));

  /// Creates a new matrix, efficiently iterating through all the matrix
  /// elements (several floating point elements in a time) and applying the
  /// [mapper] function
  Matrix fastMap<E>(E mapper(E columnElement));

  /// Tries to convert the matrix to a vector.
  ///
  /// It fails, if both [columnsNum] and [rowsNum] are greater than `1`
  Vector toVector();

  /// Returns max value of the matrix
  double max();

  /// Return min value of the matrix
  double min();

  /// Returns a norm of a matrix
  double norm([MatrixNorm norm]);

  /// Returns a new matrix with inserted column
  Matrix insertColumns(int index, List<Vector> columns);

  /// Extracts non-repeated matrix rows and pack them into matrix
  Matrix uniqueRows();

  /// Returns mean values of matrix column/rows
  Vector mean([Axis axis = Axis.columns]);

  /// Returns standard deviation values of matrix column/rows
  Vector deviation([Axis axis = Axis.columns]);

  /// Returns a new matrix with sorted elements from [this] matrix
  Matrix sort(double selectSortValue(Vector vector), [Axis axis = Axis.rows,
    SortDirection sortDir = SortDirection.asc]);
}
