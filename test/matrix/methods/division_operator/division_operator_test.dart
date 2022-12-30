import 'package:ml_linalg/dtype.dart';

import 'division_operator_test_group_factory.dart';

void main() {
  matrixDivisionOperatorTestGroupFactory(DType.float32);
  matrixDivisionOperatorTestGroupFactory(DType.float64);
}
