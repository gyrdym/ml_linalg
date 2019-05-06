import 'dart:math' as math;

import 'package:ml_linalg/src/vector/common/simd_helper.dart';
import 'package:ml_linalg/src/vector/data_generator/data_generator.dart';

class DataGeneratorImpl<E, S extends List<E>> implements DataGenerator<E, S> {
  DataGeneratorImpl(this._source, this._bucketSize, this._simdHelper) :
        _data = _simdHelper.createList((_source.length / _bucketSize).ceil());

  final List<double> _source;
  final S _data;
  final int _bucketSize;
  final SimdHelper<E, S> _simdHelper;

  bool _isDataGenerated = false;

  @override
  S getDataAsList() => _simdHelper
      .createListFrom(generate().toList(growable: false));

  @override
  Iterable<E> generate() => _isDataGenerated ? _data : _generateValues();

  Iterable<E> _generateValues() sync* {
    final numOfBuckets = (_source.length / _bucketSize).ceil();
    for (int i = 0; i < numOfBuckets; i++) {
      if (_data[i] != null) {
        yield _data[i];
        break;
      }
      final start = i * _bucketSize;
      final end = start + _bucketSize;
      final bucketAsList = _source
          .sublist(start, math.min(end, _source.length));
      yield (_data[i] = _simdHelper.createFromList(bucketAsList));
    }
    _isDataGenerated = true;
  }
}
