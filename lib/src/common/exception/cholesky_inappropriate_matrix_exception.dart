class CholeskyInappropriateMatrixException implements Exception {
  CholeskyInappropriateMatrixException()
      : message =
            'Cholesky decomposition: You are trying to decompose inappropriate matrix. Only positive definite and symmetric matrices can be decomposed';

  final String message;

  @override
  String toString() => message;
}
