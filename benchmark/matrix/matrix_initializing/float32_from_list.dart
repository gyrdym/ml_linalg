// Approx. 2.2 second (MacBook Air mid 2017), Dart VM version: 2.5.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/src/matrix/float32/float32_matrix.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class Float32x4MatrixFromListBenchmark extends BenchmarkBase {
  Float32x4MatrixFromListBenchmark() :
        super('Matrix initialization, from list');

  final _source = List.filled(numOfRows,
      Vector
          .randomFilled(numOfColumns, min: -10000, max: 10000)
          .toList(),
  );

  static void main() {
    Float32x4MatrixFromListBenchmark().report();
  }

  @override
  void run() {
    Float32Matrix.fromList(_source);
  }
}

void main() {
  Float32x4MatrixFromListBenchmark.main();
}
