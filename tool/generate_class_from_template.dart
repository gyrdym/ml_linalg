import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;

const excludedImports = ['/float32x4_helper.dart'];

final _defaultMapping = {
  // Order is important!
  // First, replace imports and names for float32x4 data type, then replace imports and names for float32 data type
  RegExp('\/float32x4([^/]*)\.dart'): (Match match) {
    if (excludedImports.contains(match.group(0))) {
      return '/float64x2${match.group(1)}.dart';
    }

    return '/float64x2${match.group(1)}.g.dart';
  },

  RegExp(r'Float32x4\(\s*(.*),\s*(.*),\s*(.*),\s*(.*)\s*\)'): (Match match) =>
      'Float64x2(${match.group(1)}, ${match.group(2)})',

  RegExp('(F|f)loat32x4'): (Match match) => '${match.group(1)}loat64x2',

  RegExp('\/float32([^/]*)\.dart'): (Match match) =>
      '/float64${match.group(1)}.g.dart',

  RegExp('(F|f)loat32'): (Match match) => '${match.group(1)}loat64',
};

Future<Null> generateClassFromTemplate(
  String targetFileName,
  String templateFileName, {
  Map<Pattern, String Function(Match)>? mapping,
  String comment =
      '/* This file is auto generated, do not change it manually */\n// ignore_for_file: unused_local_variable\n\n',
}) async {
  final targetFile = File(targetFileName);

  if (targetFile.existsSync()) {
    await targetFile.delete();
  }

  await _processFile(
    targetFileName,
    templateFileName,
    {}
      ..addAll(mapping ?? {})
      ..addAll(_defaultMapping),
    comment,
  );
}

Future<Null> _processFile(String targetFileName, String inputFileName,
    Map<Pattern, String Function(Match)> mapping, String comment) async {
  final inputFile = File(inputFileName);
  final input = await inputFile.readAsString();
  final output = '$comment${_convertTemplateToTargetClass(input, mapping)}';
  final outputFileName = targetFileName;
  final dir = Directory(p.dirname(outputFileName));

  await dir.create(recursive: true);

  final outputFile = File(outputFileName);

  await outputFile.writeAsString(output);
}

String _convertTemplateToTargetClass(
        String input, Map<Pattern, String Function(Match)> mapping) =>
    mapping.entries.fold(
        input,
        (processedInput, entry) =>
            processedInput.replaceAllMapped(entry.key, entry.value));
