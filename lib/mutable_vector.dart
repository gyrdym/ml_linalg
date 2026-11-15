import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart' show Vector;

/// A mutable copy of a [Vector] for in-place arithmetic operations.
abstract class MutableVector implements Iterable<double> {
  /// The numeric type used to store this vector's values.
  DType get dtype;

  /// Returns the value at [index].
  double operator [](int index);

  /// Creates an immutable [Vector] copy of the current values.
  Vector toVector();

  /// Adds each value in [vector] to the matching value in this mutable vector.
  ///
  /// Both vectors must have the same length. Returns this mutable vector.
  MutableVector add(Vector vector);

  /// Subtracts each value in [vector] from the matching value in this vector.
  ///
  /// Both vectors must have the same length. Returns this mutable vector.
  MutableVector subtract(Vector vector);

  /// Multiplies each value in this vector by the matching value in [vector].
  ///
  /// Both vectors must have the same length. Returns this mutable vector.
  MutableVector multiply(Vector vector);

  /// Divides each value in this vector by the matching value in [vector].
  ///
  /// Both vectors must have the same length. Returns this mutable vector.
  MutableVector divide(Vector vector);
}
