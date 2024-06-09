// Approx. 12 sec (MacBook Pro 2019)
// Approx. 14 sec (MacBook Air mid 2017)

import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';

const amountOfElements = 100000000;

class RegularListsAdditionBenchmark extends BenchmarkBase {
  RegularListsAdditionBenchmark()
      : super('Regular lists addition; '
            '$amountOfElements elements');

  late List<double> list1;
  late List<double> list2;

  static void main() {
    RegularListsAdditionBenchmark().report();
  }

  @override
  void exercise() => run();

  @override
  void run() {
    final result = List.generate(amountOfElements, (i) => 0.0);

    for (var i = 0; i < amountOfElements; i++) {
      result[i] = list1[i] + list2[i];
    }
  }

  @override
  void setup() {
    final generator = Random(13);

    list1 = List.generate(
        amountOfElements, (_) => generator.nextDouble() * 2000 - 1000);

    list2 = List.generate(
        amountOfElements, (_) => generator.nextDouble() * 2000 - 1000);
  }
}

void main() {
  RegularListsAdditionBenchmark.main();
}
