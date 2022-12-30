import 'package:ml_linalg/dtype.dart';

import 'exp_test_group_factory.dart';

void main() {
  matrixExpTestGroupFactory(DType.float32);
  matrixExpTestGroupFactory(DType.float64);
}
