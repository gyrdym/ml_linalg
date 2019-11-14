import 'package:ml_linalg/dtype.dart';

import 'diagonal_constructor_test_group_factory.dart';

void main() {
  matrixDiagonalConstructorTestGroupFactory(DType.float32);
  matrixDiagonalConstructorTestGroupFactory(DType.float64);
}
