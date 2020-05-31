import 'package:ml_linalg/dtype.dart';

import 'map_to_vector_test_group_factory.dart';

void main() {
  vectorMapToVectorTestGroupFactory(DType.float32);
  vectorMapToVectorTestGroupFactory(DType.float64);
}
