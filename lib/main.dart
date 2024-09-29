import 'dart:async';
import 'dart:io';
import 'dart:ui';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:deskgoo/classes/notification_controller.dart';
// import 'package:deskgoo/pages/home/officer_DescriptionPage.dart';
import 'package:deskgoo/providers/attendance_provider/remote_attendance_provider.dart';
import 'package:deskgoo/providers/camera_provider/camera_provider.dart';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/providers/live_tracking_provider/live_tracking_provider.dart';
import 'package:deskgoo/providers/replay_provider/replay_provider.dart';
import 'package:deskgoo/providers/settings_providers/profile_provider/officerName_provider.dart';
import 'package:deskgoo/providers/settings_providers/profile_provider/officerdetail_provider.dart';
import 'package:deskgoo/providers/settings_providers/profile_provider/profile_provider.dart';
import 'package:deskgoo/providers/visit_provider/order_provider.dart';
import 'package:deskgoo/providers/visit_provider/visit_screen_provider.dart';
import 'package:deskgoo/routes/route_generator.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/utils/notification.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:deskgoo/providers/auth_provider/user_auth_provider.dart';
import 'package:deskgoo/providers/themes_provider/theme_changer_provider.dart';
// import 'package:deskgoo/routes/app_route_configuration.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  // NotificationController.getPermissions();
  if (kIsWeb) {
    print('Running on browser');
    runApp(
      DevicePreview(builder: (context) => const MyApp()),
    );
  } else {
    NotificationController.getPermissions();
    print('Not Running on browser');
    WidgetsFlutterBinding.ensureInitialized();
    // await initializeService();
    // FlutterBackgroundService();
    runApp(const MyApp());
  }
}

String changer = 'game_changer';

// void onStart() {
//   WidgetsFlutterBinding.ensureInitialized();
//   final service = FlutterBackgroundService();

//   print(changer);
//   // service.on(method)
// }

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();

//   /// OPTIONAL, using custom notification channel id
//   // const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   //   'my_foreground', // id
//   //   'MY FOREGROUND SERVICE', // title
//   //   description:
//   //       'This channel is used for important notifications.', // description
//   //   importance: Importance.low, // importance must be at low or higher level
//   // );

//   NotificationUtils.sendNotification(
//     1,
//     'MY FOREGROUND SERVICE',
//     'This channel is used for important notifications.',
//   );

//   // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   //     FlutterLocalNotificationsPlugin();

//   if (Platform.isIOS || Platform.isAndroid) {
//     // await flutterLocalNotificationsPlugin.initialize(
//     //   const InitializationSettings(
//     //     iOS: DarwinInitializationSettings(),
//     //     android: AndroidInitializationSettings('ic_bg_service_small'),
//     //   ),
//     // );
//     print(
//         'Platform.isIOS || Platform.isAndroid = ${Platform.isIOS || Platform.isAndroid}');
//   }

//   // await flutterLocalNotificationsPlugin
//   //     .resolvePlatformSpecificImplementation<
//   //         AndroidFlutterLocalNotificationsPlugin>()
//   //     ?.createNotificationChannel(channel);

//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will be executed when app is in foreground or background in separated isolate
//       onStart: onStart,

//       // auto start service
//       autoStart: true,
//       isForegroundMode: true,

//       notificationChannelId: 'my_foreground',
//       initialNotificationTitle: 'AWESOME SERVICE',
//       initialNotificationContent: 'Initializing',
//       foregroundServiceNotificationId: 888,
//       foregroundServiceTypes: [AndroidForegroundType.location],
//     ),
//     iosConfiguration: IosConfiguration(
//       // auto start service
//       autoStart: true,

//       // this will be executed when app is in foreground in separated isolate
//       onForeground: onStart,

//       // you have to enable background fetch capability on xcode project
//       onBackground: onIosBackground,
//     ),
//   );
// }

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();

