import 'package:background_task/background_task.dart';
import 'package:deskgoo/consts.dart';
// import 'package:deskgoo/utils/notification.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
void backgroundHandler(Location data) async {
  print(
      'Location LatLng = ${data.lat}, ${data.lng}, ${DateTime.now().toString().split('.')[0]}');
  // NotificationUtils.sendNotification(
  //     1, 'Background Notification', '${data.lat}, ${data.lng}');
}

void getBackgroundLocation() async {
  await BackgroundTask.instance.stop();
  final status = await Permission.location.request();
  final statusAlways = await Permission.locationAlways.request();

  if (status.isGranted && statusAlways.isGranted) {
    if (isBackground) {
      await BackgroundTask.instance.start(
        // distanceFilter: 0,
        isEnabledEvenIfKilled: true,
        pausesLocationUpdatesAutomatically: true,
        updateIntervalInMilliseconds: 1000,
        iOSDesiredAccuracy: DesiredAccuracy.best,
        androidDesiredAccuracy:
            AndroidDesiredAccuracy.priorityBalancedPowerAccuracy,
      );
      if (!isBackground) {
        await BackgroundTask.instance.stop();
      }
    } else {
      await BackgroundTask.instance.stop();
    }
  }
}
