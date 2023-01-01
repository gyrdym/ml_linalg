// Approx. 3.5 second (MacBook Air mid 2017), Dart version: 2.16.0
// Approx. 0.95 seconds (MacBook Pro 2019), Dart version: 2.16.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

const rowCount = 10000;
const columnCount = 1000;

class Float32MatrixSampleBenchmark extends BenchmarkBase {
  Float32MatrixSampleBenchmark() : super('Matrix sample method');

  final Matrix _source =
      Matrix.random(rowCount, columnCount, dtype: DType.float32, seed: 5);

  final _rowIndices =
      Vector.randomFilled(rowCount, min: 0, max: rowCount, seed: 6)
          .map((el) => el.floor())
          .toList();

  final _columnIndices =
      Vector.randomFilled(columnCount, min: 0, max: columnCount, seed: 7)
          .map((el) => el.floor())
          .toList();

  static void main() {
    Float32MatrixSampleBenchmark().report();
  }

  @override
  void run() {
    _source.sample(
      rowIndices: _rowIndices,
      columnIndices: _columnIndices,
    );
  }
}

void main() {
  Float32MatrixSampleBenchmark.main();
}
