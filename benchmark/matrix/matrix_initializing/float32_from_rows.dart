// Approx. 3 seconds (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/matrix/float32/float32_matrix.dart';
import 'package:ml_linalg/vector.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class Float32x4MatrixFromRowsBenchmark extends BenchmarkBase {
  Float32x4MatrixFromRowsBenchmark() :
        super('Matrix initialization, from rows');

  List<Vector> _source;

  static void main() {
    Float32x4MatrixFromRowsBenchmark().report();
  }

  @override
  void run() {
    Float32Matrix.rows(_source);
  }

  @override
  void setup() {
    _source = List<Vector>.filled(numOfColumns, Vector.randomFilled(numOfRows));
  }
}

void main() {
  Float32x4MatrixFromRowsBenchmark.main();
}
