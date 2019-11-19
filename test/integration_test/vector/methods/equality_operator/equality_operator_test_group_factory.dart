import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorEqualityOperatorTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('== operator', () {
        test('should compare with another vector and return `true` if vectors '
            'are equal', () {
          final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final vector2 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);

          expect(vector1 == vector2, isTrue);
        });

        test('should compare with another vector and return `true` if vectors have '
            'only zero values', () {
          final vector1 = Vector.fromList([0.0, 0.0, 0.0, 0.0, 0.0], dtype: dtype);
          final vector2 = Vector.fromList([0.0, 0.0, 0.0, 0.0, 0.0], dtype: dtype);

          expect(vector1 == vector2, isTrue);
        });

        test('should compare with another vector and return `false` if vectors '
            'are different', () {
          final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final vector2 = Vector.fromList([1.0, 2.0, 30.0, 4.0, 5.0], dtype: dtype);

          expect(vector1 == vector2, isFalse);
        });

        test('should compare with another vector and return `false` if vectors have '
            'opposite values', () {
          final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final vector2 = Vector.fromList([-1.0, -2.0, -3.0, -4.0, -5.0], dtype: dtype);

          expect(vector1 == vector2, isFalse);
        });

        test('should compare with another vector and return `false` if one '
            'vector have all zero values', () {
          final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final vector2 = Vector.fromList([0.0, 0.0, 0.0, 0.0, 0.0], dtype: dtype);

          expect(vector1 == vector2, isFalse);
        });

        test('should compare with another vector and return `false` if vectors '
            'have different lengths', () {
          final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], dtype: dtype);
          final vector2 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);

          expect(vector1 == vector2, isFalse);
        });

        test('should compare with another object and return `false` if another '
            'object is not a vector', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], dtype: dtype);
          final other = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0];
          // ignore: unrelated_type_equality_checks
          expect(vector == other, isFalse);
        });
      });
    });
