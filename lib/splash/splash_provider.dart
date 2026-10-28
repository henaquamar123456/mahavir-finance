import 'dart:async';
import 'package:flutter/foundation.dart';

import '../core/routes/app_routes.dart';
import '../core/storage/local_storage.dart';

class SplashProvider extends ChangeNotifier {
  Timer? _timer;

  double _progress = 0.0;
  bool _isStarted = false;
  bool _isCompleted = false;

  String? _nextRoute;

  double get progress => _progress;
  bool get isCompleted => _isCompleted;
  String? get nextRoute => _nextRoute;

  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration updateInterval = Duration(milliseconds: 30);

  void start() {
    if (_isStarted) return;

    _isStarted = true;

    final totalTicks =
        splashDuration.inMilliseconds ~/
            updateInterval.inMilliseconds;

    var currentTick = 0;

    _timer = Timer.periodic(updateInterval, (timer) {
      currentTick++;

      _progress =
          (currentTick / totalTicks).clamp(0.0, 1.0);

      if (currentTick >= totalTicks) {
        timer.cancel();
        _completeSplash();
      }

      notifyListeners();
    });
  }

  void _completeSplash() {
    if (_isCompleted) return;

    _progress = 1.0;
    _nextRoute = _getNextRoute();
    _isCompleted = true;

    notifyListeners();
  }

  String _getNextRoute() {
    if (!LocalStorage.isLoggedIn) {
      return LocalStorage.isOnboardingCompleted
          ? AppRoutes.login
          : AppRoutes.onboarding;
    }

    switch (LocalStorage.userRole?.toLowerCase()) {
      case 'customer':
        return AppRoutes.customerDashboard;

      case 'partner':
        return AppRoutes.partnerDashboard;

      case 'admin':
        return AppRoutes.adminDashboard;

      default:
        return AppRoutes.login;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
