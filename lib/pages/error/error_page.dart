import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: CustomText(
          text: 'Error Page',
          size: 32,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      body: Center(
        child: CustomText(
          text: '404 Page Not Found',
          size: 24,
          fontWeight: FontWeight.w500,
          color: Colors.red,
        ),
      ),
    );
  }
}
