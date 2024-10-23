import 'package:flutter/material.dart';

class CustomExpansionTile extends StatelessWidget {

  final String title;
  // final Icon icon;
  final List<Widget> children;
  final double verticalPad;
  final double horizontalPad;
  final bool applyShadow;
  // final Function onExpansionChanged;

  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.children,
    this.applyShadow = true,
    // this.onExpansionChanged,
    this.horizontalPad = 16,
    this.verticalPad = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
       data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1.0,
              blurRadius: 5,
              offset: const Offset(3.0, 3.0),
            ),
          ],
        ),
        child: ExpansionTile(
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




