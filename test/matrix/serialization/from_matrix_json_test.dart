import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/common/dtype_serializer/dtype_encoded_values.dart';
import 'package:ml_linalg/src/matrix/serialization/from_matrix_json.dart';
import 'package:ml_linalg/src/matrix/serialization/matrix_json_keys.dart';
import 'package:test/test.dart';

import '../../helpers.dart';

void main() {
  group('fromMatrixJson', () {
    final data = <List<double>>[
      [1.0, 2.0, 4.0, 5.0],
      [-100.0, 4.89, 191, -10000],
      [33, -987, 90, 732],
    ];

    final dataWithNull = <List<double?>>[
      [123.0009863, null, 11.777209, 90003.112],
      [-93.5678, 12, null, -10e2],
    ];

    final emptyData = <List<double>>[];
    final dataWithEmptyRow = <List<double>>[[]];

    final jsonWithoutData = {
      matrixDTypeJsonKey: dTypeFloat64EncodedValue,
    };

    final jsonWithoutDType = {
      matrixDataJsonKey: data,
    };

    final validFloat32Json = {
      matrixDTypeJsonKey: dTypeFloat32EncodedValue,
      matrixDataJsonKey: data,
    };

    final validFloat64Json = {
      matrixDTypeJsonKey: dTypeFloat64EncodedValue,
      matrixDataJsonKey: data,
    };

    final validFloat32JsonWithEmptyData = {
      matrixDTypeJsonKey: dTypeFloat32EncodedValue,
      matrixDataJsonKey: emptyData,
    };

    final validFloat32JsonWithEmptyRow = {
      matrixDTypeJsonKey: dTypeFloat32EncodedValue,
      matrixDataJsonKey: dataWithEmptyRow,
    };

    final validFloat32JsonWithNullInData = {
      matrixDTypeJsonKey: dTypeFloat32EncodedValue,
      matrixDataJsonKey: dataWithNull,
    };

    test('should throw an error if data key is absent', () {
      final actual = () => fromMatrixJson(jsonWithoutData);
      expect(actual, throwsException);
    });

    test('should throw an error if dtype key is absent', () {
      final actual = () => fromMatrixJson(jsonWithoutDType);
      expect(actual, throwsException);
    });

    test('should restore a float32 matrix instance from json', () {
      final matrix = fromMatrixJson(validFloat32Json)!;
      expect(matrix.dtype, DType.float32);
      expect(matrix, iterable2dAlmostEqualTo(data));
    });

    test('should restore a float64 matrix instance from json', () {
      final matrix = fromMatrixJson(validFloat64Json)!;
      expect(matrix.dtype, DType.float64);
      expect(matrix, iterable2dAlmostEqualTo(data));
    });

    test('should restore a float32 matrix from json with empty data', () {
      final matrix = fromMatrixJson(validFloat32JsonWithEmptyData);
      expect(matrix, emptyData);
    });

    test(
        'should restore a float32 matrix from json with data consisting of '
        'just an empty row', () {
      final matrix = fromMatrixJson(validFloat32JsonWithEmptyRow);
      expect(matrix, emptyData);
    });

    test('should throw an error if there are nulls in the data', () {
      final actual = () => fromMatrixJson(validFloat32JsonWithNullInData);
      expect(actual, throwsFormatException);
    });

    test('should handle null value', () {
      final actual = fromMatrixJson(null);
      expect(actual, isNull);
    });
  });
}
