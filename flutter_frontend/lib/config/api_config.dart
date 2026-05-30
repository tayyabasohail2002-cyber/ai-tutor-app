import 'package:flutter/foundation.dart';
import 'dart:io';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:8000";
    } else if (Platform.isAndroid) {
      return "http://192.168.1.10:8000";
    } else {
      return "http://localhost:8000";
    }
  }
}
