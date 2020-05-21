import 'package:ml_linalg/dtype.dart';

import 'to_json_test_group_factory.dart';

void main() {
  vectorToJsonTestGroupFactory(DType.float32);
  vectorToJsonTestGroupFactory(DType.float64);
}
