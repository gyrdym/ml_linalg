// Approx. 0.1 second (MacBook Pro 2019), Dart version: 3.12.2

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

const _amountOfElements = 1e8;

class Float32x4VectorInPlaceAdditionBenchmark extends BenchmarkBase {
  Float32x4VectorInPlaceAdditionBenchmark()
      : super('VectorBuffer.add, operands: vector32, zero vector32; '
            '$_amountOfElements elements');

  late VectorBuffer vector;
  late Vector zeroVector;

  static void main() {
    Float32x4VectorInPlaceAdditionBenchmark().report();
  }

  @override
  void exercise() => run();

  @override
  void run() {
    vector.add(zeroVector);
  }

  @override
  void setup() {
    vector = Vector.randomFilled(
      _amountOfElements.toInt(),
      seed: 1,
      min: -1000,
      max: 1000,
      dtype: DType.float32,
    ).toBuffer();
    zeroVector = Vector.zero(_amountOfElements.toInt(), dtype: DType.float32);
  }
}

void main() {
  Float32x4VectorInPlaceAdditionBenchmark.main();
}
