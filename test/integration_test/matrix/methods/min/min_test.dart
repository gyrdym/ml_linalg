import 'package:ml_linalg/dtype.dart';

import 'min_test_group_factory.dart';

void main() {
  matrixMinTestGroupFactory(DType.float32);
  matrixMinTestGroupFactory(DType.float64);
}
