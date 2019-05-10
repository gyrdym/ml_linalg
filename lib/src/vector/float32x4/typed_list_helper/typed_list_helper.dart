import 'dart:typed_data';

import 'package:ml_linalg/src/vector/common/typed_list_helper.dart';

class Float32ListHelper implements TypedListHelper {
  @override
  Float32List empty(int length) => Float32List(length);

  @override
  Float32List fromList(List<double> list) =>
      Float32List.fromList(list);

  @override
  Float32List fromByteBuffer(ByteBuffer buffer) =>
      Float32List.view(buffer);

  @override
  Float32List getBufferAsList(ByteBuffer buffer, int start, int length) =>
      buffer.asFloat32List(start * Float32List.bytesPerElement, length);

  @override
  void setValue(ByteData byteData, int byteOffset, double value,
      [Endian endian]) => byteData.setFloat32(byteOffset, value, Endian.host);
}
