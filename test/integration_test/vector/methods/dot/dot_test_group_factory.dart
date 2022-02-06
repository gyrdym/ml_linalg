import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorDotTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('dot method', () {
        test('should perform dot product with another vector', () {
          final vector1 =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final vector2 =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);

          final result = vector1.dot(vector2);

          expect(result, equals(55.0));
        });
      });
    });
