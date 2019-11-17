import 'package:ml_linalg/dtype.dart';

import 'to_vector_test_group_factory.dart';

void main() {
  matrixToVectorTestGroupFactory(DType.float32);
  matrixToVectorTestGroupFactory(DType.float64);
}
