import 'dart:io';
import 'dart:convert';

class JsonTools {
  static String timestamp({bool utc = false}) {
    DateTime now;
    if (utc) {
      now = DateTime.now().toUtc();
    } else {
      now = DateTime.now();
    }
    return '${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}';
  }

  static Future<dynamic> loadJson(String filename) async {
    if (!filename.endsWith('.json')) {
      filename += '.json';
    }
    if (!await File(filename).exists()) {
      stderr.writeln('file not found : $filename');
      return null;
    }
    return jsonDecode(await File(filename).readAsString());
  }

  static Future<void> writeJson(dynamic contents, String filename) async {
    if (!filename.endsWith('.json')) {
      filename += '.json';
    }
    File writeFile = await File(filename).create();
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    writeFile = await writeFile.writeAsString(encoder.convert(contents));
  }
}
