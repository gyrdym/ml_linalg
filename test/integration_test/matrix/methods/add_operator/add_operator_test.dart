import 'package:ml_linalg/dtype.dart';

import 'add_operator_test_group_factory.dart';

void main() {
  matrixAddOperatorTestGroupFactory(DType.float32);
  matrixAddOperatorTestGroupFactory(DType.float64);
}
