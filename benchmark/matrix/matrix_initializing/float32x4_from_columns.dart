// It takes approximately 11.8 second (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/matrix/float32x4_matrix.dart';
import 'package:ml_linalg/vector.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class Float32x4MatrixFromColumnsBenchmark extends BenchmarkBase {
  Float32x4MatrixFromColumnsBenchmark() :
        super('Matrix initialization, from columns');

  List<Vector> _source;

  static void main() {
    Float32x4MatrixFromColumnsBenchmark().report();
  }

  @override
  void run() {
    Float32x4Matrix.columns(_source);
  }

  @override
  void setup() {
    _source = List<Vector>.filled(numOfColumns, Vector.randomFilled(numOfRows));
  }
}

void main() {
  Float32x4MatrixFromColumnsBenchmark.main();
}
