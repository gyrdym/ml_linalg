// Approx. 4.5 seconds (MacBook Air mid 2017), Dart VM version: 2.5.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class Float32MatrixFromFlattenedBenchmark extends BenchmarkBase {
  Float32MatrixFromFlattenedBenchmark() :
        super('Matrix initialization, from flattened list');

  List<double> _source;

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
    _source = Vector.randomFilled(numOfRows * numOfColumns)
        .toList(growable: false);
  }
}

void main() {
  Float32MatrixFromFlattenedBenchmark.main();
}
