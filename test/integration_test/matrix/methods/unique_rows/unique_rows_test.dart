import 'package:ml_linalg/dtype.dart';

import 'unique_rows_test_group_factory.dart';

void main() {
  matrixUniqueRowsTestGroupFactory(DType.float32);
  matrixUniqueRowsTestGroupFactory(DType.float64);
}
