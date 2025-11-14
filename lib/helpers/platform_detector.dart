import 'dart:io' if (dart.library.html) 'platform_stub.dart' show Platform;

bool isDesktop() {
  try {
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  } catch (e) {
    return false;
  }
}

