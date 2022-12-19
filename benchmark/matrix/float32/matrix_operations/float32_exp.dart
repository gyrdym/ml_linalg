// Approx. 7 seconds (MacBook Air mid 2017), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class Float32MatrixExpBenchmark extends BenchmarkBase {
  Float32MatrixExpBenchmark() : super('Matrix float32 exp method');

  final Matrix _source =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 12);

  static void main() {
    Float32MatrixExpBenchmark().report();
  }

  @override
  void run() {
    _source.exp(skipCaching: true);
  }
}

void main() {
  Float32MatrixExpBenchmark.main();
}
