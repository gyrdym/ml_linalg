import 'dart:typed_data';

import 'package:ml_linalg/src/vector/common/typed_list_factory.dart';

class Float32ListFactory implements TypedListFactory {
  @override
  Float32List empty(int length) => Float32List(length);

  @override
  Float32List fromList(List<double> list) =>
      Float32List.fromList(list);

  @override
  Float32List fromByteBuffer(ByteBuffer buffer) =>
      Float32List.view(buffer);

  @override
  Float32List fromBuffer(ByteBuffer buffer, int start, int length) =>
      buffer.asFloat32List(start * Float32List.bytesPerElement, length);

  @override
  Iterator<double> createIterator(ByteBuffer buffer, int length) =>
      buffer.asFloat32List(0, length).iterator;
}
