import 'dart:typed_data';

import 'package:ml_linalg/vector.dart';

abstract class MatrixDataStore {
  List<Vector> get columnsCache;
  List<Vector> get rowsCache;
  ByteData get data;
  void updateByteData(int elementNum, double value);
}
