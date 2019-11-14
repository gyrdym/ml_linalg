import 'package:ml_linalg/dtype.dart';

import 'column_constructor_test_group_factory.dart';

void main() {
  matrixColumnConstructorTestGroupFactory(DType.float32);
  matrixColumnConstructorTestGroupFactory(DType.float64);
}
