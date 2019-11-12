import 'package:ml_linalg/dtype.dart';

import 'sqrt_test_group_factory.dart';

void main() {
  vectorSqrtTestGroupFactory(DType.float32);
  vectorSqrtTestGroupFactory(DType.float64);
}
