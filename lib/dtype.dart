/// A type, denoting, how data will be stored and processed in vectors or
/// matrices
///
/// [DType.float32] means, that all the vector or matrix elements will be
/// represented in memory as 32 digit floating point numbers and in most cases
/// they will be processed in four threads
///
/// [DType.float64] means, that all the vector or matrix elements will be
/// represented in memory as 64 digit floating point numbers and in most cases
/// they will be processed in two threads
enum DType {
  float32,
  float64,
}
