// Approx. 0.6 seconds (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/axis.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const numOfRows = 20001;
const numOfColumns = 2001;

class Float32MatrixMeanBenchmark extends BenchmarkBase {
  Float32MatrixMeanBenchmark() : super('Matrix float32, matrix mean');

  final Matrix _source =
      Matrix.random(numOfRows, numOfColumns, dtype: DType.float32, seed: 12);

  static void main() {
    Float32MatrixMeanBenchmark().report();
  }

  @override
  void run() {
    _source.mean(Axis.rows);
  }
}

void main() {
  Float32MatrixMeanBenchmark.main();
}
