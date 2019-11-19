import 'dart:async';

import 'generate_class_from_template.dart';

Future<Null> generateFloat64MatrixDataManager() => generateClassFromTemplate(
  'lib/src/matrix/data_manager/float64_matrix_data_manager.dart',
  'lib/src/matrix/data_manager/float32_matrix_data_manager.dart',
);

void main() async {
  await generateFloat64MatrixDataManager();
}
