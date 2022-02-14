import 'package:ml_linalg/dtype.dart';

import 'random_spd_constructor_test_group_factory.dart';

void main() {
  matrixRandomSPDConstructorTestGroupFactory(DType.float32);
  matrixRandomSPDConstructorTestGroupFactory(DType.float64);
}
