import 'package:ml_linalg/dtype.dart';

import 'unique_test_group_factory.dart';

void main() {
  vectorUniqueTestGroupFactory(DType.float32);
  vectorUniqueTestGroupFactory(DType.float64);
}
