import 'package:json_annotation/json_annotation.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/di/dependencies.dart';
import 'package:ml_linalg/src/matrix/serialization/from_matrix_json.dart';

class MatrixJsonConverter implements
    JsonConverter<Matrix, Map<String, dynamic>> {

  const MatrixJsonConverter();

  @override
  Matrix fromJson(Map<String, dynamic> json) => dependencies
      .get<FromMatrixJsonFn>()(json);

  @override
  Map<String, dynamic> toJson(Matrix matrix) => matrixToJson(matrix);
}
