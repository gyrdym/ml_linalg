// Approx. 0.8 seconds (MacBook Pro 2019), Dart version: 3.2.4
// Approx. 2.2 seconds (MacBook Air mid 2017), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const numOfRows = 1000;
const numOfColumns = 1000;

class Float32MatrixMultMatrixMatrixBenchmark extends BenchmarkBase {
  Float32MatrixMultMatrixMatrixBenchmark()
      : super('Matrix float32, matrix by matrix multiplication ');

  final Matrix matrix =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 5);

  final Matrix other =
      Matrix.random(numOfColumns, numOfRows, dtype: DType.float32, seed: 6);

  static void main() {
    Float32MatrixMultMatrixMatrixBenchmark().report();
  }

  @override
  void exercise() => run();

  @override
  void run() {
    matrix * other;
  }
}

void main() {
  Float32MatrixMultMatrixMatrixBenchmark.main();
}
