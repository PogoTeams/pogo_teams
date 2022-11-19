// Dart
import 'dart:io';

class PogoDebugging {
  static const debugHeaderWidth = 100;

  static void printHeader(String title) {
    stdout.writeln('\n$title ${'-' * (debugHeaderWidth - title.length)}');
  }

  static void print(
    String title,
    String message, {
    String? footer,
  }) {
    printHeader(title);
    stdout.writeln(message);
    printFooter(footer: footer);
  }

  static void printMessage(String message) {
    stdout.writeln(message);
  }

  static void printMulti(
    String title,
    Iterable<String> messages, {
    String? footer,
  }) {
    printHeader(title);
    for (String message in messages) {
      stdout.writeln(message);
    }
    printFooter(footer: footer);
  }

  static void printFooter({String? footer}) {
    if (footer == null) {
      stdout.writeln('${'-' * (debugHeaderWidth + 1)}\n');
    } else {
      stdout.writeln('${'-' * (debugHeaderWidth - footer.length)} $footer\n');
    }
  }

  static void breakpoint() {
    stdin.readLineSync();
  }
}
