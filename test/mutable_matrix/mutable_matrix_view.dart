import 'dart:collection';
import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart' show Matrix;
import 'package:ml_linalg/mutable_matrix.dart';

List<double> typedPrefixView(List<double> values, int length) {
  if (values is Float32List) {
    return Float32List.view(values.buffer, values.offsetInBytes, length);
  }
  if (values is Float64List) {
    return Float64List.view(values.buffer, values.offsetInBytes, length);
  }
  throw ArgumentError.value(values, 'values', 'Expected typed float data');
}

class MutableMatrixView
    with IterableMixin<Iterable<double>>
    implements MutableMatrix {
  MutableMatrixView(
    this.asFlattenedList,
    this.rowCount,
    this.columnCount,
    this.dtype,
  );

  @override
  final List<double> asFlattenedList;

  @override
  final int rowCount;

  @override
  final int columnCount;

  @override
  final DType dtype;

  @override
  Iterator<Iterable<double>> get iterator =>
      Iterable<Iterable<double>>.generate(rowCount, (index) => this[index])
          .iterator;

  @override
  Iterable<double> operator [](int index) {
    RangeError.checkValidIndex(index, this, 'index', rowCount);
    final offset = index * columnCount;
    return Iterable<double>.generate(
      columnCount,
      (columnIndex) => asFlattenedList[offset + columnIndex],
    );
  }

  @override
  Matrix toMatrix() => Matrix.fromFlattenedList(
        List<double>.of(asFlattenedList),
        rowCount,
        columnCount,
        dtype: dtype,
      );

  @override
  MutableMatrix scale(num factor) => throw UnimplementedError();

  @override
  MutableMatrix addScaled(Object other, num factor) =>
      throw UnimplementedError();

  @override
  MutableMatrix multiplyInto(Object other, MutableMatrix destination) =>
      throw UnimplementedError();

  @override
  double differenceNorm(Object other) => throw UnimplementedError();
}
