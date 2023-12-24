import 'package:ml_linalg/dtype.dart';
import 'solve_test_group_factory.dart';

void main() {
  matrixSolveTestGroupFactory(DType.float32);
  matrixSolveTestGroupFactory(DType.float64);
}
