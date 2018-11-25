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
      _current = _data.buffer.asFloat32List(byteOffset, _columns);
    }
    _currentRow++;
    return _current != null;
  }
}