// Approx. 4.7 seconds (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/matrix/float32/float32_matrix.dart';
import 'package:ml_linalg/vector.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class Float32x4MatrixFromFlattenedBenchmark extends BenchmarkBase {
  Float32x4MatrixFromFlattenedBenchmark() :
        super('Matrix initialization, from rows');

  List<double> _source;

  static void main() {
    Float32x4MatrixFromFlattenedBenchmark().report();
  }

  @override
  void run() {
    Float32Matrix.flattened(_source, numOfRows, numOfColumns);
  }

  @override
  void setup() {
    _source = Vector.randomFilled(numOfRows * numOfColumns)
        .toList(growable: false);
  }
}

void main() {
  Float32x4MatrixFromFlattenedBenchmark.main();
}
