import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:deskgoo/providers/weeklyplan_provider/weeklyplan_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../routes/marketing_officer_consts.dart';
import '../../../../widgets/drawers/mr_officer_custom_drawer.dart';

class WeeklyPlanScreen extends StatefulWidget {
  WeeklyPlanScreen({super.key});

  @override
  State<WeeklyPlanScreen> createState() => _WeeklyPlanScreenState();
}

class _WeeklyPlanScreenState extends State<WeeklyPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        // GoRouter.of(context)
        //     .pushReplacementNamed(MyAppRouteConstants.homeNavBarRouteName);
        Navigator.of(context)
            .pushNamed(MarketingOfficerConstants.mrStaffDashboardConst);
      }),
      child: GestureDetector(
        onTap: () {
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

PreferredSize _appbar(context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(kToolbarHeight),
    child: Builder(builder: (context) {
      return CustomAppBar(
        tabName: 'Weekly Plan',
        showLeading: true,
        leadingIcon: FontAwesomeIcons.bars,
        onTapLeadingIcon: () {
          print('hello');
          Scaffold.of(context).openDrawer();
        },
      );
    }),
  );
}

Widget _body(context) {
  DateTime _selectedDate = DateTime.now();
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: (DateFormat('dd MMM y, EE').format(DateTime.now())),
                size: 20,
                fontWeight: FontWeight.w600,
              ),
              Consumer<WeeklyPlanProvider>(
                  builder: (context, weeklyPlanProvider, _) {
                return CustomElevatedButton(
                  onPressed: () {
                    print('hello');
                    weeklyPlanProvider.setSelectedDate(_selectedDate);
                    Navigator.of(context)
                        .pushNamed(MarketingOfficerConstants.addTaskConst);
                  },
                  backgroundColor: CustomColors.primaryColor,
                  widget: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 16,
                      ),
                      CustomText(text: ' Add Task'),
                    ],
                  ),
                );
              }),
            ],
          ),
          CustomText(
            text: 'Today',
            size: 24,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    ),
    Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: CustomColors.primaryColor,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        onDateChange: (newDate) {
          _selectedDate = newDate;
        },
      ),
    ),
    Consumer<WeeklyPlanProvider>(
      builder: (context,weeklyPlanProvider,_) {
        return Container(
          child: CustomText(
              text: 'Plan not created for '
          ),
        );
      }
    )
  ]);
}
