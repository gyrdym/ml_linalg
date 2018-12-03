import 'dart:typed_data';

import 'package:ml_linalg/src/matrix/float32x4_matrix.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

abstract class Float32x4MatrixFactory {
  static MLMatrix<Float32x4, MLVector<Float32x4>> from(List<List<double>> source) =>
      Float32x4Matrix.from(source);
}
