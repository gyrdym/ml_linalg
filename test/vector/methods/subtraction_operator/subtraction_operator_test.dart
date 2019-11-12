import 'package:ml_linalg/dtype.dart';

import 'subtraction_operator_test_group_factory.dart';

void main() {
  vectorSubtractionOperatorTestGroupFactory(DType.float32);
  // uncomment it when the Matrix class supports DType.float64
  // vectorSubtractionOperatorTestGroupFactory(DType.float64);
}
