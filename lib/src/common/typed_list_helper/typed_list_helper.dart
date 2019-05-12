import 'dart:typed_data' show ByteBuffer, ByteData, Endian;

abstract class TypedListHelper {
  /// returns a typed list with
  List<double> fromByteBuffer(ByteBuffer data);

  /// returns a typed list (e.g. Float32List) of length equals [length]
  List<double> empty(int length);

  /// returns a typed list (e.g. Float32List) created using [list] as a source
  List<double> fromList(List<double> list);

  /// returns byte buffer in list representation
  List<double> getBufferAsList(ByteBuffer buffer, [int start = 0, int length]);

  /// sets a value to a given [ByteData] by the specified byte offset
  void setValue(ByteData byteData, int byteOffset, double value,
      [Endian endian]);
}
