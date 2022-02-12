enum Inverse {
  /// Matrix inversion that is based on Cholesky decomposition which means that
  /// only positive definite and symmetric matrices can be inverted using this kind
  /// of inversion
  cholesky,

  /// Matrix inversion which is based on LU decomposition
  LU,

  /// This kind of matrix inversion is applicable only for lower-triangular matrices
  forwardSubstitution,

  /// This kind of matrix inversion is applicable only for upper-triangular matrices
  backwardSubstitution,
}
