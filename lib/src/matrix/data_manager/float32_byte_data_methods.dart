import 'dart:typed_data';

import 'package:ml_linalg/src/matrix/data_manager/byte_data_methods.dart';

final ByteBufferAsTypedListFn bufferToFloat32List =
    (ByteBuffer buffer, int offset, int length) =>
        buffer.asFloat32List(offset, length);

final UpdateByteDataFn updateByteData = (ByteData data, int offset,
    double value, Endian endian) => data.setFloat32(offset, value, endian);