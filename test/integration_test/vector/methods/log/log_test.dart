import 'package:ml_linalg/dtype.dart';

import 'log_test_group_factory.dart';

void main() {
  vectorLogVectorTestGroupFactory(DType.float32);
  vectorLogVectorTestGroupFactory(DType.float64);
}
