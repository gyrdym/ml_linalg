import 'dart:typed_data';

class Float32MatrixIterator implements Iterator<Iterable<double>> {
  final ByteData _data;
  final int _columns;

  Iterable<double> _current;
  int _currentRow = 0;

  Float32MatrixIterator(this._data, this._columns);

  @override
  Iterable<double> get current => _current;

  @override
  bool moveNext() {
    final int byteOffset = _currentRow * _columns * Float32List.bytesPerElement;
    if (byteOffset >= _data.buffer.lengthInBytes) {
      _current = null;
    } else {
      final totalSizeInBytes = byteOffset + (_columns * Float32List.bytesPerElement);
      final length = _data.buffer.lengthInBytes >= totalSizeInBytes
          ? _columns
          : (totalSizeInBytes - _data.buffer.lengthInBytes) ~/ Float32List.bytesPerElement;
      _current = _data.buffer.asFloat32List(byteOffset, length);
    }
    _currentRow++;
    return _current != null;
  }
}