import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void vectorFromListConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('fromList constructor', () {
        test('should create a vector from dynamic-length list, length is '
            'greater than 4', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], dtype: dtype);

          expect(vector, equals([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]));
          expect(vector.length, equals(6));
          expect(vector.dtype, dtype);
        });

        test('should create a vector from dynamic-length list, length is less '
            'than 4', () {
          final vector = Vector.fromList([1.0, 2.0], dtype: dtype);

          expect(vector, equals([1.0, 2.0]));
          expect(vector.length, equals(2));
          expect(vector.dtype, dtype);
        });

        test('should create a vector from fixed-length list, length is greater '
            'than 4', () {
          final vector = Vector.fromList(List.filled(11, 1.0), dtype: dtype);

          expect(vector,
              equals([1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]));
          expect(vector.length, 11);
          expect(vector.dtype, dtype);
        });

        test('should create a vector from fixed-length list, length is less '
            'than 4', () {
          final vector = Vector.fromList(List.filled(1, 2.0), dtype: dtype);

          expect(vector, equals([2.0]));
          expect(vector.length, 1);
          expect(vector.dtype, dtype);
        });

        test('should create a vector from an empty list', () {
          final vector = Vector.fromList([], dtype: dtype);

          expect(vector, equals(<double>[]));
          expect(vector.length, 0);
          expect(vector.dtype, dtype);
        });
      });
    });
