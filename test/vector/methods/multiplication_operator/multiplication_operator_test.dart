import 'package:ml_linalg/dtype.dart';

import 'multiplication_operator_test_group_factory.dart';

void main() {
  vectorMultiplicationOperatorTestGroupFactory(DType.float32);
  vectorMultiplicationOperatorTestGroupFactory(DType.float64);
}
