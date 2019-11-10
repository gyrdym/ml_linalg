import 'package:ml_linalg/dtype.dart';

import 'min_test_group_factory.dart';

void main() {
  vectorMinTestGroupFactory(DType.float32);
  vectorMinTestGroupFactory(DType.float64);
}
