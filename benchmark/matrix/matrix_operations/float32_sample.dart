// Approx. 6.3 second (MacBook Air mid 2017), Dart VM version: 2.5.0

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/src/matrix/float32/float32_matrix.dart';
import 'package:ml_linalg/vector.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class Float32x4MatrixSampleBenchmark extends BenchmarkBase {
  Float32x4MatrixSampleBenchmark() : super('Matrix sample method');

  final Float32Matrix _source = Float32Matrix.rows(
      List<Vector>.filled(numOfRows, Vector.randomFilled(numOfColumns))
  );

  final _rowIndices = Vector
      .randomFilled(numOfRows, min: 0, max: numOfRows)
      .map((el) => el.floor())
      .toList();

  final _columnIndices = Vector
      .randomFilled(numOfColumns, min: 0, max: numOfColumns)
      .map((el) => el.floor())
      .toList();

  static void main() {
    Float32x4MatrixSampleBenchmark().report();
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
  Float32x4MatrixSampleBenchmark.main();
}
