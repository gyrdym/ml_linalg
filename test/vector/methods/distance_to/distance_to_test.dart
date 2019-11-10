import 'package:ml_linalg/dtype.dart';

import 'distance_to_test_group_factory.dart';

void main() {
  vectorDistanceToTestGroupFactory(DType.float32);
  vectorDistanceToTestGroupFactory(DType.float64);
}
