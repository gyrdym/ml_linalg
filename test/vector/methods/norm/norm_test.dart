import 'package:ml_linalg/dtype.dart';

import 'norm_test_group_factory.dart';

void main() {
  vectorNormTestGroupFactory(DType.float32);
  vectorNormTestGroupFactory(DType.float64);
}
