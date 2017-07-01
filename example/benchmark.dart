import 'package:dart_vector/vector.dart';
import 'package:benchmark_harness/benchmark_harness.dart';

const int AMOUNT_OF_ELEMENTS = 10000000;

Vector vector1;
Vector vector2;

class VectorInitializationBenchmark extends BenchmarkBase {
  const VectorInitializationBenchmark() : super('Vector initialization, $AMOUNT_OF_ELEMENTS elements');

  static void main() {
    new VectorInitializationBenchmark().report();
  }

  void run() {
    vector1 = new Vector.from(new List<double>.filled(AMOUNT_OF_ELEMENTS, 1.0));
  }

  void tearDown() {
    vector1 = null;
  }
}

class VectorAdditionBenchmark extends BenchmarkBase {
  const VectorAdditionBenchmark() : super('Vectors addition, $AMOUNT_OF_ELEMENTS elements');

  static void main() {
    new VectorAdditionBenchmark().report();
  }

  void run() {
    vector1 + vector2;
  }

  void setup() {
    vector1 = new Vector.from(new List<double>.filled(AMOUNT_OF_ELEMENTS, 1.0));
    vector2 = new Vector.from(new List<double>.filled(AMOUNT_OF_ELEMENTS, 1.0));
  }

  void tearDown() {
    vector1 = null;
    vector2 = null;
  }
}