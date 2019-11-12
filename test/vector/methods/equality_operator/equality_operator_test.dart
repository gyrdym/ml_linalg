import 'package:ml_linalg/dtype.dart';

import 'equality_operator_test_group_factory.dart';

void main() {
  vectorEqualityOperatorTestGroupFactory(DType.float32);
  vectorEqualityOperatorTestGroupFactory(DType.float64);
}
