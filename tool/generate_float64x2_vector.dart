import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;

Future<Null> main() async {
  await generateFloat64x2Vector();
}

Future<Null> generateFloat64x2Vector() async {
  final File libraryFile = File('lib/src/vector/float64x2_vector.dart');

  if (libraryFile.existsSync()) {
    await libraryFile.delete();
  }

  await _processFile('lib/src/vector/float32x4_vector.dart');
}

Future<Null> _processFile(String inputFileName) async {
  final File inputFile = File(inputFileName);

  final String input = await inputFile.readAsString();
  final String output = _convertToFloat64x2Vector(input);

  final String outputFileName = inputFileName.replaceAll('float32x4', 'float64x2');
  final Directory dir = Directory(p.dirname(outputFileName));

  await dir.create(recursive: true);

  final File outputFile = File(outputFileName);
  await outputFile.writeAsString(output);
}

String _convertToFloat64x2Vector(String input) => input
    .replaceAll('float32x4_', 'float64x2_')
    .replaceAll('Float32x4', 'Float64x2')
    .replaceAll('Float32', 'Float64')
    .replaceAll('float32', 'float64');