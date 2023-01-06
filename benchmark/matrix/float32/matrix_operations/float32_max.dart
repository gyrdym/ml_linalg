// Approx. 0.4 seconds (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const numOfRows = 20001;
const numOfColumns = 20001;

class Float32MatrixMaxBenchmark extends BenchmarkBase {
  Float32MatrixMaxBenchmark() : super('Matrix float32 max method');

  final Matrix _source =
  Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 12);

  static void main() {
    Float32MatrixMaxBenchmark().report();
  }

  @override
  void run() {
    _source.max();
  }
}

void main() {
  Float32MatrixMaxBenchmark.main();
}
