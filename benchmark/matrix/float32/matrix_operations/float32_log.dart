// Approx. 10.3 second (MacBook Air mid 2017), Dart VM version: 2.7.2

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class Float32MatrixLogBenchmark extends BenchmarkBase {
  Float32MatrixLogBenchmark() : super('Matrix log method');

  final Matrix _source = Matrix.fromRows(
    List<Vector>.filled(numOfRows, Vector.randomFilled(
        numOfColumns, min: -1000, max: 1000)),
    dtype: DType.float32,
  );

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
