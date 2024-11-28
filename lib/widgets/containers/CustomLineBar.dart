import 'package:deskgoo/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomLineBar extends StatelessWidget {
  const CustomLineBar({this.barColor, super.key});
  final Color? barColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      width: 5,
      decoration: BoxDecoration(
        color: barColor ?? CustomColors.primaryColor,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
