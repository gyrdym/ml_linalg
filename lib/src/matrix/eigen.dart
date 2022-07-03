import 'package:ml_linalg/vector.dart';

class Eigen {
  Eigen(this.value, this.vector);

  final num value;
  final Vector vector;

  @override
  String toString() {
    return 'Value: $value, Vector: $vector;';
  }
}
