import 'dart:typed_data';

import 'package:ml_linalg/src/matrix/data_manager/byte_data_methods.dart';

class MatrixIterator implements Iterator<Iterable<double>> {
  MatrixIterator(this._data, this._columns, this._bytesPerElement,
      this._convertBuffetToTypedList);

  final ByteData _data;
  final int _columns;
  final int _bytesPerElement;
  final ByteBufferAsTypedListFn _convertBuffetToTypedList;

  List<double> _current;
  int _currentRow = 0;

  @override
  Iterable<double> get current => _current;

  @override
  bool moveNext() {
    final int byteOffset = _currentRow * _columns * _bytesPerElement;
    if (byteOffset >= _data.buffer.lengthInBytes) {
      _current = null;
    } else {
      final totalSizeInBytes =
          byteOffset + (_columns * _bytesPerElement);
      final length = _data.buffer.lengthInBytes >= totalSizeInBytes
          ? _columns
          : (totalSizeInBytes - _data.buffer.lengthInBytes) ~/
              _bytesPerElement;
      _current = _convertBuffetToTypedList(_data.buffer, byteOffset, length);
    }
    _currentRow++;
    return _current != null;
  }
}
