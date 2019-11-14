import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void main() {
  group(dtypeToVectorTestTitle[DType.float32], () {
    group('fastMap method', () {
      test('should map an existing vector to a new one processing 4 elements in '
          'a time', () {
        final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0],
            dtype: DType.float32);

        int iteration = 0;

        final actual = vector.fastMap((Float32x4 element) {
          iteration++;
          return element.scale(3.0);
        });

        final expected = [3.0, 6.0, 9.0, 12.0, 15.0, 18.0];

        expect(iteration, equals(2));
        expect(actual, equals(expected));
      });
    });
  });

  group(dtypeToVectorTestTitle[DType.float64], () {
    group('fastMap method', () {
      test('should map an existing vector to a new one processing 2 elements in '
          'a time', () {
        final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 9.0],
            dtype: DType.float64);

        int iteration = 0;

        final actual = vector.fastMap((Float64x2 element) {
          iteration++;
          return element.scale(3.0);
        });

        final expected = [3.0, 6.0, 9.0, 12.0, 15.0, 18.0, 27.0];

        expect(iteration, equals(4));
        expect(actual, equals(expected));
      });
    });
  });
}
