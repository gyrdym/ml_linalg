import 'package:ml_linalg/dtype.dart';

import 'dot_test_group_factory.dart';

void main() {
  vectorDotTestGroupFactory(DType.float32);
  vectorDotTestGroupFactory(DType.float64);
}
