import 'package:ml_linalg/dtype.dart';

import 'reduce_rows_test_group_factory.dart';

void main() {
  matrixReduceRowsTestGroupFactory(DType.float32);
  matrixReduceRowsTestGroupFactory(DType.float64);
}
