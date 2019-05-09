import 'dart:typed_data' show ByteBuffer;

abstract class TypedListHelper {
  /// returns a typed list with
  List<double> fromByteBuffer(ByteBuffer data);

  /// returns a typed list (e.g. Float32List) of length equals [length]
  List<double> empty(int length);

  /// returns a typed list (e.g. Float32List) created using [list] as a source
  List<double> fromList(List<double> list);

  List<double> fromBuffer(ByteBuffer buffer, int start, int length);

  /// converts a buffer into typed list and gets its iterator
  Iterator<double> createIterator(ByteBuffer buffer, int length);
}
