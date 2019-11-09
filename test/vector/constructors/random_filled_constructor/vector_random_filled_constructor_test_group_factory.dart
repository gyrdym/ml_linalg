import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_class_name_mapping.dart';

void vectorRandomFilledConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToVectorClassName[dtype], () {
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

        test('should create a vector filled with random values from range'
            '[-5; -1) (min is greater than max)', () {
          final vector = Vector.randomFilled(200, seed: 1, min: -1, max: -5,
              dtype: dtype);
          for (final element in vector) {
            expect(element, inClosedOpenRange(-5, -1));
          }
        });

        test('should create a vector filled with constant value if min equals '
            'max', () {
          final vector = Vector.randomFilled(200, seed: 1, min: 2, max: 2,
              dtype: dtype);
          for (final element in vector) {
            expect(element, equals(2));
          }
        });
      });
    });