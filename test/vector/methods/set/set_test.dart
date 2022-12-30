import 'package:ml_linalg/dtype.dart';

import 'set_test_group_factory.dart';

void main() {
  vectorSetTestGroupFactory(DType.float32);
  vectorSetTestGroupFactory(DType.float64);
}
