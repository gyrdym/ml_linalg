import 'package:ml_linalg/dtype.dart';

import 'vector_hash_code_test_group_factory.dart';

void main() {
  vectorHashCodeTestGroupFactory(DType.float32);
  vectorHashCodeTestGroupFactory(DType.float64);
}
