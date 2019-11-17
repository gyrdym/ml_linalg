import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorUniqueTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('unique method', () {
        test('`unique` method', () {
          final vector = Vector.fromList([
            10.0,
            3.0,
            4.0,
            0.0,
            7.0,
            4.0,
            12.0,
            3.0,
            12.0,
            9.0,
            0.0,
            12.0,
            10.0,
            3.0
          ], dtype: dtype);

          final unique = vector.unique();

          expect(unique, equals([10.0, 3.0, 4.0, 0.0, 7.0, 12.0, 9.0]));
          expect(unique.dtype, dtype);
        });
      });
    });
