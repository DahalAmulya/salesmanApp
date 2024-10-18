import 'dart:async';
import 'package:background_task/background_task.dart';
import 'package:deskgoo/classes/background_task_handler.dart';
import 'package:deskgoo/classes/notification_controller.dart';
import 'package:deskgoo/consts.dart';
import 'package:deskgoo/models/enviroment.dart';
import 'package:deskgoo/pages/mr_officers/mr_officers_providers/mr_officer_visit_provider.dart';
import 'package:deskgoo/providers/attendance_provider/remote_attendance_provider.dart';
import 'package:deskgoo/providers/camera_provider/camera_provider.dart';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/providers/live_tracking_provider/live_tracking_provider.dart';
import 'package:deskgoo/providers/replay_provider/replay_provider.dart';
import 'package:deskgoo/providers/marketing_provider/officerName_provider.dart';
import 'package:deskgoo/providers/marketing_provider/officerdetail_provider.dart';
import 'package:deskgoo/providers/marketing_provider/officersDescription_provider.dart';
import 'package:deskgoo/providers/settings_providers/profile_provider/profile_provider.dart';
import 'package:deskgoo/providers/visit_provider/order_provider.dart';
import 'package:deskgoo/providers/visit_provider/visit_screen_provider.dart';
import 'package:deskgoo/routes/route_generator.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:deskgoo/providers/auth_provider/user_auth_provider.dart';
import 'package:deskgoo/providers/themes_provider/theme_changer_provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(
    fileName: Enviroment.fileName,
  ); // fileName: '.env', is default fileName so no need to specify it
  if (kIsWeb) {
    print('Running on browser');
    runApp(
      DevicePreview(builder: (context) => const MyApp()),
    );
  } else {
    NotificationController.getPermissions();
    print('Not Running on browser');
    WidgetsFlutterBinding.ensureInitialized();
    BackgroundTask.instance.setAndroidNotification(
      title: 'Deskgoo',
      message: 'Running in the background',
      // icon: 'assets/icons/deskgoo.png',
    );
    BackgroundTask.instance
        .setBackgroundHandler(backgroundHandler); // 👈 Set callback handler.
    runApp(const MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    stopBackgroundServices();
  }

  void stopBackgroundServices() async {
    await BackgroundTask.instance.stop();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    if (state == AppLifecycleState.paused) {
      // getBackgroundLocation();
      print('----------------------------------------------------------------');
      print('\t\tApp is in background');
      isBackground = true;
      print('----------------------------------------------------------------');
    } else if (state == AppLifecycleState.resumed) {
      print('----------------------------------------------------------------');
      await BackgroundTask.instance.stop();
      isBackground = false;
      print('\t\tApp is in Foreground');
      print('----------------------------------------------------------------');
    }

    // final isBackground = state == AppLifecycleState.paused;
    // if (isBackground) {
    //   getBackgroundLocation();
    // } else {
    //   await BackgroundTask.instance.stop();
    // }
  }

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
        ChangeNotifierProvider(create: (context) => DetailsProvider()),
        ChangeNotifierProvider(create: (context) => MrOfficerVisitProvider()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final themeChangerProvider =
              Provider.of<ThemeChangerProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeChangerProvider.themeMode,
            darkTheme: ThemeData(
              brightness: Brightness.dark,
            ),
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              useMaterial3: true,
            ),
            initialRoute: RouteGeneratorConstants.indexPage,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}
