import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';

class WeeklyPlanScreen extends StatelessWidget {
  const WeeklyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
      body: _body(context),
    );
  }
}

PreferredSize _appbar(context){
  return PreferredSize(
    preferredSize: Size.fromHeight(kToolbarHeight),
    child: CustomAppBar(
        tabName: 'tabName'
    ),
  );
}

Widget _body(context){
  return Container(
    child: CustomText(text: 'hello'),
  );
}
