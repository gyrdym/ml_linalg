// Approx. 1.2 seconds (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

const rowCount = 10000;
const columnCount = 1000;

class Float32MatrixMapElementsBenchmark extends BenchmarkBase {
  Float32MatrixMapElementsBenchmark()
      : super('Matrix float32 mapElements method');

  final Matrix _source =
      Matrix.random(rowCount, columnCount, dtype: DType.float32, seed: 12);

  static void main() {
    Float32MatrixMapElementsBenchmark().report();
  }

  @override
  void run() {
    _source.mapElements((element) => element * 10.5);
  }
}

void main() {
  Float32MatrixMapElementsBenchmark.main();
}
