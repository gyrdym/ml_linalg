import 'dart:typed_data';

import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/matrix/float32/float32x4_matrix.dart';
import 'package:ml_linalg/vector.dart';

abstract class Float32x4Matrix implements MLMatrix<Float32x4> {
  factory Float32x4Matrix.from(List<List<double>> source) = Float32x4MatrixInternal.from;
  factory Float32x4Matrix.rows(List<MLVector<Float32x4>> source) = Float32x4MatrixInternal.rows;
  factory Float32x4Matrix.columns(List<MLVector<Float32x4>> source) = Float32x4MatrixInternal.columns;
}
