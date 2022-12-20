// Approx. 1 second (MacBook Air mid 2017), Dart VM version: 2.5.0
// Approx. 0.6 second (MacBook Pro mid 2019), Dart VM version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class Float32MatrixFromListBenchmark extends BenchmarkBase {
  Float32MatrixFromListBenchmark() : super('Matrix initialization (fromList)');

  final _source = List.filled(
    numOfRows,
    Vector.randomFilled(numOfColumns, min: -10000, max: 10000, seed: 12)
        .toList(growable: false),
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
