// Approx. 11 seconds (MacBook Pro 2019), Dart version: 2.16.0
// Approx. 23 seconds (MacBook Air mid 2017), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/decomposition.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const numOfRows = 1000;
const numOfColumns = 1000;

class Float32MatrixDecomposeLUBenchmark extends BenchmarkBase {
  Float32MatrixDecomposeLUBenchmark()
      : super('Matrix float32 decompose method (LU)');

  final Matrix source =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 5);

  static void main() {
    Float32MatrixDecomposeLUBenchmark().report();
  }

  @override
  void run() {
    source.decompose(Decomposition.LU);
  }
}

void main() {
  Float32MatrixDecomposeLUBenchmark.main();
}
