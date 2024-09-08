import 'package:deskgoo/tests/pages/home_screen.dart';
import 'package:deskgoo/tests/providers/count_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:deskgoo/tests/pages/products_page.dart';
import 'package:deskgoo/tests/pages/cart_page.dart';
import 'package:deskgoo/tests/providers/cart_provider.dart';

void main() {
  runApp(
    // ChangeNotifierProvider(
    //   create: (context) => CartProvider(),
    //   child: const MyApp(),
    // ),
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CountProvider(),
        ),
      ],
      child: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          // home: const ProductsPage(),
          initialRoute: '/home',
          routes: {
            '/products': (context) => const ProductsPage(),
            '/cart': (context) => const CartPage(),
            '/home': (context) => const HomeScreen(),
          },
        ),
      ),
    );
  }
}
