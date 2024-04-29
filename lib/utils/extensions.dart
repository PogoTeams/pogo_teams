// Packages
import 'package:googleapis/drive/v3.dart' as drive_api;

extension FileExtensions on drive_api.File {
  String? get nameWithoutExtension {
    if (name == null) return name;
    return name!.substring(0, name!.lastIndexOf('.'));
  }
}
