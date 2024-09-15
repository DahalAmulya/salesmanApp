import 'package:deskgoo/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  CustomText({
    required this.text,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.size = 16.0,
    this.textDecoration = TextDecoration.none,
    super.key,
  });

  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double size;
  final TextDecoration textDecoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      text,
      style: TextStyle(
        decoration: textDecoration,
        decorationColor: CustomColors.lightRed,
        decorationThickness: 2,
        fontWeight: fontWeight,
        fontSize: size,
        color: color,
      ),
    );
  }
}
