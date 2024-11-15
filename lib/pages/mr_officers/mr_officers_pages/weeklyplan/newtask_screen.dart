import 'package:deskgoo/providers/weeklyplan_provider/weeklyplan_provider.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/app_bars/custom_app_bars.dart';
import '../../../../widgets/drawers/mr_officer_custom_drawer.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
      drawer: MrOfficerCustomDrawer(
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
            tabName: 'New Task',
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
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Consumer<WeeklyPlanProvider>(
        builder: (context,weeklyPlanProvider,_) {
          return Container(
            child: CustomText(
                text: weeklyPlanProvider.selectedDate.toString(),
            ),
          );
        }
      )
    ],
  );
}