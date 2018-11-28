import 'dart:typed_data';

import 'package:linalg/src/matrix/float32x4_matrix.dart';
import 'package:linalg/src/matrix/matrix.dart';
import 'package:linalg/src/vector/vector.dart';

abstract class Float32x4MatrixFactory {
  static Matrix<Float32x4, Vector<Float32x4>> from(List<List<double>> source) =>
      Float32x4Matrix.from(source);
}
