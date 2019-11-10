import 'package:ml_linalg/dtype.dart';

import 'rescale_test_group_factory.dart';

void main() {
  vectorRescaleTestGroupFactory(DType.float32);
  vectorRescaleTestGroupFactory(DType.float64);
}
