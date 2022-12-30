import 'package:ml_linalg/dtype.dart';

import 'pow_test_group_factory.dart';

void main() {
  matrixPowTestGroupFactory(DType.float32);
  matrixPowTestGroupFactory(DType.float64);
}
