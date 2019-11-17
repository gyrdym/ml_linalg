import 'package:ml_linalg/dtype.dart';

import 'insert_columns_test_group_factory.dart';

void main() {
  matrixInsertColumnsTestGroupFactory(DType.float32);
  matrixInsertColumnsTestGroupFactory(DType.float64);
}
