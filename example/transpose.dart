import 'package:ml_linalg/matrix.dart';

void main() {
  final source = Matrix.random(5000, 5000, seed: 12);

  source.transpose();
}
