import 'package:ml_linalg/dtype.dart';

import 'max_test_group_factory.dart';

void main() {
  vectorMaxTestGroupFactory(DType.float32);
  vectorMaxTestGroupFactory(DType.float64);
}
