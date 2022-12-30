import 'package:ml_linalg/dtype.dart';

import 'multiplication_operator_test_group_factory.dart';

void main() {
  matrixMultiplicationOperatorTestGroupFactory(DType.float32);
  matrixMultiplicationOperatorTestGroupFactory(DType.float64);
}
