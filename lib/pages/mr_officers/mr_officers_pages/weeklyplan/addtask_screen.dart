import 'package:deskgoo/providers/weeklyplan_provider/weeklyplan_provider.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../routes/marketing_officer_consts.dart';
import '../../../../widgets/app_bars/custom_app_bars.dart';
import '../../../../widgets/drawers/mr_officer_custom_drawer.dart';
import '../../../../widgets/text_fields/text_from_field.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        Navigator.of(context)
            .pushNamed(MarketingOfficerConstants.weeklyPlanConst);
      }),
      child: GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        child: Scaffold(
          appBar: _appbar(context),
          drawer: MrOfficerCustomDrawer(
            isWeeklyPlanActive: true,
          ),
          body: _body(context),
        ),
      ),
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
            leadingIcon: FontAwesomeIcons.arrowLeft,
            onTapLeadingIcon: (){
              print('hello');
              Navigator.of(context)
                  .pushNamed(MarketingOfficerConstants.weeklyPlanConst);
            },
          );
        }
    ),
  );
}

Widget _body(context){
  final _addTaskFormKey = GlobalKey<FormState>();
  final taskActivityController = TextEditingController();
  final taskAreaController = TextEditingController();
  final taskRemarkController = TextEditingController();

  return Form(
    key: _addTaskFormKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<WeeklyPlanProvider>(
          builder: (context,weeklyPlanProvider,_) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 8,),
              child: CustomText(
                  text: weeklyPlanProvider.getFormattedDate(),
                  size: 20,
                  fontWeight: FontWeight.w600,
              ),
            );
          }
        ),
        CustomText(text: 'Activity:'),
        // TextFromFieldWithPrefixSuffix(
        //   controller: null,
        //   validator: () { },
        //
        // ),
      ],
    ),
  );
}