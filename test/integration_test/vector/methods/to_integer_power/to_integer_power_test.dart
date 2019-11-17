import 'package:ml_linalg/dtype.dart';

import 'to_integer_power_test_group_factory.dart';

void main() {
  vectorToIntegerPowerTestGroupFactory(DType.float32);
  vectorToIntegerPowerTestGroupFactory(DType.float64);
}
