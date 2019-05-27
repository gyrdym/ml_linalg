import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/matrix/float32/float32_column_vector.dart';
import 'package:ml_linalg/vector.dart';

import 'dtype.dart';

abstract class ColumnVector implements Matrix {
  factory ColumnVector.fromList(List<double> source,
      {DType dtype = DType.float32}) {
    switch (dtype) {
      case DType.float32:
        return Float32ColumnVector.fromList(source);
      default:
        throw UnimplementedError();
    }
  }

  factory ColumnVector.fromVector(Vector source,
      {DType dtype = DType.float32}) {
    switch (dtype) {
      case DType.float32:
        return Float32ColumnVector.fromVector(source);
      default:
        throw UnimplementedError();
    }
  }
}
