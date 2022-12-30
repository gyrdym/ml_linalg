import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';
import 'dart:math' as math;

import '../../../dtype_to_title.dart';

void vectorLogVectorTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('log method', () {
        test(
            'should return vector composed of natural logs of the source '
            'vector elements', () {
          final vector =
              Vector.fromList([10.0, 12.0, 4.0, 7.0, 9.0, 12.0], dtype: dtype);
          final actual = vector.log();

          expect(actual, [
            closeTo(math.log(10), 1e-3),
            closeTo(math.log(12), 1e-3),
            closeTo(math.log(4), 1e-3),
            closeTo(math.log(7), 1e-3),
            closeTo(math.log(9), 1e-3),
            closeTo(math.log(12), 1e-3),
          ]);
          expect(actual.dtype, dtype);
        });

        test('should return empty vector if the source one is empty', () {
          final vector = Vector.fromList([], dtype: dtype);
          final actual = vector.log();

          expect(actual, <double>[]);
          expect(actual.dtype, dtype);
        });
      });
    });
