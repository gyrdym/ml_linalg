import 'norm.dart';

/// An algebraic vector (ordered set of elements).
abstract class MLVector<E> implements Iterable<double> {
  /// can someone mutate the vector e.g. via []= operator
  bool get isMutable;

  /// Indexed access to a vector's element
  double operator [](int index);

  /// Assigns a value via indexed access
  void operator []=(int index, double value);

  /// Vector addition (element-wise operation)
  MLVector<E> operator +(Object value);

  /// Vector subtraction (element-wise operation)
  MLVector<E> operator -(Object value);

  /// Vector multiplication (element-wise operation)
  MLVector<E> operator *(Object value);

  /// Element-wise division
  MLVector<E> operator /(Object value);

  /// Creates a new [MLVector] containing elements of this [MLVector] raised to the integer [power]
  MLVector<E> toIntegerPower(int power);

  /// Returns a vector with absolute value of each vector element
  MLVector<E> abs();

  /// Returns a dot (inner) product of [this] and [vector]
  double dot(MLVector<E> vector);

  /// Returns a distance between [this] and [vector] with vector norm type considering
  double distanceTo(MLVector<E> vector, [Norm norm = Norm.euclidean]);

  /// Returns a mean value of [this] vector
  double mean();

  /// Calculates vector norm (magnitude)
  double norm([Norm norm = Norm.euclidean]);

  /// Returns sum of all elements
  double sum();

  /// Returns maximum element
  double max();

  /// Returns maximum element
  double min();

  /// Returns a vector composed of elements which are located on the passed indexes
  MLVector<E> query(Iterable<int> indexes);

  /// Returns a vector composed of unique vector's elements
  MLVector<E> unique();

  /// Applies mapper function throughout simd list
  MLVector<E> vectorizedMap(E mapper(E element, [int offsetStartIdx, int offsetEndIdx]));

  /// Cuts out a part of the vector
  MLVector<E> subvector(int start, [int end]);
}