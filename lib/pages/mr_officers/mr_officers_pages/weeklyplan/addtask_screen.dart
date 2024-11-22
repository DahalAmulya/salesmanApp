import 'package:deskgoo/providers/weeklyplan_provider/weeklyplan_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
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
              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
              child: CustomText(
                  text: weeklyPlanProvider.getFormattedDate(),
                  size: 20,
                  fontWeight: FontWeight.w600,
              ),
            );
          }
        ),
        // CustomText(text: 'Activity:'),
        CustomContainer(
          applyShadow: true,
          verticalPad: 18,
          horizontalPad: 18,
          verticalMargin: 16,
          horizontalMargin: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFromFieldWithPrefixSuffix(
                controller: taskActivityController,
                autoFocus: false,
                hintText: 'Activity',
                labelText: 'Activity note',
                minLine: 6,
                maxLines: 6,
                validator: (value) {
                  // print(visitScreenProvider.followUpNote);
                  return value!.isEmpty
                      ? 'Activity note is required'
                      : value.length < 3
                      ? 'Enter at least 3 characters'
                      : null;
                },
                onChange: (value) {
                  // visitScreenProvider.setFollowUpNote(value!);
                },
                onTap: () {},
              ),
              SizedBox(height: 8,),
              TextFromFieldWithPrefixSuffix(
                controller: taskAreaController,
                autoFocus: false,
                hintText: 'Area',
                labelText: 'Area note',
                minLine: 6,
                maxLines: 6,
                validator: (value) {
                  // print(visitScreenProvider.followUpNote);
                  return value!.isEmpty
                      ? 'Visiting Area name is required'
                      : value.length < 3
                      ? 'Enter at least 3 characters'
                      : null;
                },
                onChange: (value) {
                  // visitScreenProvider.setFollowUpNote(value!);
                },
                onTap: () {},
              ),
              SizedBox(height: 8,),
              TextFromFieldWithPrefixSuffix(
                controller: taskRemarkController,
                autoFocus: false,
                hintText: 'Remark',
                labelText: 'Remark note',
                minLine: 6,
                maxLines: 6,
                validator: (value) {
                  // print(visitScreenProvider.followUpNote);
                  return value!.isEmpty
                      ? 'Remark note is required'
                      : value.length < 3
                      ? 'Enter at least 3 characters'
                      : null;
                },
                onChange: (value) {
                  // visitScreenProvider.setFollowUpNote(value!);
                },
                onTap: () {},
              ),
              SizedBox(height: 8,),
              CustomElevatedButton(
                  onPressed: (){},
                  backgroundColor: CustomColors.primaryColor,
                  widget: CustomText(
                      text: 'Submit'
                  )
              )
            ],
          ),
        ),
      ],
    ),
  );
}