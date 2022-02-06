import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/norm.dart';
import 'package:ml_linalg/vector.dart';

void main() {
  addition();
  subtraction();
  multiplication();
  division();
  euclideanNorm();
  manhattanNorm();
  mean();
  sum();
  dot();
  scalarAddition();
  scalarSubtraction();
  scalarMultiplication();
  scalarDivision();
  euclideanDistanceBetweenVectors();
  manhattanDistanceBetweenVectors();
  cosineDistanceBetweenVectors();
}

void addition() {
  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1 + vector2;
  print(result); // [3.0, 5.0, 7.0, 9.0, 11.0]
}

void subtraction() {
  final vector1 = Vector.fromList([4.0, 5.0, 6.0, 7.0, 8.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 2.0, 3.0, 2.0]);
  final result = vector1 - vector2;
  print(result); // [2.0, 2.0, 4.0, 4.0, 6.0]
}

void multiplication() {
  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1 * vector2;
  print(result); // [2.0, 6.0, 12.0, 20.0, 30.0]
}

void division() {
  final vector1 = Vector.fromList([6.0, 12.0, 24.0, 48.0, 96.0]);
  final vector2 = Vector.fromList([3.0, 4.0, 6.0, 8.0, 12.0]);
  final result = vector1 / vector2;
  print(result); // [2.0, 3.0, 4.0, 6.0, 8.0]
}

void euclideanNorm() {
  final vector1 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.norm();
  print(result); // sqrt(2^2 + 3^2 + 4^2 + 5^2 + 6^2) = sqrt(90) ~~ 9.48
}

void manhattanNorm() {
  final vector1 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.norm(Norm.manhattan);
  print(result); // 2 + 3 + 4 + 5 + 6 = 20.0
}

void mean() {
  final vector1 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.mean();
  print(result); // (2 + 3 + 4 + 5 + 6) / 5 = 4.0
}

void sum() {
  final vector1 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.sum();
  print(result); // 2 + 3 + 4 + 5 + 6 = 20.0 (equivalent to Manhattan norm)
}

void dot() {
  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.dot(vector2);
  print(
      result); // 1.0 * 2.0 + 2.0 * 3.0 + 3.0 * 4.0 + 4.0 * 5.0 + 5.0 * 6.0 = 70.0
}

void scalarAddition() {
  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final scalar = 5.0;
  final result = vector1 + scalar;
  print(result); // [6.0, 7.0, 8.0, 9.0, 10.0]
}

void scalarSubtraction() {
  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final scalar = 5.0;
  final result = vector1 / scalar;
  print(result); // [-4.0, -3.0, -2.0, -1.0, 0.0]
}

void scalarMultiplication() {
  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final scalar = 5.0;
  final result = vector1 * scalar;
  print(result); // [5.0, 10.0, 15.0, 20.0, 25.0]
}

void scalarDivision() {
  final vector1 = Vector.fromList([25.0, 50.0, 75.0, 100.0, 125.0]);
  final scalar = 5.0;
  final result = vector1 / scalar;
  print(result); // [5.0, 10.0, 15.0, 20.0, 25.0]
}

void euclideanDistanceBetweenVectors() {
  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.distanceTo(vector2);
  print(result); // ~~2.23
}

void manhattanDistanceBetweenVectors() {
  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.distanceTo(vector2, distance: Distance.manhattan);
  print(result); // 5.0
}

void cosineDistanceBetweenVectors() {
  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.distanceTo(vector2, distance: Distance.cosine);
  print(result); // 0.00506
}
