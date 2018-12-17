import 'package:ml_linalg/range.dart';
import 'package:ml_linalg/vector.dart';

abstract class MLMatrix<E> {
  /// Returns a number of matrix row
  int get rowsNum;

  /// Returns a number of matrix columns
  int get columnsNum;

  /// Returns a matrix row on an index equals [index]
  Iterable<double> operator [](int index);

  /// Performs sum of the matrix and a matrix/ a vector/ a scalar/ whatever
  MLMatrix<E> operator +(Object value);

  /// Performs subtraction of the matrix and a matrix/ a vector/ a scalar/ whatever
  MLMatrix<E> operator -(Object value);

  /// Performs multiplication of the matrix and a matrix/ a vector/ a scalar/ whatever
  MLMatrix<E> operator *(Object value);

  /// Performs transposition of the matrix
  MLMatrix<E> transpose();

  /// Cuts out a part of the matrix bounded by [rows] and [columns] range
  MLMatrix<E> submatrix({Range rows, Range columns});

  /// Creates a new matrix, consisted of different segments of the matrix
  MLMatrix<E> pick({Iterable<Range> rowRanges, Iterable<Range> columnRanges});

  /// Returns a column of the matrix, resided on [index]
  MLVector<E> getColumn(int index, {bool tryCache = true, bool mutable = false});

  /// Returns a row of the matrix, resided on [index]
  MLVector<E> getRow(int index, {bool tryCache = true, bool mutable = false});

  /// Reduces all the matrix columns to only column, using [combiner] function
  MLVector<E> reduceColumns(MLVector<E> combiner(MLVector<E> combine, MLVector<E> vector), {MLVector<E> initValue});

  /// Reduces all the matrix rows to only row, using [combiner] function
  MLVector<E> reduceRows(MLVector<E> combiner(MLVector<E> combine, MLVector<E> vector), {MLVector<E> initValue});

  /// Creates a new matrix, efficiently iterating through all the matrix elements (several floating point elements in a
  /// time) and applying the [mapper] function
  MLMatrix<E> vectorizedMap(E mapper(E columnElement));

  /// Tries to convert the matrix to a vector. It fails, if the matrix's both numbers of columns and rows are greater
  /// than 1
  MLVector<E> toVector({bool mutable = false});
}
