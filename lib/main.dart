import 'package:deskgoo/providers/auth_provider/user_auth_provider.dart';
import 'package:deskgoo/providers/themes_provider/theme_changer_provider.dart';
import 'package:deskgoo/routes/app_route_configuration.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = MyAppRouter().router;
  }

  @override
  Widget build(BuildContext context) {
    // final themeChangerProvider = Provider.of<ThemeChangerProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeChangerProvider())
        ChangeNotifierProvider(create: (context) => ThemeChangerProvider()),
        ChangeNotifierProvider(create: (context) => UserAuthProvider()),
      ],
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1.0),
        ),
        child: Builder(
          builder: (BuildContext context) {
            final themeChangerProvider =
                Provider.of<ThemeChangerProvider>(context);
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routeInformationProvider: _router.routeInformationProvider,
              routeInformationParser: _router.routeInformationParser,
              routerDelegate: _router.routerDelegate,
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
            );
          },
        ),
      ),
    );
  }
}
