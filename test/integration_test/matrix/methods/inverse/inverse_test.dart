import 'package:ml_linalg/dtype.dart';
import 'inverse_test_group_factory.dart';

void main() {
  matrixInverseTestGroupFactory(DType.float32);
  matrixInverseTestGroupFactory(DType.float64);
}
