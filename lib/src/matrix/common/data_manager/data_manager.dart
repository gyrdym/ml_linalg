import 'package:ml_linalg/vector.dart';

abstract class DataManager {
  int get rowsNum;
  int get columnsNum;
  Iterator<Iterable<double>> get dataIterator;
  Iterable<int> get rowIndices;
  Iterable<int> get colIndices;
  Vector getColumn(int index, {bool tryCache = true, bool mutable = false});
  Vector getRow(int index, {bool tryCache = true, bool mutable = false});
  List<double> getValues(int index, int length);
}
