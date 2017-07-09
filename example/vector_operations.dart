import 'package:dart_simd_vector/vector.dart';

void main() {
  addition();
  subtraction();
  multiplication();
  division();
  euclideanNorm();
  manhattanNorm();
  mean();
  sum();
}

void addition() {
  Float32x4Vector vector1 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  Float32x4Vector vector2 = new Float32x4Vector.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  Float32x4Vector result = vector1 + vector2;
  print(result.asList()); // [3.0, 5.0, 7.0, 9.0, 11.0]
}

void subtraction() {
  Float32x4Vector vector1 = new Float32x4Vector.from([4.0, 5.0, 6.0, 7.0, 8.0]);
  Float32x4Vector vector2 = new Float32x4Vector.from([2.0, 3.0, 2.0, 3.0, 2.0]);
  Float32x4Vector result = vector1 - vector2;
  print(result.asList()); // [2.0, 2.0, 4.0, 4.0, 6.0]
}

void multiplication() {
  Float32x4Vector vector1 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  Float32x4Vector vector2 = new Float32x4Vector.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  Float32x4Vector result = vector1 * vector2;
  print(result.asList()); // [2.0, 6.0, 12.0, 20.0, 30.0]
}

void division() {
  Float32x4Vector vector1 = new Float32x4Vector.from([6.0, 12.0, 24.0, 48.0, 96.0]);
  Float32x4Vector vector2 = new Float32x4Vector.from([3.0, 4.0, 6.0, 8.0, 12.0]);
  Float32x4Vector result = vector1 / vector2;
  print(result.asList()); // [2.0, 3.0, 4.0, 6.0, 8.0]
}

void euclideanNorm() {
  Float32x4Vector vector1 = new Float32x4Vector.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  double result = vector1.norm();
  print(result); // sqrt(2^2 + 3^2 + 4^2 + 5^2 + 6^2) = sqrt(90) ~~ 9.48
}

void manhattanNorm() {
  Float32x4Vector vector1 = new Float32x4Vector.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  double result = vector1.norm(Norm.MANHATTAN);
  print(result); // 2 + 3 + 4 + 5 + 6 = 20.0
}

void mean() {
  Float32x4Vector vector1 = new Float32x4Vector.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  double result = vector1.mean();
  print(result); // (2 + 3 + 4 + 5 + 6) / 5 = 4.0
}

void sum() {
  Float32x4Vector vector1 = new Float32x4Vector.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  double result = vector1.sum();
  print(result); // 2 + 3 + 4 + 5 + 6 = 20.0 (equivalent to Manhattan norm)
}
