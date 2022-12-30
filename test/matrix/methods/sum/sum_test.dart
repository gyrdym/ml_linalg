import 'package:ml_linalg/dtype.dart';

import 'sum_test_group_factory.dart';

void main() {
  matrixSumTestGroupFactory(DType.float32);
  matrixSumTestGroupFactory(DType.float64);
}
