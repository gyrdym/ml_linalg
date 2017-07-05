import 'norm.dart';

///An algebraic vector (ordered set of components).
abstract class Vector<T> {
  ///Vector dimension
  int get length;

  ///Vector addition (component-wise operation)
  Vector operator +(Vector vector);

  ///Vector subtraction (component-wise operation)
  Vector operator -(Vector vector);

  ///Vector multiplication (component-wise operation)
  Vector operator *(Vector vector);

  ///Component-wise division
  Vector operator /(Vector vector);

  ///Raises each component of a vector to the integer power equals [exponent]
  Vector intPow(int exponent);

  ///Performs a vector and a scalar multiplication (each component of a vector is multiplied by [value])
  Vector scalarMul(double value);

  ///Performs a division of a vector into a scalar (each component of a vector is divided by [value])
  Vector scalarDiv(double value);

  ///Performs a vector and a scalar addition ([value] is added to each component of a vector)
  Vector scalarAdd(double value);

  ///Performs subtraction of a vector and a scalar (from each component of a vector [value] is subtracted)
  Vector scalarSub(double value);

  ///Finds the absolute value of an each component of a vector
  Vector abs();

  ///Returns a copy of a vector
  Vector copy();

  ///Returns a dot product of [this] and [vector]
  double dot(Vector vector);

  ///Returns a distance between [this] and [vector] with vector norm type considering
  double distanceTo(Vector vector, [Norm norm = Norm.EUCLIDEAN]);

  ///Returns a mean value of [this] vector
  double mean();

  ///Calculates vector norm
  double norm([Norm norm = Norm.EUCLIDEAN]);

  ///Returns sum of each components
  double sum();

  ///Returns vector components as a list of type [T]
  T asList();
}