//   // SharedPreferences preferences = await SharedPreferences.getInstance();
//   // await preferences.reload();
//   // final log = preferences.getStringList('log') ?? <String>[];
//   // log.add(DateTime.now().toIso8601String());
//   // await preferences.setStringList('log', log);

//   print('${DateTime.now()}');

//   return true;
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   // Only available for flutter 3.0.0 and later
//   DartPluginRegistrant.ensureInitialized();

//   // For flutter prior to version 3.0.0
//   // We have to register the plugin manually

//   // SharedPreferences preferences = await SharedPreferences.getInstance();
//   // await preferences.setString("hello", "world");

//   /// OPTIONAL when use custom notification
//   // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   //     FlutterLocalNotificationsPlugin();

//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });

//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }

//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });

//   // bring to foreground
//   Timer.periodic(const Duration(seconds: 1), (timer) async {
//     if (service is AndroidServiceInstance) {
//       if (await service.isForegroundService()) {
//         /// OPTIONAL for use custom notification
//         /// the notification id must be equals with AndroidConfiguration when you call configure() method.
//         // flutterLocalNotificationsPlugin.show(
//         //   888,
//         //   'COOL SERVICE',
//         //   'Awesome ${DateTime.now()}',
//         // const NotificationDetails(
//         //   android: AndroidNotificationDetails(
//         //     'my_foreground',
//         //     'MY FOREGROUND SERVICE',
//         //     icon: 'ic_bg_service_small',
//         //     ongoing: true,
//         //   ),
//         // );
//         // );

//         NotificationUtils.sendNotification(
//             1, 'MY FOREGROUND SERVICE', 'The app is running in fore ground.');

//         // if you don't using custom notification, uncomment this
//         service.setForegroundNotificationInfo(
//           title: "My App Service",
//           content: "Updated at ${DateTime.now()}",
//         );
//       }
//     }

//     /// you can see this log in logcat
//     debugPrint('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

//     // test using external plugin
//     final deviceInfo = DeviceInfoPlugin();
//     String? device;
//     if (Platform.isAndroid) {
//       final androidInfo = await deviceInfo.androidInfo;
//       device = androidInfo.model;
//     } else if (Platform.isIOS) {
//       final iosInfo = await deviceInfo.iosInfo;
//       device = iosInfo.model;
//     }

//     service.invoke(
//       'update',
//       {
//         "current_date": DateTime.now().toIso8601String(),
//         "device": device,
//       },
//     );
//   });
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late final GoRouter _router;

  // @override
  // void initState() {
  //   super.initState();
  //   _router = MyAppRouter().router;
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeChangerProvider()),
        ChangeNotifierProvider(create: (context) => UserAuthProvider()),
        ChangeNotifierProvider(create: (context) => VisitScreenProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => AttendanceProvider()),
        ChangeNotifierProvider(create: (context) => DeviceinfoProvider()),
        ChangeNotifierProvider(create: (context) => ReplayProvider()),
        ChangeNotifierProvider(create: (context) => CameraProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => MarketingProvider()),
        ChangeNotifierProvider(create: (context) => OfficerDetailProvider()),
        ChangeNotifierProvider(create: (context) => LiveTrackingProvider()),
      ],
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1.0),
        ),
        child: Builder(
          builder: (BuildContext context) {
            final themeChangerProvider =
                Provider.of<ThemeChangerProvider>(context);
            // return MaterialApp.router(
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              // routeInformationProvider: _router.routeInformationProvider,
              // routeInformationParser: _router.routeInformationParser,
              // routerDelegate: _router.routerDelegate,
              themeMode: themeChangerProvider.themeMode,
              darkTheme: ThemeData(
                brightness: Brightness.dark,
              ),
              theme: ThemeData(
                brightness: Brightness.light,
                primarySwatch: Colors.blue,
                // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              initialRoute: RouteGeneratorConstants.indexPage,
              onGenerateRoute: RouteGenerator.generateRoute,
            );
          },
        ),
      ),
    );
  }
}
