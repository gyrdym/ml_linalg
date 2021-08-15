class CosineOfZeroVectorException implements Exception {
  @override
  String toString() => 'It is impossible to find the cosine of an angle of two '
      'vectors if at least one of them is a zero-vector';
}
