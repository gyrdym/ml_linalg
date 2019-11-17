import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/norm.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorNormTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('norm method', () {
        test('should find vector norm', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0],
              dtype: dtype);

          expect(vector.norm(Norm.euclidean), equals(closeTo(7.41, 1e-2)));
          expect(vector.norm(Norm.manhattan), equals(15.0));
        });
      });
    });
