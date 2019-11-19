import 'package:ml_linalg/dtype.dart';

import 'division_operator_test_group_factory.dart';

void main() {
  vectorDivisionOperatorTestGroupFactory(DType.float32);
  vectorDivisionOperatorTestGroupFactory(DType.float64);
}
