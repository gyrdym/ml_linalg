import 'dart:async';

import 'generate_class_from_template.dart';

const _templateFileName = 'lib/src/matrix/iterator/float32_matrix_iterator.dart';
const _targetFileName = 'lib/src/matrix/iterator/float64_matrix_iterator.gen.dart';

Future<Null> main() async {
  await generateClassFromTemplate(_targetFileName, _templateFileName, {
    'Float32': 'Float64',
  });
}
