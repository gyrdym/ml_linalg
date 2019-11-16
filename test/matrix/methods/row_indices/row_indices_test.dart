import 'package:ml_linalg/dtype.dart';

import 'row_indices_test_group_factory.dart';

void main() {
  matrixRowIndicesTestGroupFactory(DType.float32);
  matrixRowIndicesTestGroupFactory(DType.float64);
}
