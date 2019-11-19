import 'package:ml_linalg/dtype.dart';

import 'indexed_access_operator_test_group_factory.dart';

void main() {
  vectorIndexedAccessOperatorTestGroupFactory(DType.float32);
  vectorIndexedAccessOperatorTestGroupFactory(DType.float64);
}
