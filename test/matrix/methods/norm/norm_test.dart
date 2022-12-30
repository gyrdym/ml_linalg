import 'package:ml_linalg/dtype.dart';

import 'norm_test_group_factory.dart';

void main() {
  matrixNormTestGroupFactory(DType.float32);
  matrixNormTestGroupFactory(DType.float64);
}
