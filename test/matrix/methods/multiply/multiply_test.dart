import 'package:ml_linalg/dtype.dart';

import 'multiply_test_group_factory.dart';

void main() {
  matrixMultiplyTestGroupFactory(DType.float32);
  matrixMultiplyTestGroupFactory(DType.float64);
}
