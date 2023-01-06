// Approx. 0.5 seconds (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const numOfRows = 10000;
const numOfColumns = 10000;

class Float32MatrixProdBenchmark extends BenchmarkBase {
  Float32MatrixProdBenchmark() : super('Matrix float32 prod method');

  final Matrix _source =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 12);

  static void main() {
    Float32MatrixProdBenchmark().report();
  }

  @override
  void run() {
    _source.prod();
  }
}

void main() {
  Float32MatrixProdBenchmark.main();
}
