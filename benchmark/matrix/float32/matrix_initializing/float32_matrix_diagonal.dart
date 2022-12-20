// Approx. 3 seconds (MacBook Air mid 2017), Dart VM version: 2.5.0
// Approx. 0.25 second (MacBook Pro mid 2019), Dart VM version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

const size = 10000;

class Float32MatrixDiagonalBenchmark extends BenchmarkBase {
  Float32MatrixDiagonalBenchmark() : super('Matrix initialization (diagonal)');

  late List<double> _source;

  static void main() {
    Float32MatrixDiagonalBenchmark().report();
  }

  @override
  void run() {
    Matrix.diagonal(_source, dtype: DType.float32);
  }

  @override
  void setup() {
    _source = Vector.randomFilled(size, seed: 12).toList();
  }
}

void main() {
  Float32MatrixDiagonalBenchmark.main();
}
