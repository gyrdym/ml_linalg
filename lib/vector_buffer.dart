import 'package:ml_linalg/vector.dart' show Vector;

/// A mutable interface for changing values in a vector.
///
/// It uses the same data as the original [Vector]. Changes are visible through
/// both the buffer and the vector.
abstract class VectorBuffer {
  /// Adds each value in [vector] to the matching value in this buffer.
  ///
  /// Both vectors must have the same length. Returns this buffer.
  VectorBuffer add(Vector vector);

  /// Subtracts each value in [vector] from the matching value in this buffer.
  ///
  /// Both vectors must have the same length. Returns this buffer.
  VectorBuffer subtract(Vector vector);

  /// Multiplies each value in this buffer by the matching value in [vector].
  ///
  /// Both vectors must have the same length. Returns this buffer.
  VectorBuffer multiply(Vector vector);

  /// Divides each value in this buffer by the matching value in [vector].
  ///
  /// Both vectors must have the same length. Returns this buffer.
  VectorBuffer divide(Vector vector);
}
