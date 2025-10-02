enum Decomposition {
  /// Cholesky decomposition. Applicable only for for positive definite and symmetric matrices
  cholesky,

  /// LU (Lower-Upper) decomposition
  LU,

  /// QR (Orthogonal-Triangular) decomposition
  QR,
}
