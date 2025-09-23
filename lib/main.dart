import 'dart:async';
import 'package:deskgoo/models/environment.dart';
import 'package:deskgoo/pages/mr_admin/mr_admin_providers/mr_admin_ambulancereport_provider.dart';
import 'package:deskgoo/pages/mr_admin/mr_admin_providers/mr_admin_attendancereport_provider.dart';
import 'package:deskgoo/pages/mr_admin/mr_admin_providers/mr_admin_createuser_provider.dart';
import 'package:deskgoo/pages/mr_admin/mr_admin_providers/mr_admin_referral%20log_provider.dart';
import 'package:deskgoo/providers/profile/profile_provider.dart';
import 'package:deskgoo/providers/attendance_provider/remote_attendance_provider.dart';
import 'package:deskgoo/providers/auth_provider/change_password_provider.dart';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/providers/live_tracking_provider/live_tracking_provider.dart';
import 'package:deskgoo/providers/login_provider/login_provider.dart';
import 'package:deskgoo/providers/mr_admin_provider/mr_admin_area_reportProvider.dart';
import 'package:deskgoo/providers/mr_admin_provider/mr_admin_visit_logProvider.dart';
import 'package:deskgoo/providers/mr_officer_provider/mr_followup_provider.dart';
import 'package:deskgoo/providers/mr_officer_provider/mr_referral_provider.dart';
import 'package:deskgoo/providers/mr_officer_provider/mr_visitLog_provider.dart';
import 'package:deskgoo/providers/mr_officer_provider/mr_visit_provider.dart';
import 'package:deskgoo/providers/profile_provider/profile_provider.dart';
import 'package:deskgoo/providers/replay_provider/replay_provider.dart';
import 'package:deskgoo/providers/marketing_provider/officerName_provider.dart';
import 'package:deskgoo/providers/marketing_provider/officerdetail_provider.dart';
import 'package:deskgoo/providers/marketing_provider/officersDescription_provider.dart';
import 'package:deskgoo/providers/visit_provider/order_provider.dart';
import 'package:deskgoo/providers/visit_provider/visit_screen_provider.dart';
import 'package:deskgoo/providers/weeklyplan_provider/weeklyplan_provider.dart';
import 'package:deskgoo/routes/route_generator.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/utils/readUserCred.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:deskgoo/providers/auth_provider/user_auth_provider.dart';
import 'package:deskgoo/providers/themes_provider/theme_changer_provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_msg.dart';
import 'firebase_options.dart';
import 'notifications/notiService.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // print("Native called background task: $task"); //simpleTask will be emitted here.
    // print("inputData = $inputData");
    // You can see the notification
    if(task == 'download_task'){
      debugPrint('**********************************************************************');
      debugPrint('Background download task executed');
      debugPrint('data = $inputData');
      debugPrint('**********************************************************************');
    }
    if(task == 'upload_task'){
      debugPrint('Background upload task executed');
    }
    NotiService().showNotification(
      title: 'Deskgoo',
      body: 'Background Notification $inputData',
    );
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ ADD THIS FIRST!

  NotiService().initNotification();
  
  Workmanager().initialize(callbackDispatcher);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await FirebaseMsg().initFCM();

  await dotenv.load(
    fileName: Environment.fileName,
  ); // fileName: '.env', is default fileName so no need to specify it
  // CloudinaryContext.cloudinary = Cloudinary.fromCloudName(cloudName: cloudinaryName);
  if (kIsWeb) {
    print('Running on browser');
    runApp(
      DevicePreview(builder: (context) => const MyApp()),
    );
  } else {
    // WidgetsFlutterBinding
    //     .ensureInitialized(); // Ensure Flutter bindings are initialized
    UserCred().readUserCred();
    // NotificationController.getPermissions();
    // print('Not Running on browser');
    // // WidgetsFlutterBinding.ensureInitialized();

    // BackgroundTask.instance.setAndroidNotification(
    //   title: 'Deskgoo',
    //   message: 'Running in the background',
    // );
    // BackgroundTask.instance.setBackgroundHandler(backgroundHandler);

    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeChangerProvider()),
        ChangeNotifierProvider(create: (context) => UserAuthProvider()),
        ChangeNotifierProvider(create: (context) => ChangePasswordProvider()),
        ChangeNotifierProvider(create: (context) => VisitScreenProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => AttendanceProvider()),
        ChangeNotifierProvider(create: (context) => DeviceInfoProvider()),
        ChangeNotifierProvider(create: (context) => ReplayProvider(context)),
        // ChangeNotifierProvider(create: (context) => CameraProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => MarketingProvider()),
        ChangeNotifierProvider(create: (context) => OfficerDetailProvider()),
        ChangeNotifierProvider(create: (context) => MrAdminVisitLogProvider()),
        ChangeNotifierProvider(create: (context) => LiveTrackingProvider(context)),
        ChangeNotifierProvider(create: (context) => DetailsProvider()),
        ChangeNotifierProvider(create: (context) => MrOfficerVisitProvider()),
        ChangeNotifierProvider(create: (context) => MrOfficeVisitLogProvider()),
        ChangeNotifierProvider(
            create: (context) => MrOfficerFollowUpProvider()),
        ChangeNotifierProvider(create: (context) => WeeklyPlanProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ReferralsDetailProvider()),
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => CreateUserProvider()),
        ChangeNotifierProvider(create: (context) => MrAdminAreaReportProvider()),
        ChangeNotifierProvider(create: (context) => MrAdminReferralLogProvider()),
        ChangeNotifierProvider(create: (context) => MrAdminAttendanceProvider()),
        ChangeNotifierProvider(create: (context) => MrAdminAmbulanceReportProvider()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final themeChangerProvider =
              Provider.of<ThemeChangerProvider>(context);
          // return MaterialApp.router(
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeChangerProvider.themeMode,
            darkTheme: ThemeData(brightness: Brightness.dark),
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              useMaterial3: true,
            ),
            // routerConfig: appRouter,
            initialRoute: MarketingManagerConstants.splash,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}
