import 'package:ml_linalg/dtype.dart';

import 'normalize_test_group_factory.dart';

void main() {
  vectorNormalizeTestGroupFactory(DType.float32);
  vectorNormalizeTestGroupFactory(DType.float64);
}
