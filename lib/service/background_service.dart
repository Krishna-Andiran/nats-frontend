import 'dart:async';

import 'package:frontend/service/db_service.dart';
import 'package:frontend/service/local_notification_service.dart';
import 'package:logger/logger.dart';

class BackgroundService {
  late final DatabaseService _databaseService;
  late final NotificationService _notificationService;
  Timer? _timer;
  bool _notificationShown =
      false; // Flag to track if the notification has been shown
  bool _isActive = true;
  final Logger log = Logger();
  BackgroundService() {
    _databaseService = DatabaseService();
    _notificationService = NotificationService();
    _startInactivityTimer();
  }

  void _startInactivityTimer() {
    if (!_isActive) {
      _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
        log.i("Checking inactivity...");
        final lastActiveTime = await _databaseService.getLastActiveTime();
        if (lastActiveTime != null &&
            DateTime.now().difference(lastActiveTime).inMinutes >= 1 &&
            !_isActive) {
          if (!_notificationShown) {
            log.i("Showing notification for inactivity");
            await _notificationService.showNotification();
            await _databaseService.storeLastActiveTime(DateTime.now());
            _notificationShown = true;
          }
        } else if (lastActiveTime == null ||
            DateTime.now().difference(lastActiveTime).inMinutes < 2) {
          _notificationShown = false;
        }
      });
    }
  }

  void appInactive() {
    _databaseService.storeLastActiveTime(DateTime.now());
    _isActive = false;
    _startInactivityTimer();
  }

  void appActive() {
    _isActive = true;
    _notificationShown = false;

    _timer?.cancel();
    _timer = null;
  }
}
