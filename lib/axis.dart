/// A type of direction, using in some methods of [Matrix](https://pub.dev/documentation/ml_linalg/latest/matrix/matrix-library.html) class
///
/// For instance, it is used in `sort` method - axis parameter denotes there, how the
/// matrix should be sorted: column-wise or row-wise
enum Axis {
  rows, columns,
}
