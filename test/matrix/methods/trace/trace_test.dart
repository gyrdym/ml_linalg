import 'package:ml_linalg/dtype.dart';

import 'trace_test_group_factory.dart';

void main() {
  traceTestGroupFactory(DType.float32);
  traceTestGroupFactory(DType.float64);
}
