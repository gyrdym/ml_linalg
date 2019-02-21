import 'dart:typed_data';

import 'package:ml_linalg/vector.dart';

abstract class MLMatrixDataStore {
  List<MLVector> get columnsCache;
  List<MLVector> get rowsCache;
  ByteData get data;
  void updateByteData(int elementNum, double value);
}
