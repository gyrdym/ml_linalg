import 'package:ml_linalg/dtype.dart';

import 'map_columns_test_group_factory.dart';

void main() {
  matrixMapColumnsTestGroupFactory(DType.float32);
  matrixMapColumnsTestGroupFactory(DType.float64);
}
