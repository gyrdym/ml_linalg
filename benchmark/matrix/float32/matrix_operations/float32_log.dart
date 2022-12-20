// Approx. 7.5 second (MacBook Air mid 2017), Dart version: 2.16.0
// Approx. 3.2 seconds (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class Float32MatrixLogBenchmark extends BenchmarkBase {
  Float32MatrixLogBenchmark() : super('Matrix float32 log method');

  final Matrix _source =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 12);

  static void main() {
    Float32MatrixLogBenchmark().report();
  }

  @override
  void run() {
    _source.log(skipCaching: true);
  }
}

void main() {
  Float32MatrixLogBenchmark.main();
}
