// Approx. 2.5 second (MacBook Air mid 2017), Dart VM version: 2.5.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class Float32MatrixFromColumnsBenchmark extends BenchmarkBase {
  Float32MatrixFromColumnsBenchmark() :
        super('Matrix initialization (fromColumns)');

  late List<Vector> _source;

  static void main() {
    Float32MatrixFromColumnsBenchmark().report();
  }

  @override
  void run() {
    Matrix.fromColumns(_source, dtype: DType.float32);
  }

  @override
  void setup() {
    _source = List<Vector>.filled(numOfColumns, Vector.randomFilled(numOfRows));
  }
}

void main() {
  Float32MatrixFromColumnsBenchmark.main();
}
