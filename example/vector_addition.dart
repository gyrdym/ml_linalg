import 'package:ml_linalg/vector.dart';

const numOfRows = 10000;

void main() {
  final vector1 = Vector.randomFilled(numOfRows, seed: 5);
  final vector2 = Vector.randomFilled(numOfRows, seed: 6);
  final result = vector1 + vector2;

  print(result);
}
