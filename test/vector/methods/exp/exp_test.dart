import 'package:ml_linalg/dtype.dart';

import 'exp_test_group_factory.dart';

void main() {
  vectorExpTestGroupFactory(DType.float32);
  vectorExpTestGroupFactory(DType.float64);
}
