import 'package:ml_linalg/dtype.dart';
import 'decompose_test_group_factory.dart';

void main() {
  matrixDecomposeTestGroupFactory(DType.float32);
  matrixDecomposeTestGroupFactory(DType.float64);
}
