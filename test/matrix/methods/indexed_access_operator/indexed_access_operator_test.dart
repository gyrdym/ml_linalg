import 'package:ml_linalg/dtype.dart';

import 'indexed_access_operator_test_group_factory.dart';

void main() {
  matrixIndexedAccessOperatorTestGroupFactory(DType.float32);
  matrixIndexedAccessOperatorTestGroupFactory(DType.float64);
}
