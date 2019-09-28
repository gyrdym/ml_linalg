import 'package:ml_linalg/vector.dart';

abstract class DataManager {
  int get rowsNum;
  int get columnsNum;
  Iterator<Iterable<double>> get iterator;
  Iterable<int> get rowIndices;
  Iterable<int> get columnIndices;
  Vector getColumn(int index);
  Vector getRow(int index);
  List<double> getValues(int index, int length);
}
