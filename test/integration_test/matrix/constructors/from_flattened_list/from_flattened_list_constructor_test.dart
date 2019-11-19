import 'package:ml_linalg/dtype.dart';

import 'from_flattened_list_test_group_factory.dart';

void main() {
  matrixFromFlattenedListConstructorTestGroupFactory(DType.float32);
  matrixFromFlattenedListConstructorTestGroupFactory(DType.float64);
}
