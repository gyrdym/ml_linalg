import 'dart:typed_data';

import 'package:ml_linalg/src/common/typed_list_helper/typed_list_helper.dart';

class MatrixIterator implements Iterator<Iterable<double>> {
  MatrixIterator(this._data, this._rowsNum, this._colsNum,
      this._typedListHelper);

  final ByteData _data;
  final int _rowsNum;
  final int _colsNum;
  final TypedListHelper _typedListHelper;

  List<double> _current;
  int _currentRow = 0;

  @override
  Iterable<double> get current => _current;

  @override
  bool moveNext() {
    final startIdx = _currentRow * _colsNum;
    if (_currentRow >= _rowsNum) {
      _current = null;
    } else {
      _current = _typedListHelper.getBufferAsList(_data.buffer, startIdx,
          _colsNum);
    }
    _currentRow++;
    return _current != null;
  }
}
