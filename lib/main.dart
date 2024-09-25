import 'package:deskgoo/providers/attendance_provider/remote_attendance_provider.dart';
import 'package:deskgoo/providers/camera_provider/camera_provider.dart';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/providers/replay_provider/replay_provider.dart';
import 'package:deskgoo/providers/settings_providers/profile_provider/profile_provider.dart';
import 'package:deskgoo/providers/visit_provider/order_provider.dart';
import 'package:deskgoo/providers/visit_provider/visit_screen_provider.dart';
import 'package:deskgoo/routes/route_generator.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:deskgoo/providers/auth_provider/user_auth_provider.dart';
import 'package:deskgoo/providers/themes_provider/theme_changer_provider.dart';
import 'package:deskgoo/routes/app_route_configuration.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';

void main() async {
  if (kIsWeb) {
    print('Running on browser');
    runApp(
      DevicePreview(builder: (context) => const MyApp()),
    );
  } else {
    print('Not Running on browser');
    // WidgetsFlutterBinding.ensureInitialized();
    // FlutterBackgroundService();
    runApp(const MyApp());
  }
}

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
