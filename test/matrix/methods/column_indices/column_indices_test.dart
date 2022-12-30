import 'package:ml_linalg/dtype.dart';

import 'column_indices_test_group_factory.dart';

void main() {
  matrixColumnIndicesTestGroupFactory(DType.float32);
  matrixColumnIndicesTestGroupFactory(DType.float64);
}
