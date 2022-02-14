import 'package:ml_linalg/dtype.dart';

import 'random_constructor_test_group_factory.dart';

void main() {
  matrixRandomConstructorTestGroupFactory(DType.float32);
  matrixRandomConstructorTestGroupFactory(DType.float64);
}
