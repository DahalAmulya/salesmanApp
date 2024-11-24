import 'package:deskgoo/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  CustomText({
    required this.text,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.size = 16.0,
    this.textDecoration = TextDecoration.none,
    this.textOverflow = TextOverflow.ellipsis,
    this.isHeading = false,
    this.isSubHeading = false,
    this.isContent = false,
    this.isSubContent = false,
    this.isSmallText = false,
    super.key,
  });

  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double size;
  final TextDecoration textDecoration;
  final TextOverflow textOverflow;
  final bool isHeading;
  final bool isSubHeading;
  final bool isContent;
  final bool isSubContent;
  final bool isSmallText;

  @override
  Widget build(BuildContext context) {
    return Text(
      softWrap: true,
      overflow: textOverflow,
      text,
      style: TextStyle(
        decoration: textDecoration,
        decorationColor: CustomColors.lightRed,
        decorationThickness: 2,
        fontWeight: isHeading
            ? FontWeight.bold
            : isSubHeading
                ? FontWeight.w600
                : isContent
                    ? FontWeight.w400
                    : isSubContent
                        ? FontWeight.normal
                        : isSmallText
                            ? FontWeight.w400
                            : fontWeight,
        fontSize: isHeading
            ? 24
            : isSubHeading
                ? 20
                : isContent
                    ? 16
                    : isSubContent
                        ? 14
                        : isSmallText
                            ? 12
                            : size,
        color: color,
      ),
    );
  }
}
