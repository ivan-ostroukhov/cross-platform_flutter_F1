import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DesktopWidgetService {
  static const MethodChannel _channel = MethodChannel('com.f1app.apex/desktop_widgets');

  static Future<bool> createClockWidget() async {
    try {
      debugPrint('[Dart DesktopWidgetService] Invoking MethodChannel createClockWidget...');
      final result = await _channel.invokeMethod<bool>('createClockWidget');
      debugPrint('[Dart DesktopWidgetService] Result from C++: $result');
      return result ?? false;
    } catch (e, st) {
      debugPrint('[Dart DesktopWidgetService] Error calling createClockWidget: $e\n$st');
      return false;
    }
  }
}