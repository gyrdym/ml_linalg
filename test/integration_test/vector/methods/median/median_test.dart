import 'package:ml_linalg/dtype.dart';

import 'median_test_group_factory.dart';

void main() {
  vectorMedianTestGroupFactory(DType.float32);
  vectorMedianTestGroupFactory(DType.float64);
}
