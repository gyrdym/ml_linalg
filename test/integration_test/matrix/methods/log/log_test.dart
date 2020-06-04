import 'package:ml_linalg/dtype.dart';

import 'log_test_group_factory.dart';

void main() {
  matrixLogTestGroupFactory(DType.float32);
  matrixLogTestGroupFactory(DType.float64);
}
