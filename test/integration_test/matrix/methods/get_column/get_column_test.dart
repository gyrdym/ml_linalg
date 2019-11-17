import 'package:ml_linalg/dtype.dart';

import 'get_column_test_group_factory.dart';

void main() {
  matrixGetColumnTestGroupFactory(DType.float32);
  matrixGetColumnTestGroupFactory(DType.float64);
}
