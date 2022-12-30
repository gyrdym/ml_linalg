// Approx. 0.3 sec (MacBook Pro 2019)

import 'dart:math';
import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';

const amountOfElements = 10000000 ~/ 4;

class RegularListsAdditionBenchmark extends BenchmarkBase {
  RegularListsAdditionBenchmark()
      : super('Regular lists addition; '
            '$amountOfElements elements');

  late Float32x4List list1;
  late Float32x4List list2;

  static void main() {
    RegularListsAdditionBenchmark().report();
  }

  @override
  void run() {
    final result = Float32x4List(amountOfElements);

    for (var i = 0; i < amountOfElements; i++) {
      result[i] = list1[i] + list2[i];
    }
  }

  @override
  void setup() {
    final generator = Random(13);

    list1 = Float32x4List.fromList(List.generate(
        amountOfElements,
        (_) => Float32x4(
            generator.nextDouble() * 2000 - 1000,
            generator.nextDouble() * 2000 - 1000,
            generator.nextDouble() * 2000 - 1000,
            generator.nextDouble() * 2000 - 1000)));

    list2 = Float32x4List.fromList(List.generate(
        amountOfElements,
        (_) => Float32x4(
            generator.nextDouble() * 2000 - 1000,
            generator.nextDouble() * 2000 - 1000,
            generator.nextDouble() * 2000 - 1000,
            generator.nextDouble() * 2000 - 1000)));
  }
}

void main() {
  RegularListsAdditionBenchmark.main();
}
