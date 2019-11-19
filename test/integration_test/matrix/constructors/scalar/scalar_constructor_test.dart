import 'package:ml_linalg/dtype.dart';

import 'scalar_constructor_test_group_factory.dart';

void main() {
  matrixScalarConstructorTestGroupFactory(DType.float32);
  matrixScalarConstructorTestGroupFactory(DType.float64);
}
