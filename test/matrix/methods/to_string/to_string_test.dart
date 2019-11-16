import 'package:ml_linalg/dtype.dart';

import 'to_string_test_group.dart';

void main() {
  matrixToStringTestGroupFactory(DType.float32);
  matrixToStringTestGroupFactory(DType.float64);
}
