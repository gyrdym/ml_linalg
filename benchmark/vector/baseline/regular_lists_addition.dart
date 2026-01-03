// Approx. 11 sec (MacBook Pro 2019), Dart version: 3.10.7

import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';

const amountOfElements = 1e8;

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
    final result = List.generate(amountOfElements.toInt(), (i) => 0.0);

    for (var i = 0; i < amountOfElements; i++) {
      result[i] = list1[i] + list2[i];
    }
  }

  @override
  void setup() {
    final generator = Random(13);

    list1 = List.generate(
        amountOfElements.toInt(), (_) => generator.nextDouble() * 2000 - 1000);

    list2 = List.generate(
        amountOfElements.toInt(), (_) => generator.nextDouble() * 2000 - 1000);
  }
}

void main() {
  RegularListsAdditionBenchmark.main();
}
