import 'package:ml_linalg/dtype.dart';

import 'eigen_test_group_factory.dart';

void main() {
  eigenTestGroupFactory(DType.float32);
  eigenTestGroupFactory(DType.float64);
}
