import 'dart:typed_data' show ByteBuffer;

abstract class TypedDataHelper<T extends List<double>> {
  /// returns a typed list with
  T createTypedListFromByteBuffer(ByteBuffer data);

  /// returns a typed list (e.g. Float32List) of length equals [length]
  T createTypedList(int length);

  /// returns a typed list (e.g. Float32List) created using [list] as a source
  T createTypedListFromList(List<double> list);

  T bufferAsTypedList(ByteBuffer buffer, int start, int length);

  /// converts a buffer into typed list and gets its iterator
  Iterator<double> getIterator(ByteBuffer buffer, int length);
}
