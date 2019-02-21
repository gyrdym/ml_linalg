import 'dart:typed_data';

import 'package:ml_linalg/src/matrix/ml_matrix_data_store.dart';

abstract class Float32DataHelperMixin implements MLMatrixDataStore {

  @override
  void updateByteData(int elementNum, double value) {
    data.setFloat32(elementNum * Float32List.bytesPerElement, value,
        Endian.host);
  }
}
