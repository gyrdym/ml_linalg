/* This file is auto generated, do not change it manually */

import 'dart:typed_data';

class Float64MatrixIterator implements Iterator<Iterable<double>> {
  Float64MatrixIterator(this._data, this._rowsNum, this._colsNum);

  final Float64List _data;
  final int _rowsNum;
  final int _colsNum;

  late Float64List _current;
  int _currentRow = 0;

  @override
  Iterable<double> get current => _current;

  @override
  bool moveNext() {
    final hasNext = _currentRow < _rowsNum;

    if (hasNext) {
      _current = _data.sublist(
          _currentRow * _colsNum, _currentRow * _colsNum + _colsNum);
      _currentRow++;
    }

    return hasNext;
  }
}
