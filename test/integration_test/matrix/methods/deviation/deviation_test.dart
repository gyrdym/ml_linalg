import 'package:ml_linalg/dtype.dart';

import 'deviation_test_group_factory.dart';

void main() {
  matrixDeviationTestGroupFactory(DType.float32);
  matrixDeviationTestGroupFactory(DType.float64);
}
