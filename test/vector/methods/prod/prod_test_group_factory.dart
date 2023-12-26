import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void vectorProdTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('prod method', () {
        test('should multiply all the vector elements, case 1', () {
          final vector =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          expect(vector.prod(), 120);
        });

        test('should multiply all the vector elements, case 2', () {
          final vector = Vector.fromList([-1.0, 20.0, 4.5], dtype: dtype);
          expect(vector.prod(), -90);
        });

        test('should handle a vector of just one element', () {
          final vector = Vector.fromList([-1034.5], dtype: dtype);
          expect(vector.prod(), -1034.5);
        });

        test('should handle a vector with zeroes', () {
          final vector =
              Vector.fromList([1.0, 2.0, 3.0, 0.0, 4.0, 5.0], dtype: dtype);
          expect(vector.prod(), 0.0);
        });

        test('should handle a vector with all zero values', () {
          final vector = Vector.fromList([0.0, 0.0, 0.0], dtype: dtype);
          expect(vector.prod(), 0.0);
        });

        test('should return nan in case of empty vector', () {
          final vector = Vector.fromList([], dtype: dtype);
          expect(vector.prod(), isNaN);
        });

        test('should extract value from cache', () {
          final vector =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);

          final sum = vector.sum();
          final prod = vector.prod();
          final prod2 = vector.prod();

          expect(prod, prod2);
          expect(prod, isNot(sum));
        });
      });
    });
