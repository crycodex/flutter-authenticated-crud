import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment {
  static Future<void> initEnv() async {
    await dotenv.load(fileName: '.env');
  }

  /// En el emulador Android, `localhost` es el propio emulador.
  /// `10.0.2.2` es el alias de la máquina host (tu Mac/PC).
  static String get apiUrl {
    final String url =
        dotenv.env['HOST_API'] ?? 'http://localhost:3000/api';

    if (kIsWeb) return url;

    if (Platform.isAndroid) {
      final String? androidOverride = dotenv.env['HOST_API_ANDROID'];
      if (androidOverride != null && androidOverride.isNotEmpty) {
        return androidOverride;
      }
      return url
          .replaceAll('localhost', '10.0.2.2')
          .replaceAll('127.0.0.1', '10.0.2.2');
    }

    return url;
  }
}
