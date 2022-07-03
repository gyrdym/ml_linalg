import 'package:ml_linalg/linalg.dart';

void main() {
  final L = Matrix.fromList([
    [0, 1 / 2, 1 / 3, 0, 0, 0],
    [1 / 3, 0, 0, 0, 1 / 2, 0],
    [1 / 3, 1 / 2, 0, 1, 0, 1 / 2],
    [1 / 3, 0, 1 / 3, 0, 1 / 2, 1 / 2],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 1 / 3, 0, 0, 0]
  ]);

  final eigen = L.eigen().first;

  print(eigen.vector / eigen.vector.sum() * 100);
}
