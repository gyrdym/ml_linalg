import 'dart:typed_data';

import 'package:linalg/src/simd/typed_data_helper.dart';

class Float32Mixin implements TypedDataHelper<Float32List> {
  @override
  Float32List createTypedList(int length) => Float32List(length);

  @override
  Float32List createTypedListFromList(List<double> list) => Float32List.fromList(list);

  @override
  Float32List createTypedListFromByteBuffer(ByteBuffer buffer) => Float32List.view(buffer);

  @override
  Float32List bufferAsTypedList(ByteBuffer buffer, int start, int length) =>
      buffer.asFloat32List(start * Float32List.bytesPerElement, length);

  @override
  Iterator<double> getIterator(ByteBuffer buffer, int length) => buffer.asFloat32List(0, length).iterator;
}
