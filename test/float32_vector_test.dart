import 'package:ml_linalg/linalg.dart';
import 'package:test/test.dart';

void main() {
  group('Float32Vector', () {
    test('`unique` method', () {
      final vector = Vector.fromList([
        10.0,
        3.0,
        4.0,
        0.0,
        7.0,
        4.0,
        12.0,
        3.0,
        12.0,
        9.0,
        0.0,
        12.0,
        10.0,
        3.0
      ]);
      final unique = vector.unique();
      expect(unique, equals([10.0, 3.0, 4.0, 0.0, 7.0, 12.0, 9.0]));
    });
  });
}
