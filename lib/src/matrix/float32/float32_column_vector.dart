import 'package:ml_linalg/column_vector.dart';
import 'package:ml_linalg/vector.dart';

import 'float32_matrix.dart';

class Float32ColumnVector extends Float32Matrix implements ColumnVector {
  Float32ColumnVector.fromList(List<double> source) :
        super.columns([Vector.fromList(source)]);

  Float32ColumnVector.fromVector(Vector source) : super.columns([source]);

  @override
  final int columnsNum = 1;
}
