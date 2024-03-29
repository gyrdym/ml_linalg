// Approx. 1.0 seconds (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const numOfRows = 20001;
const numOfColumns = 2001;

class Float32MatrixAddMatrixScalarBenchmark extends BenchmarkBase {
  Float32MatrixAddMatrixScalarBenchmark()
      : super('Matrix float32, matrix and scalar summation');

  final matrix =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 5);

  final other = 1234.55;

  static void main() {
    Float32MatrixAddMatrixScalarBenchmark().report();
  }

  @override
  void run() {
    matrix + other;
  }
}

void main() {
  Float32MatrixAddMatrixScalarBenchmark.main();
}
