import 'package:ml_linalg/dtype.dart';

import 'pow_test_group_factory.dart';

void main() {
  vectorPowTestGroupFactory(DType.float32);
  vectorPowTestGroupFactory(DType.float64);
}
