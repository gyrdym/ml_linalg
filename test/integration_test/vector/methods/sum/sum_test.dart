import 'package:ml_linalg/dtype.dart';

import 'sum_test_group_factory.dart';

void main() {
  vectorSumTestGroupFactory(DType.float32);
  vectorSumTestGroupFactory(DType.float64);
}
