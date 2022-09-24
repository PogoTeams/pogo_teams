// Dart
import 'dart:io';

class DebugCLI {
  static const debugHeaderWidth = 100;

  static void printHeader(String title) {
    stdout.writeln('\n$title ${'-' * (debugHeaderWidth - title.length)}');
  }

  static void print(String title, String message) {
    printHeader(title);
    stdout.writeln(message);
    printFooter();
  }

  static void printMessage(String message) {
    stdout.writeln(message);
  }

  static void printMulti(String title, Iterable<String> messages) {
    printHeader(title);
    for (String message in messages) {
      stdout.writeln(message);
    }
    printFooter();
  }

  static void printFooter() {
    stdout.writeln('${'-' * (debugHeaderWidth + 1)}\n');
  }

  static void breakPoint() {
    stdin.readLineSync();
  }
}
