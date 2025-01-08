import '../../view/screen/splash/views/splash_screen_view.dart';
import '../utils.dart';

class NotificationNavigation {
  static final NotificationNavigation instance =
      NotificationNavigation._internal();

  factory NotificationNavigation() {
    return instance;
  }

  NotificationNavigation._internal();

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      getPageOnNotificationTap(payload);
    }
  }

  getPageOnNotificationTap(String payload) {
    switch (payload) {
      case "Home":
        removeAndNavigate(const SplashView());
        break;
    }
  }
}
