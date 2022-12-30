import 'package:ml_linalg/dtype.dart';

import 'reduce_columns_test_group_factory.dart';

void main() {
  matrixReduceColumnsTestGroupFactory(DType.float32);
  matrixReduceColumnsTestGroupFactory(DType.float64);
}
