import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart' show Matrix;

/// A mutable copy of a [Matrix] for in-place numerical operations.
abstract class MutableMatrix implements Iterable<Iterable<double>> {
  /// Numeric type used to store the matrix elements.
  DType get dtype;

  /// Number of rows.
  int get rowCount;

  /// Number of columns.
  int get columnCount;

  /// Mutable row-major view of all matrix elements.
  List<double> get asFlattenedList;

  /// Returns the row at [index].
  Iterable<double> operator [](int index);

  /// Creates an independent immutable matrix copy of the current values.
  Matrix toMatrix();

  /// Multiplies every element by [factor] in place.
  MutableMatrix scale(num factor);

  /// Adds [other] multiplied by [factor] to this matrix in place.
  ///
  /// [other] may be an immutable [Matrix] or a [MutableMatrix]. Both matrices
  /// must have the same shape.
  MutableMatrix addScaled(Object other, num factor);

  /// Writes the matrix product of this matrix and [other] into [destination].
  ///
  /// [other] may be an immutable [Matrix] or a [MutableMatrix]. The number of
  /// columns in this matrix must equal the number of rows in [other], and
  /// [destination] must have the product's shape. Returns [destination].
  MutableMatrix multiplyInto(Object other, MutableMatrix destination);

  /// Returns the Frobenius norm of the difference from [other] without
  /// creating an intermediate matrix.
  ///
  /// [other] may be an immutable [Matrix] or a [MutableMatrix]. Both matrices
  /// must have the same shape.
  double differenceNorm(Object other);
}
