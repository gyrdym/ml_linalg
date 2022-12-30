import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/common/dtype_serializer/dtype_to_json.dart';
import 'package:ml_linalg/src/matrix/serialization/matrix_json_keys.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixFromJsonTestGroupFactory(DType dtype) {
  group(dtypeToMatrixTestTitle[dtype], () {
    group('fromJson constructor', () {
      final data = <List<double>>[
        [928, -1009, 29735, 7, 987, 30, 12],
        [901, -7, 10e3, 0, 0, -1000, 99],
      ];

      final emptyData = <List<double>>[];

      final serializableMap = {
        matrixDTypeJsonKey: dTypeToJson(dtype),
        matrixDataJsonKey: data,
      };

      final serializableMapWithEmptyData = {
        matrixDTypeJsonKey: dTypeToJson(dtype),
        matrixDataJsonKey: emptyData,
      };

      test('should create a matrix from serializable map', () {
        final matrix = Matrix.fromJson(serializableMap);

        expect(matrix.dtype, dtype);
        expect(matrix, data);
      });

      test('should create a matrix from serializable map containing empty data',
          () {
        final matrix = Matrix.fromJson(serializableMapWithEmptyData);

        expect(matrix.dtype, dtype);
        expect(matrix, emptyData);
      });
    });
  });
}
