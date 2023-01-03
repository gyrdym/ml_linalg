// Approx. 2.0 seconds (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const rowCount = 10000;
const columnCount = 1000;

class Float32MatrixPowFloatBenchmark extends BenchmarkBase {
  Float32MatrixPowFloatBenchmark()
      : super('Matrix float32 pow (float exponent) method');

  final Matrix _source =
      Matrix.random(rowCount, columnCount, dtype: DType.float32, seed: 12);

  static void main() {
    Float32MatrixPowFloatBenchmark().report();
  }

  @override
  void run() {
    _source.pow(133.6);
  }
}

void main() {
  Float32MatrixPowFloatBenchmark.main();
}
