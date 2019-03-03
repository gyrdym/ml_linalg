import 'dart:typed_data';

import 'package:ml_linalg/matrix_norm.dart';
import 'package:ml_linalg/range.dart';
import 'package:ml_linalg/src/matrix/float32x4/float32x4_matrix.dart';
import 'package:ml_linalg/vector.dart';

/// An algebraic matrix
abstract class Matrix {
  /// Creates a matrix from a two dimensional list
  factory Matrix.from(List<List<double>> source, {Type dtype = Float32x4}) {
    switch (dtype) {
      case Float32x4:
        return Float32x4Matrix.from(source);
      default:
        throw UnimplementedError();
    }
  }

  /// Creates a matrix with predefined row vectors
  factory Matrix.rows(List<Vector> source, {Type dtype = Float32x4}) {
    switch (dtype) {
      case Float32x4:
        return Float32x4Matrix.rows(source);
      default:
        throw UnimplementedError();
    }
  }

  /// Creates a matrix with predefined column vectors
  factory Matrix.columns(List<Vector> source, {Type dtype = Float32x4}) {
    switch (dtype) {
      case Float32x4:
        return Float32x4Matrix.columns(source);
      default:
        throw UnimplementedError();
    }
  }

  /// Creates a matrix from flattened iterable of length that is equal to
  /// [rowsNum] * [columnsNum]
  factory Matrix.flattened(Iterable<double> source, int rowsNum,
      int columnsNum, {Type dtype = Float32x4}) {
    switch (dtype) {
      case Float32x4:
        return Float32x4Matrix.flattened(source, rowsNum, columnsNum);
      default:
        throw UnimplementedError();
    }
  }

  Type get dtype;

  /// Returns a number of matrix row
  int get rowsNum;

  /// Returns a number of matrix columns
  int get columnsNum;

  /// Returns a matrix row on an index equals [index]
  Iterable<double> operator [](int index);

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
  Matrix submatrix({Range rows, Range columns});

  /// Creates a new matrix, consisted of different segments of the matrix
  Matrix pick({Iterable<Range> rowRanges, Iterable<Range> columnRanges});

  /// Returns a column of the matrix, resided on [index]
  Vector getColumn(int index, {bool tryCache = true, bool mutable = false});

  /// Returns a row of the matrix, resided on [index]
  Vector getRow(int index, {bool tryCache = true, bool mutable = false});

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
  Vector toVector({bool mutable = false});

  /// Returns max value of the matrix
  double max();

  /// Return min value of the matrix
  double min();

  /// Returns a norm of a matrix
  double norm([MatrixNorm norm]);

  /// Sets the new values for the specific column
  ///
  /// [columnNum] - 0-based column number
  /// [columnValues] - values, that are going to be placed one by one in the
  /// target column
  void setColumn(int columnNum, Iterable<double> columnValues);

  /// Extracts non-repeated matrix rows and pack them into matrix
  Matrix uniqueRows();
}
