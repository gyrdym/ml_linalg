import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../dtype_to_class_name_mapping.dart';

void vectorSubvectorTestGroupFactory(DType dtype) =>
    group(dtypeToVectorClassName[dtype], () {
      group('subvector', () {
        test('should cut out a subvector (`end` exclusive)', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0],
              dtype: dtype);
          final actual = vector.subvector(1, 4);
          final expected = [2.0, 3.0, 4.0];
          expect(actual, expected);
        });

        test('should cut out a subvector of length 1 if `start` is equal to the '
            'last index of the vector', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0],
              dtype: dtype);
          final actual = vector.subvector(4, 5);
          final expected = [5.0];
          expect(actual, expected);
        });

        test('should cut out rest of the vector if `end` is not specified', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 7.0],
              dtype: dtype);
          final actual = vector.subvector(1);
          final expected = [2.0, 3.0, 4.0, 5.0, 7.0];
          expect(actual, expected);
        });

        test('should cut out rest of the vector if `end` is specified and greater'
            'that the vector length', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 7.0],
              dtype: dtype);
          final actual = vector.subvector(1, 20);
          final expected = [2.0, 3.0, 4.0, 5.0, 7.0];
          expect(actual, expected);
        });

        test('should throw a range error if `start` is negative', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 7.0],
              dtype: dtype);
          final actual = () => vector.subvector(-1, 20);
          expect(actual, throwsRangeError);
        });

        test('should throw a range error if `start` is greater than `end`', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 7.0],
              dtype: dtype);
          final actual = () => vector.subvector(3, 2);
          expect(actual, throwsRangeError);
        });

        test('should throw a range error if `start` is equal to the `end`', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0],
              dtype: dtype);
          final actual = () => vector.subvector(4, 4);
          expect(actual, throwsRangeError);
        });
      });
    });
