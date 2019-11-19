import 'package:ml_linalg/dtype.dart';

import 'max_test_group_factory.dart';

void main() {
  matrixMaxTestGroupFactory(DType.float32);
  matrixMaxTestGroupFactory(DType.float64);
}
