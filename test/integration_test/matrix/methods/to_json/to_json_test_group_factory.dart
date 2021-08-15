import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/common/dtype_serializer/dtype_to_json.dart';
import 'package:ml_linalg/src/matrix/serialization/matrix_json_keys.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void toJsonTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('toJson method', () {
        test('should return a serializable map', () {
          final source = [
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, .0, -2.0, -3.0],
          ];
          final matrix = Matrix.fromList(source, dtype: dtype);
          final actual = matrix.toJson();
          final expected = {
            matrixDTypeJsonKey: dTypeToJson(dtype),
            matrixDataJsonKey: source,
          };

          expect(actual, expected);
        });
      });
    });
