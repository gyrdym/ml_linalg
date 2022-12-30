import 'package:ml_linalg/dtype.dart';

import 'sample_test_group_factory.dart';

void main() {
  vectorSampleTestGroupFactory(DType.float32);
  vectorSampleTestGroupFactory(DType.float64);
}
