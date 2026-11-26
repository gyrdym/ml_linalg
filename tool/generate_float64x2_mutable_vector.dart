import 'dart:async';

import 'generate_class_from_template.dart';

Future<Null> generateFloat64x2MutableVector() => generateClassFromTemplate(
      'lib/src/vector/float64x2_mutable_vector.g.dart',
      'lib/src/vector/float32x4_mutable_vector.dart',
    );

void main() async {
  await generateFloat64x2MutableVector();
}
