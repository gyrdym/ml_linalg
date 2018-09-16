import 'dart:io';
import 'dart:convert';

void main() {
  Process.start('pub run build_runner test -- -p vm', [], runInShell: true).then((Process process) {
    process.stdout.transform(utf8.decoder).listen((data) {stdout.write(data);});
    process.stderr.transform(utf8.decoder).listen((data) {stderr.write(data);});
  });
}
