import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class WeeklyPlanScreen extends StatelessWidget {
  const WeeklyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
      drawer: CustomDrawer(
        isWeeklyPlanActive: true,
      ),
      body: _body(context),
    );
  }
}

PreferredSize _appbar(context){
  return PreferredSize(
    preferredSize: Size.fromHeight(kToolbarHeight),
    child: Builder(
      builder: (context) {
        return CustomAppBar(
            tabName: 'Weekly Plan',
             showLeading: true,
             leadingIcon: FontAwesomeIcons.bars,
            onTapLeadingIcon: (){
              print('hello');
              Scaffold.of(context).openDrawer();
            },
        );
      }
    ),
  );
}

Widget _body(context){
  return Column(
    children: [
      Row(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8,vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    text: (DateFormat.yMMMMd().format(DateTime.now())),
                  size: 20,
                  fontWeight: FontWeight.w600,

                ),
                CustomText(
                    text: 'Today',
                   size: 24,
                  fontWeight: FontWeight.w600,
                )
              ],
            ),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            width: MediaQuery.of(context).size.width * 0.30,
            height: MediaQuery.of(context).size.height * 0.048,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: CustomColors.primaryColor,
            ),
            child: Center(
              child: CustomText(
                  text: '+Add Task',
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    ]
  );
}
