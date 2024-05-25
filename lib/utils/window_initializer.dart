import 'package:flutter/cupertino.dart';
import 'package:window_manager/window_manager.dart';

class WindowInitializer {
  static Future<void> initialize() async {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      center: true,
      minimumSize: Size(840, 540),
      size: Size(840, 540),
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
}
