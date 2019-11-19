import 'package:ml_linalg/dtype.dart';

import 'row_constructor_test_group_factory.dart';

void main() {
  matrixRowConstructorTestGroupFactory(DType.float32);
  matrixRowConstructorTestGroupFactory(DType.float64);
}
