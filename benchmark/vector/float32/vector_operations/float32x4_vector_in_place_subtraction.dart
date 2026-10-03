// Approx. 0.1 seconds (MacBook Pro 2019), Dart version: 3.12.2

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const _amountOfElements = 1e8;

class Float32x4VectorInPlaceSubtractionBenchmark extends BenchmarkBase {
  Float32x4VectorInPlaceSubtractionBenchmark()
      : super('Vector subtractInPlace, operands: vector32, zero vector32; '
            '$_amountOfElements elements');

  late Vector vector;
  late Vector zeroVector;

  static void main() {
    Float32x4VectorInPlaceSubtractionBenchmark().report();
  }

  @override
  void exercise() => run();

  @override
  void run() {
    vector.subtractInPlace(zeroVector);
  }

  @override
  void setup() {
    vector = Vector.randomFilled(
      _amountOfElements.toInt(),
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    );
    zeroVector = Vector.zero(_amountOfElements.toInt(), dtype: DType.float32);
  }
}

void main() {
  Float32x4VectorInPlaceSubtractionBenchmark.main();
}
