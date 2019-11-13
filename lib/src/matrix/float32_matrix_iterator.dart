import 'dart:typed_data';

const _bytesPerElement = Float32List.bytesPerElement;

class Float32MatrixIterator implements Iterator<Iterable<double>> {
  Float32MatrixIterator(this._data, this._rowsNum, this._colsNum);

  final ByteData _data;
  final int _rowsNum;
  final int _colsNum;

  Float32List _current;
  int _currentRow = 0;

  @override
  Iterable<double> get current => _current;

  @override
  bool moveNext() {
    final startIdx = _currentRow * _colsNum;
    if (_currentRow >= _rowsNum) {
      _current = null;
    } else {
      _current = _data.buffer.asFloat32List(startIdx * _bytesPerElement, _colsNum);
    }
    _currentRow++;
    return _current != null;
  }
}
