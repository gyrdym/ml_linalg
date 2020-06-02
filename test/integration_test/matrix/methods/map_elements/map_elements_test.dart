import 'package:ml_linalg/dtype.dart';

import 'map_elements_test_group_factory.dart';

void main() {
  matrixMapElementsTestGroupFactory(DType.float32);
  matrixMapElementsTestGroupFactory(DType.float64);
}
