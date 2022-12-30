import 'package:ml_linalg/dtype.dart';

import 'transpose_test_group_factory.dart';

void main() {
  matrixTransposeTestGroupFactory(DType.float32);
  matrixTransposeTestGroupFactory(DType.float64);
}
