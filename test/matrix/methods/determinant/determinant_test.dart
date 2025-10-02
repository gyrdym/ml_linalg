import 'package:ml_linalg/dtype.dart';

import 'determinant_test_group_factory.dart';

void main() {
  determinantTestGroupFactory(DType.float32);
  determinantTestGroupFactory(DType.float64);
}
