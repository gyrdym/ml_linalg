// Approx. 0.7 seconds (MacBook Pro 2019), Dart version: 3.10.7

import 'dart:math';
import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';

const amountOfElements = 1e8;

class RegularListsAdditionBenchmark extends BenchmarkBase {
  RegularListsAdditionBenchmark()
      : super('Regular lists addition; '
            '$amountOfElements elements');

  late Float32List list1;
  late Float32List list2;

  static void main() {
    RegularListsAdditionBenchmark().report();
  }

  @override
  void exercise() => run();

  @override
  void run() {
    final result = Float32List(amountOfElements.toInt());

    for (var i = 0; i < amountOfElements; i++) {
      result[i] = list1[i] + list2[i];
    }
  }

  @override
  void setup() {
    final generator = Random(13);

    list1 = Float32List.fromList(List.generate(
        amountOfElements.toInt(), (_) => generator.nextDouble() * 2000 - 1000));

    list2 = Float32List.fromList(List.generate(
        amountOfElements.toInt(), (_) => generator.nextDouble() * 2000 - 1000));
  }
}

void main() {
  RegularListsAdditionBenchmark.main();
}
