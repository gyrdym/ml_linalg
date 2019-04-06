import 'package:ml_linalg/vector.dart';

abstract class DataManager {
  int get rowsNum;
  int get columnsNum;
  Iterator<Iterable<double>> get dataIterator;
  List<Vector> get rowsCache;
  List<Vector> get columnsCache;

  void update(int idx, double value);
  void updateAll(int idx, Iterable<double> values);
  List<double> getValues(int index, int length);
}
