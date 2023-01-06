import 'package:ml_linalg/dtype.dart';

import 'prod_test_group_factory.dart';

void main() {
  matrixProdTestGroupFactory(DType.float32);
  matrixProdTestGroupFactory(DType.float64);
}
