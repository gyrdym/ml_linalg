import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/vector/exception/empty_vector_exception.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorMedianTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('median method', () {
        test('should find the median value, case 1', () {
          final vector = Vector.fromList([10, 12, 4, 7, 9, 12], dtype: dtype);
          // 4, 7, 9, 10, 12, 12

          expect(vector.median(), 9.5);
        });

        test('should find the median value, case 2', () {
          final vector =
              Vector.fromList([10, 12, 4, 7, 9, 12, 34], dtype: dtype);
          // 4, 7, 9, 10, 12, 12, 34

          expect(vector.median(), 10);
        });

        test('should find the median value, case 3', () {
          final vector =
              Vector.fromList([10, -12, 4, 0, 9, 12, -34], dtype: dtype);
          // -34, -12, 0, 4, 9, 10, 12

          expect(vector.median(), 4);
        });

        test('should find the median value, all elements are the same', () {
          final vector = Vector.fromList([1, 1, 1, 1, 1, 1, 1], dtype: dtype);

          expect(vector.median(), 1);
        });

        test('should find the median value, all elements are zeroes', () {
          final vector = Vector.fromList([0, 0, 0, 0, 0, 0, 0], dtype: dtype);

          expect(vector.median(), 0);
        });

        test('should find the median value, single element vector case', () {
          final vector = Vector.fromList([25], dtype: dtype);

          expect(vector.median(), 25);
        });

        test('should throw an error in case of empty vector', () {
          final vector = Vector.fromList([], dtype: dtype);

          expect(() => vector.median(), throwsA(isA<EmptyVectorException>()));
        });

        test('should not mutate the source vector', () {
          final vector =
              Vector.fromList([10, 12, 4, 7, 9, 12, 34], dtype: dtype);

          vector.median();

          expect(vector, [10, 12, 4, 7, 9, 12, 34]);
        });
      });
    });
