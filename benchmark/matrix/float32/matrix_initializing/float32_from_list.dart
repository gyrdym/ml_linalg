// Approx. 0.9 second (MacBook Air mid 2017), Dart VM version: 2.5.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class Float32MatrixFromListBenchmark extends BenchmarkBase {
  Float32MatrixFromListBenchmark() :
        super('Matrix initialization, from list');

  final _source = List.filled(numOfRows,
      Vector
          .randomFilled(numOfColumns, min: -10000, max: 10000)
          .toList(),
  );

  static void main() {
    Float32MatrixFromListBenchmark().report();
  }

  @override
  void run() {
    Matrix.fromList(_source, dtype: DType.float32);
  }
}

void main() {
  Float32MatrixFromListBenchmark.main();
}
