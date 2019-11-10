import 'package:ml_linalg/dtype.dart';

import 'abs_test_group_factory.dart';

void main() {
  vectorAbsOperatorTestGroupFactory(DType.float32);
  vectorAbsOperatorTestGroupFactory(DType.float64);
}
