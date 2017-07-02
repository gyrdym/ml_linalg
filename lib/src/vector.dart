import 'norm.dart';

abstract class Vector<T> {
  int get length;

  Vector operator +(Vector vector);
  Vector operator -(Vector vector);
  Vector operator *(Vector vector);
  Vector operator /(Vector vector);

  Vector intPow(int exponent);
  Vector scalarMul(double value);
  Vector scalarDiv(double value);
  Vector scalarAdd(double value);
  Vector scalarSub(double value);

  Vector abs();
  Vector copy();

  double dot(Vector vector);
  double distanceTo(Vector vector, [Norm norm = Norm.EUCLIDEAN]);
  double mean();
  double norm([Norm norm = Norm.EUCLIDEAN]);
  double sum();

  T asList();
}