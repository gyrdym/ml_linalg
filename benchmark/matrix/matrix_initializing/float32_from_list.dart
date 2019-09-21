// Approx. 2.2 second (MacBook Air mid 2017)

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/matrix/float32/float32_matrix.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class Float32x4MatrixFromListBenchmark extends BenchmarkBase {
  const Float32x4MatrixFromListBenchmark() :
        super('Matrix initialization, from list');

  static void main() {
    const Float32x4MatrixFromListBenchmark().report();
  }

  @override
  void run() {
    Float32Matrix.fromList(List<List<double>>.filled(numOfRows,
        List<double>.filled(numOfColumns, 1.0)));
  }
}

void main() {
  Float32x4MatrixFromListBenchmark.main();
}
