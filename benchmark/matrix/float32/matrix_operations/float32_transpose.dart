// Approx. 3 second (MacBook Air mid 2017), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const numOfRows = 5000;
const numOfColumns = 5000;

class Float32MatrixTransposeBenchmark extends BenchmarkBase {
  Float32MatrixTransposeBenchmark() : super('Matrix float32 transpose method');

  final Matrix source =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 12);

  static void main() {
    Float32MatrixTransposeBenchmark().report();
  }

  @override
  void run() {
    source.transpose();
  }
}

void main() {
  Float32MatrixTransposeBenchmark.main();
}
