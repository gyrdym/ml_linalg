// Approx. 7.5 second (MacBook Air mid 2017), Dart version: 2.16.0
// Approx. 0.4 seconds (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const numOfRows = 10000;
const numOfColumns = 10000;

class Float32MatrixSumBenchmark extends BenchmarkBase {
  Float32MatrixSumBenchmark() : super('Matrix float32 sum method');

  final Matrix _source =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 12);

  static void main() {
    Float32MatrixSumBenchmark().report();
  }

  @override
  void run() {
    _source.sum();
  }
}

void main() {
  Float32MatrixSumBenchmark.main();
}
