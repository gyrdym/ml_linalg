import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix_norm.dart';
import 'package:ml_linalg/src/matrix/float32/float32_matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:xrange/zrange.dart';

/// An algebraic matrix
abstract class Matrix {
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
        throw UnimplementedError();
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
        throw UnimplementedError();
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
        throw UnimplementedError();
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
        throw UnimplementedError();
    }
  }

  DType get dtype;

  /// Returns a generator of immutable row vectors of the matrix
  Iterable<Vector> get rows;

  /// Returns a generator of immutable column vectors of the matrix
  Iterable<Vector> get columns;

  /// Returns a number of matrix row
  int get rowsNum;

  /// Returns a number of matrix columns
  int get columnsNum;

  /// Returns a matrix row on an index equals [index]
  List<double> operator [](int index);

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

  /// Cuts out a part of the matrix bounded by [rows] and [columns] range
  Matrix submatrix({ZRange rows, ZRange columns});

  /// Creates a new matrix, consisted of different segments of the matrix
  Matrix pick({Iterable<ZRange> rowRanges, Iterable<ZRange> columnRanges});

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
  /// It fails, if the matrix's both numbers of columns and rows are greater
  /// than `1`
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
}
