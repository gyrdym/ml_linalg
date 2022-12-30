import 'package:ml_linalg/dtype.dart';

import 'columns_test_group_factory.dart';

void main() {
  matrixColumnsTestGroupFactory(DType.float32);
  matrixColumnsTestGroupFactory(DType.float64);
}
