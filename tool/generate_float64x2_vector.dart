import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;

const _templateFileName = 'lib/src/vector/float32x4_vector.dart';
const _targetFileName = 'lib/src/vector/float64x2_vector.gen.dart';
const _warningTextComment = '/* This file is auto generated, do not change it manually */\n\n';

Future<Null> main() async {
  await generateFloat64x2Vector();
}

Future<Null> generateFloat64x2Vector() async {
  final File libraryFile = File(_targetFileName);

  if (libraryFile.existsSync()) {
    await libraryFile.delete();
  }

  await _processFile(_templateFileName);
}

Future<Null> _processFile(String inputFileName) async {
  final File inputFile = File(inputFileName);

  final String input = await inputFile.readAsString();
  final String output = '$_warningTextComment${_convertToFloat64x2Vector(input)}';

  final String outputFileName = _targetFileName;
  final Directory dir = Directory(p.dirname(outputFileName));

  await dir.create(recursive: true);

  final File outputFile = File(outputFileName);
  await outputFile.writeAsString(output);
}

String _convertToFloat64x2Vector(String input) => input
    .replaceAll('Float32x4List', 'Float64x2List')
    .replaceAll('Float32x4', 'Float64x2')
    .replaceAll('Float32List', 'Float64List')
    .replaceAll('float32x4_helper', 'float64x2_helper')
    .replaceAll('DType.float32', 'DType.float64')
    .replaceAll('setFloat32', 'setFloat64');