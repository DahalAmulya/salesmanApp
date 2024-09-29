import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationUtils {
  static void sendNotification(int id, String title, String body) {
    String capitalize(String s) {
      if (s.isEmpty) return s;
      return s[0].toUpperCase() + s.substring(1);
    }

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: capitalize(title),
        body: capitalize(body),
        wakeUpScreen: true,
        criticalAlert: true,
      ),
    );
  }
}
