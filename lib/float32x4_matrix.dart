import 'dart:typed_data';

import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/matrix/float32/float32x4_matrix.dart';
import 'package:ml_linalg/vector.dart';

/// A matrix, based on Float32x4-vector ([MLVector<Float32x4>])
abstract class Float32x4Matrix implements MLMatrix<Float32x4> {
  /// Creates a matrix from a two dimensional list
  factory Float32x4Matrix.from(List<List<double>> source) = Float32x4MatrixInternal.from;

  /// Creates a matrix with predefined row vectors
  factory Float32x4Matrix.rows(List<MLVector<Float32x4>> source) = Float32x4MatrixInternal.rows;

  /// Creates a matrix with predefined column vectors
  factory Float32x4Matrix.columns(List<MLVector<Float32x4>> source) = Float32x4MatrixInternal.columns;
}
