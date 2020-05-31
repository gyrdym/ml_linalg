import 'package:ml_linalg/dtype.dart';

import 'prod_test_group_factory.dart';

void main() {
  vectorProdTestGroupFactory(DType.float32);
  vectorProdTestGroupFactory(DType.float64);
}
