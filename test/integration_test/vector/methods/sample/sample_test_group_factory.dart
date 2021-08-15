import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorSampleTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('sample method', () {
        test(
            'should create a vector using elements on specific inidces from '
            'given list', () {
          final vector =
              Vector.fromList([10.0, 3.0, 4.0, 7.0, 9.0, 12.0], dtype: dtype);
          final sampled = vector.sample([1, 1, 0, 3]);

          expect(sampled, equals([3.0, 3.0, 10.0, 7.0]));
          expect(() => vector.sample([20, 0, 1]), throwsRangeError);
          expect(sampled.dtype, dtype);
        });
      });
    });
