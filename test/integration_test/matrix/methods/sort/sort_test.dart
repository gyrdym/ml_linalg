import 'package:ml_linalg/dtype.dart';

import 'sort_test_group_factory.dart';

void main() {
  matrixSortTestGroupFactory(DType.float32);
  matrixSortTestGroupFactory(DType.float64);
}
