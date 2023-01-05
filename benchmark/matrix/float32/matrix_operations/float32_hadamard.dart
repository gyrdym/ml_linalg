// Approx. 1.2 seconds (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const numOfRows = 20001;
const numOfColumns = 2001;

class Float32MatrixHadamardBenchmark extends BenchmarkBase {
  Float32MatrixHadamardBenchmark()
      : super('Matrix float32, matrix and matrix Hadamard product');

  final matrix =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 5);

  final other =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 6);

  static void main() {
    Float32MatrixHadamardBenchmark().report();
  }

  @override
  void run() {
    matrix.multiply(other);
  }
}

void main() {
  Float32MatrixHadamardBenchmark.main();
}
