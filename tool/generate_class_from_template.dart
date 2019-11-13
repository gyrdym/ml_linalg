import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;

Future<Null> generateClassFromTemplate(
    String targetFileName,
    String templateFileName,
    Map<String, String> mapping,
    [
      String comment = '/* This file is auto generated, do not change it manually */\n\n',
    ]
) async {
  final File libraryFile = File(targetFileName);

  if (libraryFile.existsSync()) {
    await libraryFile.delete();
  }

  await _processFile(targetFileName, templateFileName, mapping, comment);
}

Future<Null> _processFile(String targetFileName, String inputFileName,
    Map<String, String> mapping, String comment) async {
  final File inputFile = File(inputFileName);

  final String input = await inputFile.readAsString();
  final String output =
      '$comment${_convertTemplateToTargetClass(input, mapping)}';

  final String outputFileName = targetFileName;
  final Directory dir = Directory(p.dirname(outputFileName));

  await dir.create(recursive: true);

  final File outputFile = File(outputFileName);

  await outputFile.writeAsString(output);
}

String _convertTemplateToTargetClass(String input,
    Map<String, String> mapping) =>
    mapping.entries.fold(input, (processedInput, entry) =>
        processedInput.replaceAll(entry.key, entry.value));
