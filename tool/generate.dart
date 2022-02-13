import 'generate_float64_matrix.dart';
import 'generate_float64_matrix_data_manager.dart';
import 'generate_float64_matrix_iterator.dart';
import 'generate_float64x2_vector.dart';

void main() async {
  await Future.wait([
    generateFloat64x2Vector(),
    generateFloat64MatrixIterator(),
    generateFloat64MatrixDataManager(),
    generateFloat64Matrix(),
  ]);

  print('Float64-based entities generation completed');
}
