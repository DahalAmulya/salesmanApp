import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    // required this.noOfObj,
    // required this.objInPercentage,
    required this.isSquare,
    this.width = 5,
    this.height = 18,
    this.textColor,
    this.datatextColor,
  });
  final Color color;
  final String text;
  // final String noOfObj;
  // final String objInPercentage;
  final bool isSquare;
  final double width;
  final double height;
  final Color? textColor;
  final Color? datatextColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            Container(
              width: 5,
              height: 18,
              decoration: BoxDecoration(
                shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
                borderRadius: BorderRadius.circular(4),
                color: color,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
        // CustomText(
        //   text: '$noOfObj ($objInPercentage%)',
        //   size: 14,
        //   fontWeight: FontWeight.w600,
        //   color: datatextColor!,
        // ),
      ],
    );
  }
}

class MyCustomText {}
