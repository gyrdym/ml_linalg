import 'package:ml_linalg/dtype.dart';

import 'get_row_test_group_factory.dart';

void main() {
  matrixGetRowTestGroupFactory(DType.float32);
  matrixGetRowTestGroupFactory(DType.float64);
}
