import 'package:ml_linalg/dtype.dart';

import 'add_operator_test_group_factory.dart';

void main() {
  vectorAddOperatorTestGroupFactory(DType.float32);
  vectorAddOperatorTestGroupFactory(DType.float64);
}
