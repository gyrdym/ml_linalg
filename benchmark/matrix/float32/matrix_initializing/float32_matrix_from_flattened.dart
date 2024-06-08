// Approx. 2.8 seconds (MacBook Air mid 2017), Dart VM version: 2.5.0
// Approx. 0.6 second (MacBook Pro mid 2019), Dart VM version: 3.2.4

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class Float32MatrixFromFlattenedBenchmark extends BenchmarkBase {
  Float32MatrixFromFlattenedBenchmark()
      : super('Matrix initialization (fromFlattenedList)');

  late List<double> _source;

  static void main() {
    Float32MatrixFromFlattenedBenchmark().report();
  }

  @override
  void run() {
    Matrix.fromFlattenedList(_source, numOfRows, numOfColumns,
        dtype: DType.float32);
  }

  @override
  void setup() {
    _source = Vector.randomFilled(numOfRows * numOfColumns,
            min: -1000, max: 1000, seed: 12)
        .toList(growable: false);
  }
}

void main() {
  Float32MatrixFromFlattenedBenchmark.main();
}
