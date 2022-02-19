import 'package:ml_linalg/dtype.dart';

import 'filter_columns_test_group_factory.dart';

void main() {
  matrixFilterColumnsTestGroupFactory(DType.float32);
  matrixFilterColumnsTestGroupFactory(DType.float64);
}
