import 'dart:async';

import 'generate_class_from_template.dart';

const _templateFileName = 'lib/src/matrix/data_manager/float32_matrix_data_manager.dart';
const _targetFileName = 'lib/src/matrix/data_manager/float64_matrix_data_manager.gen.dart';

Future<Null> main() async {
  await generateClassFromTemplate(_targetFileName, _templateFileName, {
    'Float32': 'Float64',
    'float32_matrix_iterator': 'float64_matrix_iterator.gen',
    'DType.float32': 'DType.float64',
  });
}
