import 'package:ml_linalg/dtype.dart';

import 'mean_test_group_factory.dart';

void main() {
  matrixMeanTestGroupFactory(DType.float32);
  matrixMeanTestGroupFactory(DType.float64);
}
