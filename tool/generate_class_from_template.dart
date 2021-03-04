import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;

final _defaultMapping = {
  RegExp('(F|f)loat32x4'): (Match match) => '${match.group(1)}loat64x2',
  RegExp('(F|f)loat32'): (Match match) => '${match.group(1)}loat64',
};

Future<Null> generateClassFromTemplate(
    String targetFileName,
    String templateFileName,
    {
      Map<Pattern, String Function(Match)>? mapping,
      String comment = '/* This file is auto generated, do not change it manually */\n\n',
    }
) async {
  final targetFile = File(targetFileName);

  if (targetFile.existsSync()) {
    await targetFile.delete();
  }

  await _processFile(
    targetFileName,
    templateFileName,
    {}..addAll(mapping ?? {})..addAll(_defaultMapping),
    comment,
  );
}

Future<Null> _processFile(String targetFileName, String inputFileName,
    Map<Pattern, String Function(Match)> mapping, String comment) async {
  final inputFile = File(inputFileName);
  final input = await inputFile.readAsString();
  final output =
      '$comment${_convertTemplateToTargetClass(input, mapping)}';
  final outputFileName = targetFileName;
  final dir = Directory(p.dirname(outputFileName));

  await dir.create(recursive: true);

  final outputFile = File(outputFileName);

  await outputFile.writeAsString(output);
}

String _convertTemplateToTargetClass(String input,
    Map<Pattern, String Function(Match)> mapping) =>
    mapping.entries.fold(input, (processedInput, entry) =>
        processedInput.replaceAllMapped(entry.key, entry.value));
