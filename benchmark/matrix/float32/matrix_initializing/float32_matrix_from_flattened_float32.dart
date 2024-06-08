// Approx. 86 microsecond (MacBook Pro mid 2019), Dart VM version: 3.2.4

import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class Float32MatrixFromFlattenedFloat32ListBenchmark extends BenchmarkBase {
  Float32MatrixFromFlattenedFloat32ListBenchmark()
      : super(
            'Matrix initialization (fromFlattenedList, source list is Float32List)');

  late Float32List _source;

  static void main() {
    Float32MatrixFromFlattenedFloat32ListBenchmark().report();
  }

  @override
  void run() {
    Matrix.fromFlattenedList(_source, numOfRows, numOfColumns,
        dtype: DType.float32);
  }

  @override
  void setup() {
    _source = Float32List.fromList(Vector.randomFilled(numOfRows * numOfColumns,
            min: -1000, max: 1000, seed: 12)
        .toList(growable: false));
  }
}

void main() {
  Float32MatrixFromFlattenedFloat32ListBenchmark.main();
}
