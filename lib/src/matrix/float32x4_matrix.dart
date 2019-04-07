import 'dart:core';
import 'dart:typed_data';

import 'package:ml_linalg/src/matrix/base_matrix.dart';
import 'package:ml_linalg/src/matrix/data_manager/data_manager_impl.dart';
import 'package:ml_linalg/vector.dart';

final bufferToFloat32List =
    (ByteBuffer buffer, int offset, int length) =>
        buffer.asFloat32List(offset, length);

final updateByteData = (ByteData data, int offset, double value,
    Endian endian) => data.setFloat32(offset, value, endian);

class Float32x4Matrix extends BaseMatrix {
  Float32x4Matrix.from(Iterable<Iterable<double>> source) :
        super(DataManagerImpl.from(
          source,
          Float32List.bytesPerElement,
          Float32x4,
          bufferToFloat32List,
          updateByteData));

  Float32x4Matrix.columns(Iterable<Vector> source) :
        super(DataManagerImpl.fromColumns(
          source,
          Float32List.bytesPerElement,
          Float32x4,
          bufferToFloat32List,
          updateByteData));

  Float32x4Matrix.rows(Iterable<Vector> source) :
        super(DataManagerImpl.fromRows(
          source,
          Float32List.bytesPerElement,
          Float32x4,
          bufferToFloat32List,
          updateByteData));

  Float32x4Matrix.flattened(Iterable<double> source, int rowsNum,
      int columnsNum) :
        super(DataManagerImpl.fromFlattened(
          source,
          rowsNum,
          columnsNum,
          Float32List.bytesPerElement,
          Float32x4,
          bufferToFloat32List,
          updateByteData));

  @override
  final Type dtype = Float32x4;
}
