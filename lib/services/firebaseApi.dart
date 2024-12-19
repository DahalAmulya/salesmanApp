import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  // Create an instance of the Firebase messaging
  final _firebaseMessaging =
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // function to initialize notification
  Future<void> initNotifications() async {
    // request permission from user (will prompt user)
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // fetch the FCM token for this device
    final fCMToken = await FirebaseMessaging.instance.getToken();

    // print the toke (normally you would send this to your server)
    print('Token: $fCMToken');
  }

  // function to handle received messages

  // function to initialize foreground and background settings
}
