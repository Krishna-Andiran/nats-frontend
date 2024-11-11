import 'package:logger/logger.dart';

class Components {
  static Logger log = Logger();
  static void logMessage(Object message) {
    return log.d("⚡⚡⚡$message⚡⚡⚡".toUpperCase());
  }

  static void logErrMessage(dynamic message, Object error) {
    return log.e("⚡⚡⚡$message⚡⚡⚡".toUpperCase(), error: error);
  }
}
