import 'package:ml_linalg/dtype.dart';

import 'identity_constructor_test_group_factory.dart';

void main() {
  matrixIdentityConstructorTestGroupFactory(DType.float32);
  matrixIdentityConstructorTestGroupFactory(DType.float64);
}
