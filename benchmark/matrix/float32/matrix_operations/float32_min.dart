// Approx. 1.9 seconds (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const numOfRows = 20001;
const numOfColumns = 20001;

class Float32MatrixMinBenchmark extends BenchmarkBase {
  Float32MatrixMinBenchmark() : super('Matrix float32 min method');

  final Matrix _source =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 12);

  static void main() {
    Float32MatrixMinBenchmark().report();
  }

  @override
  void run() {
    _source.min();
  }
}

void main() {
  Float32MatrixMinBenchmark.main();
}
