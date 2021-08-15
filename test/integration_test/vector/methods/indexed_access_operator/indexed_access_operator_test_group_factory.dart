import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorIndexedAccessOperatorTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('[] operator', () {
        test('should provide indexed access ([] operator, case 1)', () {
          final vector =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);

          expect(vector[0], 1.0);
          expect(vector[1], 2.0);
          expect(vector[2], 3.0);
          expect(vector[3], 4.0);
          expect(vector[4], 5.0);

          expect(() => vector[-1], throwsRangeError);
          expect(() => vector[5], throwsRangeError);
          expect(() => vector[100], throwsRangeError);
        });

        test('should provide indexed access ([] operator, case 2)', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0], dtype: dtype);

          expect(vector[0], 1.0);
          expect(vector[1], 2.0);
          expect(vector[2], 3.0);
          expect(vector[3], 4.0);

          expect(() => vector[-1], throwsRangeError);
          expect(() => vector[4], throwsRangeError);
          expect(() => vector[100], throwsRangeError);
        });

        test('should provide indexed access ([] operator, case 3)', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0], dtype: dtype);

          expect(vector[0], 1.0);
          expect(vector[1], 2.0);
          expect(vector[2], 3.0);

          expect(() => vector[-1], throwsRangeError);
          expect(() => vector[3], throwsRangeError);
          expect(() => vector[100], throwsRangeError);
        });

        test('should provide indexed access ([] operator, case 4)', () {
          final vector = Vector.fromList([1.0, 2.0], dtype: dtype);

          expect(vector[0], 1.0);
          expect(vector[1], 2.0);

          expect(() => vector[-1], throwsRangeError);
          expect(() => vector[2], throwsRangeError);
          expect(() => vector[100], throwsRangeError);
        });

        test('should provide indexed access ([] operator, case 5)', () {
          final vector = Vector.fromList([1.0], dtype: dtype);

          expect(vector[0], 1.0);

          expect(() => vector[-1], throwsRangeError);
          expect(() => vector[1], throwsRangeError);
          expect(() => vector[100], throwsRangeError);
        });
      });
    });
