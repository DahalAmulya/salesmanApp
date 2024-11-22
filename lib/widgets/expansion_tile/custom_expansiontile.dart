import 'package:flutter/material.dart';

class CustomExpansionTile extends StatelessWidget {

  final String title;
  // final Icon icon;
  final List<Widget> children;
  final double verticalPad;
  final double horizontalPad;
  final bool applyShadow;
  final bool initiallyExpanded;
  final double radiusTopLeft;
  final double radiusTopRight;
  final double radiusBottomLeft;
  final double radiusBottomRight;
  final double verticalMargin;
  final double horizontalMargin;
  // final Function onExpansionChanged;

  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.children,
    this.applyShadow = true,
    this.initiallyExpanded = false,
    this.radiusTopLeft = 0,
    this.radiusTopRight = 0,
    this.radiusBottomLeft = 0,
    this.radiusBottomRight = 0,
    // required
    // this.onExpansionChanged,
    this.horizontalPad = 16,
    this.verticalPad = 0,
    this.verticalMargin = 0,
    this.horizontalMargin = 0,
     // required
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
       data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: verticalMargin,horizontal: horizontalMargin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(radiusTopLeft), topRight: Radius.circular(radiusTopRight),bottomRight: Radius.circular(radiusBottomRight),bottomLeft: Radius.circular(radiusBottomLeft)),
          color: Colors.white,
          boxShadow: applyShadow ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1.0,
              blurRadius: 5.0,
              offset: const Offset(0, -2),
            ),
          ] : [],
        ),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          childrenPadding: EdgeInsets.symmetric(horizontal: horizontalPad,vertical: verticalPad),
            title: Text(title),
            trailing: Icon(Icons.keyboard_arrow_down),
            children: children,
            onExpansionChanged: (bool value){
              // setState(() => _customIcon = value);
            },
          ),
      ),
    );
  }
}




