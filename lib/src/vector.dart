import 'norm.dart';

///An algebraic vector (ordered set of elements).
abstract class Vector implements List<double> {
  ///Vector's dimension
  int get length;

  ///Vector addition (element-wise operation)
  Vector operator +(Vector vector);

  ///Vector subtraction (element-wise operation)
  Vector operator -(Vector vector);

  ///Vector multiplication (element-wise operation)
  Vector operator *(Vector vector);

  ///Element-wise division
  Vector operator /(Vector vector);

  ///Raises each element of a vector to the integer power equals [power]
  Vector toIntegerPower(int power);

  ///Performs a vector and a scalar multiplication (each component of a vector is multiplied by [value])
  Vector scalarMul(double value);

  ///Performs a division of a vector by a scalar (each component of a vector is divided by [value])
  Vector scalarDiv(double value);

  ///Performs a vector and a scalar addition ([value] is added to each component of a vector)
  Vector scalarAdd(double value);

  ///Performs subtraction of a vector and a scalar ([value] is subtracted from an each component of a vector )
  Vector scalarSub(double value);

  ///Returns a vector with absolute value of each vector element
  Vector abs();

  ///Returns a copy of a vector
  Vector copy();

  ///Returns a dot (inner) product of [this] and [vector]
  double dot(Vector vector);

  ///Returns a distance between [this] and [vector] with vector norm type considering
  double distanceTo(Vector vector, [Norm norm = Norm.EUCLIDEAN]);

  ///Returns a mean value of [this] vector
  double mean();

  ///Calculates vector norm (magnitude)
  double norm([Norm norm = Norm.EUCLIDEAN]);

  ///Returns sum of all elements
  double sum();

  ///Returns a vector composed of elements which are located on the passed indexes
  Vector query(Iterable<int> indexes);
}