// Approx. 1.1 seconds (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const numOfRows = 20001;
const numOfColumns = 2001;

class Float32MatrixDivMatrixMatrixBenchmark extends BenchmarkBase {
  Float32MatrixDivMatrixMatrixBenchmark()
      : super('Matrix float32, matrix by matrix division');

  final matrix =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 5);

  final other =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 6);

  static void main() {
    Float32MatrixDivMatrixMatrixBenchmark().report();
  }

  @override
  void run() {
    matrix / other;
  }
}

void main() {
  Float32MatrixDivMatrixMatrixBenchmark.main();
}
