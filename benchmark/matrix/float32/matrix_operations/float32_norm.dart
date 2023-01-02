// Approx. 0.6 seconds (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const numOfRows = 10001;
const numOfColumns = 10001;

class Float32MatrixNormBenchmark extends BenchmarkBase {
  Float32MatrixNormBenchmark() : super('Matrix float32 norm method');

  final Matrix _source =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 12);

  static void main() {
    Float32MatrixNormBenchmark().report();
  }

  @override
  void run() {
    _source.norm();
  }
}

void main() {
  Float32MatrixNormBenchmark.main();
}
