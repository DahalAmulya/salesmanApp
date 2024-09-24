import 'package:flutter/widgets.dart';

class ScreenUtil {
  static double getScreenWidth() {
    return WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio;
  }

  static double getScreenHeight() {
    return WidgetsBinding.instance.window.physicalSize.height /
        WidgetsBinding.instance.window.devicePixelRatio;
  }
}
