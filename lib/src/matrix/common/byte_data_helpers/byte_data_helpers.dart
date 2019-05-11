import 'dart:typed_data';

typedef ByteBufferAsTypedListFn = List<double> Function(ByteBuffer buffer,
    int offset, int length);

typedef UpdateByteDataFn = void Function(ByteData data, int offset,
    double value, Endian endian);