import 'dart:collection';
import 'dart:core';
import 'dart:typed_data';

import 'package:linalg/src/matrix.dart';

class Float32x4Matrix extends Object with IterableMixin<Iterable<double>> implements Matrix, Iterable<Iterable<double>> {
  @override
  final int rows;

  @override
  final int columns;

  final ByteData _data;
  final Iterator<Iterable<double>> _iterator;

  Float32x4Matrix.from(Iterable<Iterable<double>> source) :
        rows = source.length,
        columns = source.first.length,
        _data = ByteData(source.length * source.first.length),
        _iterator = source.iterator {
    _fillData(source);
  }

  @override
  Iterable<double> operator [](int index) {
    final startIndex = index * columns;
    return _data.buffer.asFloat32List(startIndex * Float32List.bytesPerElement, columns);
  }

  @override
  Iterator<Iterable<double>> get iterator => _iterator;

  void _fillData(Iterable<Iterable<double>> source) {
    for (final row in source) {
      for (final value in row) {
        _data.setFloat32(_data.lengthInBytes * Float32List.bytesPerElement, value);
      }
    }
  }
}
