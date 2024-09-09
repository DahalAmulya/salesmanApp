import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';

class NotchedBottomNavBar extends StatefulWidget {
  const NotchedBottomNavBar({super.key});

  @override
  State<NotchedBottomNavBar> createState() => _NotchedBottomNavBarState();
}

class _NotchedBottomNavBarState extends State<NotchedBottomNavBar> {
  List screens = [
    Center(
      child: CustomText(text: 'Screen 1'),
    ),
    Center(
      child: CustomText(text: 'Screen 2'),
    ),
    Center(
      child: CustomText(text: 'Screen 3'),
    ),
  ];

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.home),
            ),
          ],
        ),
      ),
    );
  }
}
