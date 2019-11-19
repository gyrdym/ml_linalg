import 'package:ml_linalg/dtype.dart';

import 'subtraction_operator_test_group_factory.dart';

void main() {
  matrixSubtractionOperatorTestGroupFactory(DType.float32);
  matrixSubtractionOperatorTestGroupFactory(DType.float64);
}
