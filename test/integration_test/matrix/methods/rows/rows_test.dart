import 'package:ml_linalg/dtype.dart';

import 'rows_test_group_factory.dart';

void main() {
  matrixRowsTestGroupFactory(DType.float32);
  matrixRowsTestGroupFactory(DType.float64);
}
