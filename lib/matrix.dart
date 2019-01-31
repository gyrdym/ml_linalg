import 'dart:typed_data';

import 'package:ml_linalg/range.dart';
import 'package:ml_linalg/src/matrix/float32x4/float32x4_matrix.dart';
import 'package:ml_linalg/vector.dart';

/// An algebraic matrix
abstract class MLMatrix {
  /// Creates a matrix from a two dimensional list
  factory MLMatrix.from(List<List<double>> source, {Type dtype = Float32x4}) {
    switch (dtype) {
      case Float32x4:
        return Float32x4Matrix.from(source);
      default:
        throw UnimplementedError();
    }
  }

  /// Creates a matrix with predefined row vectors
  factory MLMatrix.rows(List<MLVector> source, {Type dtype = Float32x4}) {
    switch (dtype) {
      case Float32x4:
        return Float32x4Matrix.rows(source);
      default:
        throw UnimplementedError();
    }
  }

  /// Creates a matrix with predefined column vectors
  factory MLMatrix.columns(List<MLVector> source, {Type dtype = Float32x4}) {
    switch (dtype) {
      case Float32x4:
        return Float32x4Matrix.columns(source);
      default:
        throw UnimplementedError();
    }
  }

  /// Returns a number of matrix row
  int get rowsNum;

  /// Returns a number of matrix columns
  int get columnsNum;

  /// Returns a matrix row on an index equals [index]
  Iterable<double> operator [](int index);

  /// Performs sum of the matrix and a matrix/ a vector/ a scalar/ whatever
  MLMatrix operator +(Object value);

  /// Performs subtraction of the matrix and a matrix/ a vector/ a scalar/ whatever
  MLMatrix operator -(Object value);

  /// Performs multiplication of the matrix and a matrix/ a vector/ a scalar/ whatever
  MLMatrix operator *(Object value);

  /// Performs transposition of the matrix
  MLMatrix transpose();

  /// Cuts out a part of the matrix bounded by [rows] and [columns] range
  MLMatrix submatrix({Range rows, Range columns});

  /// Creates a new matrix, consisted of different segments of the matrix
  MLMatrix pick({Iterable<Range> rowRanges, Iterable<Range> columnRanges});

  /// Returns a column of the matrix, resided on [index]
  MLVector getColumn(int index, {bool tryCache = true, bool mutable = false});

  /// Returns a row of the matrix, resided on [index]
  MLVector getRow(int index, {bool tryCache = true, bool mutable = false});

  /// Reduces all the matrix columns to only column, using [combiner] function
  MLVector reduceColumns(MLVector combiner(MLVector combine, MLVector vector), {MLVector initValue});

  /// Reduces all the matrix rows to only row, using [combiner] function
  MLVector reduceRows(MLVector combiner(MLVector combine, MLVector vector), {MLVector initValue});

  /// Creates a new matrix, efficiently iterating through all the matrix elements (several floating point elements in a
  /// time) and applying the [mapper] function
  MLMatrix fastMap<E>(E mapper(E columnElement));

  /// Tries to convert the matrix to a vector. It fails, if the matrix's both numbers of columns and rows are greater
  /// than 1
  MLVector toVector({bool mutable = false});
}
