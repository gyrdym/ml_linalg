import 'package:ml_linalg/dtype.dart';

import 'from_json_test_group_factory.dart';

void main() {
  matrixFromJsonTestGroupFactory(DType.float32);
  matrixFromJsonTestGroupFactory(DType.float64);
}
