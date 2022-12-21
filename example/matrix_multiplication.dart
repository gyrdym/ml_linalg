import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const numOfRows = 1000;
const numOfColumns = 100;

void main() {
  final matrix =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 5);
  final other =
      Matrix.random(numOfColumns, numOfRows, dtype: DType.float32, seed: 6);
  final result = matrix * other;

  print(result);
}
