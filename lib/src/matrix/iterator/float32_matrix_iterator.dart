import 'dart:typed_data';

const _bytesPerElement = Float32List.bytesPerElement;

class Float32MatrixIterator implements Iterator<Iterable<double>> {
  Float32MatrixIterator(this._data, this._rowsNum, this._colsNum);

  final ByteData _data;
  final int _rowsNum;
  final int _colsNum;

  late Float32List _current;
  int _currentRow = 0;

  @override
  Iterable<double> get current => _current;

  @override
  bool moveNext() {
    final hasNext = _currentRow < _rowsNum;

    if (hasNext) {
      _current = _data.buffer
          .asFloat32List(_currentRow * _colsNum * _bytesPerElement, _colsNum);
      _currentRow++;
    }

    return hasNext;
  }
}
