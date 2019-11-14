import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void vectorRandomFilledConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('randomFilled constructor', () {
        test('should create a vector filled with random values from range'
            '[-5; -1)', () {
          final vector = Vector.randomFilled(200, seed: 1, min: -5, max: -1,
              dtype: dtype);

          for (final element in vector) {
            expect(element, inClosedOpenRange(-5, -1));
          }
        });

        test('should create a vector filled with random values from range'
            '[-5; 10)', () {
          final vector = Vector.randomFilled(200, seed: 1, min: -5, max: 10,
              dtype: dtype);
          for (final element in vector) {
            expect(element, inClosedOpenRange(-5, 10));
          }
        });

        test('should throw an argument error if `min` argument equals '
            '`max`', () {
          expect(() => Vector.randomFilled(200, seed: 1, min: 2, max: 2,
              dtype: dtype), throwsArgumentError);
        });

        test('should throw an argument error if `min` argument greater that '
            '`max`', () {
          expect(() => Vector.randomFilled(200, seed: 1, min: 3, max: 2,
              dtype: dtype), throwsArgumentError);
        });
      });
    });
