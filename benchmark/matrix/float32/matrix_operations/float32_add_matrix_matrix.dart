// Approx. 1.5 seconds (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const numOfRows = 20001;
const numOfColumns = 2001;

class Float32MatrixAddMatrixMatrixBenchmark extends BenchmarkBase {
  Float32MatrixAddMatrixMatrixBenchmark()
      : super('Matrix float32, matrix and matrix summation');

  final matrix =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 5);

  final other =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 6);

  static void main() {
    Float32MatrixAddMatrixMatrixBenchmark().report();
  }

  @override
  void run() {
    matrix + other;
  }
}

void main() {
  Float32MatrixAddMatrixMatrixBenchmark.main();
}
