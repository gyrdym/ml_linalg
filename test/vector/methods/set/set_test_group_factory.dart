import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void vectorSetTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('set method', () {
        test(
            'should copy the source vector, set a value at an index, and return a new vector, the very beginning of the vector',
            () {
          final vector =
              Vector.fromList([10.0, 3.0, 4.0, 7.0, 9.0, 12.0], dtype: dtype);
          final actual = vector.set(0, 1001);

          expect(actual, equals([1001, 3.0, 4.0, 7.0, 9.0, 12.0]));
          expect(actual.dtype, dtype);
        });

        test(
            'should copy the source vector, set a value at an index, and return a new vector, the end of the vector',
            () {
          final vector =
              Vector.fromList([10.0, 3.0, 4.0, 7.0, 9.0, 12.0], dtype: dtype);
          final actual = vector.set(5, 2001);

          expect(actual, equals([10.0, 3.0, 4.0, 7.0, 9.0, 2001]));
        });

        test(
            'should copy the source vector, set a value at an index, and return a new vector, the middle of the vector',
            () {
          final vector =
              Vector.fromList([10.0, 3.0, 4.0, 7.0, 9.0, 12.0], dtype: dtype);
          final actual = vector.set(3, 3001);

          expect(actual, equals([10.0, 3.0, 4.0, 3001, 9.0, 12.0]));
        });

        test(
            'should throw an error if one tries to set a value at an outranged index',
            () {
          final vector =
              Vector.fromList([10.0, 3.0, 4.0, 7.0, 9.0, 12.0], dtype: dtype);
          final actual = () => vector.set(-3, 3001);

          expect(actual, throwsRangeError);
        });
      });
    });
