import 'dart:typed_data';

import 'package:ml_linalg/vector.dart';

abstract class MLMatrixDataStore<E> {
  List<MLVector<E>> get columnsCache;
  List<MLVector<E>> get rowsCache;
  ByteData get data;
}
