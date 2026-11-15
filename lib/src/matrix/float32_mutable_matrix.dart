import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart' show Matrix;
import 'package:ml_linalg/mutable_matrix.dart';

const _simdSize =
    Float32x4List.bytesPerElement ~/ Float32List.bytesPerElement;

/// Float32-backed mutable matrix with storage independent from its source.
class Float32MutableMatrix
    with IterableMixin<Iterable<double>>
    implements MutableMatrix {
  Float32MutableMatrix(Matrix source)
      : rowCount = source.rowCount,
        columnCount = source.columnCount,
        _values = Float32List(source.rowCount * source.columnCount) {
    _values.setRange(0, _values.length, source.asFlattenedList);
  }

  final Float32List _values;

  @override
  final int rowCount;

  @override
  final int columnCount;

  @override
  DType get dtype => DType.float32;

  @override
  Float32List get asFlattenedList => _values;

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
      (columnIndex) => _values[offset + columnIndex],
    );
  }

  @override
  Matrix toMatrix() => Matrix.fromFlattenedList(
        Float32List.fromList(_values),
        rowCount,
        columnCount,
        dtype: dtype,
      );

  @override
  MutableMatrix scale(num factor) {
    final simdValues = _getSimdValues();
    final factorAsDouble = factor.toDouble();
    final simdFactor = Float32x4.splat(factorAsDouble);

    for (var i = 0; i < simdValues.length; i++) {
      simdValues[i] = simdValues[i] * simdFactor;
    }

    for (var i = simdValues.length * _simdSize; i < _values.length; i++) {
      _values[i] *= factorAsDouble;
    }

    return this;
  }

  @override
  MutableMatrix addScaled(Object other, num factor) {
    _checkSameShape(other);
    final factorAsDouble = factor.toDouble();
    final otherDtype = _dtypeOf(other);
    final otherValues = _snapshotIfOverlapping(
      _flattenedValuesOf(other),
      _values,
    );

    if (otherDtype == DType.float32 &&
        otherValues is Float32List &&
        otherValues.offsetInBytes % Float32x4List.bytesPerElement == 0) {
      final targetSimd = _getSimdValues();
      final otherSimd = otherValues.buffer.asFloat32x4List(
        otherValues.offsetInBytes ~/ Float32x4List.bytesPerElement,
        targetSimd.length,
      );
      final simdFactor = Float32x4.splat(factorAsDouble);

      for (var i = 0; i < targetSimd.length; i++) {
        targetSimd[i] = targetSimd[i] + otherSimd[i] * simdFactor;
      }

      for (var i = targetSimd.length * _simdSize; i < _values.length; i++) {
        _values[i] += otherValues[i] * factorAsDouble;
      }
    } else {
      for (var i = 0; i < _values.length; i++) {
        _values[i] += otherValues[i] * factorAsDouble;
      }
    }

    return this;
  }

  @override
  MutableMatrix multiplyInto(Object other, MutableMatrix destination) {
    _checkSupportedOperand(other);
    final otherRowCount = _rowCountOf(other);
    final otherColumnCount = _columnCountOf(other);
    if (columnCount != otherRowCount) {
      throw ArgumentError(
        'Cannot multiply matrices of shape $rowCount x $columnCount and '
        '$otherRowCount x $otherColumnCount',
      );
    }

    if (destination.rowCount != rowCount ||
        destination.columnCount != otherColumnCount) {
      throw ArgumentError(
        'Destination matrix must have shape $rowCount x $otherColumnCount, '
        'got ${destination.rowCount} x ${destination.columnCount}',
      );
    }

    final left = _values;
    final right = _flattenedValuesOf(other);
    final output = destination.asFlattenedList;
    final leftValues =
        _overlaps(left, output) ? Float32List.fromList(left) : left;
    final rightValues =
        _overlaps(right, output) ? List<double>.of(right) : right;
    final useSimd =
        _dtypeOf(other) == DType.float32 && destination.dtype == DType.float32;

    for (var row = 0; row < rowCount; row++) {
      final leftOffset = row * columnCount;
      final outputOffset = row * otherColumnCount;

      for (var column = 0; column < otherColumnCount; column++) {
        output[outputOffset + column] = useSimd
            ? _dotProduct(
                leftValues,
                rightValues,
                leftOffset,
                column,
                otherColumnCount,
                columnCount,
              )
            : _dotProductScalar(
                leftValues,
                rightValues,
                leftOffset,
                column,
                otherColumnCount,
                columnCount,
              );
      }
    }

    return destination;
  }

  @override
  double differenceNorm(Object other) {
    _checkSameShape(other);

    final otherValues = _flattenedValuesOf(other);
    // Keep subtraction and accumulation in double precision. Accumulating
    // squares in Float32x4 can overflow/underflow, and sumLanes ignores NaN
    // lanes, which would make the result depend on the matrix length.
    var squaredNorm = 0.0;
    for (var i = 0; i < _values.length; i++) {
      final difference = _values[i] - otherValues[i];
      squaredNorm += difference * difference;
    }

    return math.sqrt(squaredNorm);
  }

  Float32x4List _getSimdValues() =>
      _values.buffer.asFloat32x4List(0, _values.length ~/ _simdSize);

  double _dotProduct(
    Float32List left,
    List<double> right,
    int leftOffset,
    int rightOffset,
    int rightStride,
    int length,
  ) {
    var sum = 0.0;
    final simdLimit = length - length % _simdSize;

    for (var i = 0; i < simdLimit; i += _simdSize) {
      final leftChunk = Float32x4(
        left[leftOffset + i],
        left[leftOffset + i + 1],
        left[leftOffset + i + 2],
        left[leftOffset + i + 3],
      );
      final rightChunk = Float32x4(
        right[rightOffset + (i * rightStride)],
        right[rightOffset + ((i + 1) * rightStride)],
        right[rightOffset + ((i + 2) * rightStride)],
        right[rightOffset + ((i + 3) * rightStride)],
      );
      final products = leftChunk * rightChunk;
      sum += products.x + products.y + products.z + products.w;
    }

    for (var i = simdLimit; i < length; i++) {
      sum += left[leftOffset + i] * right[rightOffset + i * rightStride];
    }

    return sum;
  }

  double _dotProductScalar(
    Float32List left,
    List<double> right,
    int leftOffset,
    int rightOffset,
    int rightStride,
    int length,
  ) {
    var sum = 0.0;
    for (var i = 0; i < length; i++) {
      sum += left[leftOffset + i] * right[rightOffset + i * rightStride];
    }
    return sum;
  }

  void _checkSameShape(Object other) {
    _checkSupportedOperand(other);
    final otherRowCount = _rowCountOf(other);
    final otherColumnCount = _columnCountOf(other);
    if (rowCount != otherRowCount || columnCount != otherColumnCount) {
      throw ArgumentError(
        'Matrices have different shapes: $rowCount x $columnCount and '
        '$otherRowCount x $otherColumnCount',
      );
    }
  }

  void _checkSupportedOperand(Object other) {
    if (other is! Matrix && other is! MutableMatrix) {
      throw ArgumentError.value(
        other,
        'other',
        'Expected a Matrix or MutableMatrix',
      );
    }
  }

  int _rowCountOf(Object other) =>
      other is Matrix ? other.rowCount : (other as MutableMatrix).rowCount;

  int _columnCountOf(Object other) => other is Matrix
      ? other.columnCount
      : (other as MutableMatrix).columnCount;

  DType _dtypeOf(Object other) =>
      other is Matrix ? other.dtype : (other as MutableMatrix).dtype;

  List<double> _flattenedValuesOf(Object other) => other is Matrix
      ? other.asFlattenedList
      : (other as MutableMatrix).asFlattenedList;

  bool _overlaps(List<double> first, List<double> second) {
    if (first is Float32List) {
      if (second is Float32List) {
        return _rangesOverlap(
          first.buffer,
          first.offsetInBytes,
          first.lengthInBytes,
          second.buffer,
          second.offsetInBytes,
          second.lengthInBytes,
        );
      }
      if (second is Float64List) {
        return _rangesOverlap(
          first.buffer,
          first.offsetInBytes,
          first.lengthInBytes,
          second.buffer,
          second.offsetInBytes,
          second.lengthInBytes,
        );
      }
    } else if (first is Float64List) {
      if (second is Float32List) {
        return _rangesOverlap(
          first.buffer,
          first.offsetInBytes,
          first.lengthInBytes,
          second.buffer,
          second.offsetInBytes,
          second.lengthInBytes,
        );
      }
      if (second is Float64List) {
        return _rangesOverlap(
          first.buffer,
          first.offsetInBytes,
          first.lengthInBytes,
          second.buffer,
          second.offsetInBytes,
          second.lengthInBytes,
        );
      }
    }

    return false;
  }

  bool _rangesOverlap(
    ByteBuffer firstBuffer,
    int firstOffset,
    int firstLength,
    ByteBuffer secondBuffer,
    int secondOffset,
    int secondLength,
  ) {
    if (!identical(firstBuffer, secondBuffer)) {
      return false;
    }

    final firstEnd = firstOffset + firstLength;
    final secondEnd = secondOffset + secondLength;

    return firstOffset < secondEnd && secondOffset < firstEnd;
  }

  List<double> _snapshotIfOverlapping(
    List<double> source,
    List<double> target,
  ) {
    if (!_overlaps(source, target) || identical(source, target)) {
      return source;
    }

    if (source is Float32List) {
      return Float32List.fromList(source);
    }

    return List<double>.of(source);
  }
}
