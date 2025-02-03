import 'dart:convert';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:deskgoo/consts.dart';
import 'package:deskgoo/providers/weeklyplan_provider/weeklyplan_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/expansion_tile/custom_expansiontile.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../routes/marketing_officer_consts.dart';
import '../../../../widgets/drawers/mr_officer_custom_drawer.dart';
import '../../../../widgets/drop_downs/custom_dropdown.dart';
import '../../../../widgets/text_fields/text_from_field.dart';
import '../../../services/erp_services.dart';

class WeeklyPlanScreen extends StatefulWidget {
  WeeklyPlanScreen({super.key});

  @override
  State<WeeklyPlanScreen> createState() => _WeeklyPlanScreenState();
}

class _WeeklyPlanScreenState extends State<WeeklyPlanScreen> {

  bool isVisibleForDistrictList = false;
  DateTime _selectedDate = DateTime.now();

  final _addTaskFormKey = GlobalKey<FormState>();
  final taskActivityController = TextEditingController();
  final taskAreaController = TextEditingController();
  final taskRemarkController = TextEditingController();

  final taskActivityNoteController = TextEditingController();
  final taskAreaNoteController = TextEditingController();
  final taskRemarkNoteController = TextEditingController();

  final Url = 'http://202.51.3.49:8002/api/plan/today?userId=679b632e4c526fbfe839ada5';
  Map<String,dynamic> todaysPlan = {};
  String activity = '';
  String area = '';
  String remark = '';

  Future<void> getTodayPlan(planDate) async{
    ERPResponse response = await ERPServices.getRequest("/plan/today?userId=$userId&planDate=$planDate");
    var decodedData = jsonDecode(response.body);
    print(decodedData);

    if(response.statusCode == 200) {
      todaysPlan = decodedData;
      // print(todaysPlan['activity'] ?? 'key not found');
      print(todaysPlan);
      setState(() {
        activity = todaysPlan['todaysPlan']['activity'];
        area = todaysPlan['todaysPlan']['area'];
        remark = todaysPlan['todaysPlan']['remark'];
      });

      print(response.statusCode);
      // print(response.body.runtimeType);
      // print(response.body);
    }else{
      print(response.body);

    }
  }

  @override
  void initState() {
    super.initState();
    getTodayPlan(DateTime.now().toString().split(" ")[0]);
  }


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
          backgroundColor: CustomColors.primaryWhite,
          appBar: _appbar(context),
          drawer: MrOfficerCustomDrawer(
            isWeeklyPlanActive: true,
          ),
          body: _body(context),
        ),
      ),
    );
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
    final weeklyPlanProvider =
        Provider.of<WeeklyPlanProvider>(context, listen: false);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        // weeklyPlanProvider.setSelectedDate(_selectedDate);
                        // Navigator.of(context)
                        //     .pushNamed(MarketingOfficerConstants.addTaskConst);
                        openAlertDialog(context);
                        // getTodayPlan();
                        // print('hhello');
                      },
                      backgroundColor: CustomColors.primaryColor,
                      widget: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 16,
                          ),
                          CustomText(text: ' Create Plan'),
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
        Consumer<WeeklyPlanProvider>(
          builder: (context,weeklyPlanProvider,_) {
            return Container(
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
                  weeklyPlanProvider.updateDate(newDate);
                  getTodayPlan(newDate.toString().split(" ")[0]);
                  print(newDate);
                },
              ),
            );
          }
        ),
        SizedBox(
          height: 56,
        ),
        CustomContainer(
            applyShadow: true,
            verticalPad: 18,
            horizontalPad: 24,
            verticalMargin: 18,
            horizontalMargin: 18,
            child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(text: 'Activity:',fontWeight: FontWeight.w600,size: 18,),
                ],
              ),
              SizedBox(height: 8,),
              Consumer<WeeklyPlanProvider>(
                builder: (context,weeklyPlanProvider,_) {
                  return TextFromFieldWithPrefixSuffix(
                      readOnly: true,
                      hintText: '$activity',
                      controller: weeklyPlanProvider.taskActivityNoteController,
                      validator: (validator){

                      }
                  );
                }
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(text: 'Area:',fontWeight: FontWeight.w600,size: 18,),
                ],
              ),
              SizedBox(height: 8,),
              Consumer<WeeklyPlanProvider>(
                builder: (context,weeklyPlanProvider,_) {
                  return TextFromFieldWithPrefixSuffix(
                      readOnly: true,
                      hintText: '$area',
                      controller: weeklyPlanProvider.taskAreaNoteController,
                      validator: (validator){

                      }
                  );
                }
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(text: 'Remark:',fontWeight: FontWeight.w600,size: 18,),
                ],
              ),
              SizedBox(height: 8,),
              Consumer<WeeklyPlanProvider>(
                builder: (context,weeklyPlanProvider,_) {
                  return TextFromFieldWithPrefixSuffix(
                      readOnly: true,
                      hintText: '$remark',
                      controller: weeklyPlanProvider.taskRemarkNoteController,
                      validator: (validator){

                      }
                  );
                }
              ),
            ],
                          )
        ),
        // SizedBox(height: 8,),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Center(child: CustomText(text: 'Plan not created for')),
        //     Consumer<WeeklyPlanProvider>(
        //         builder: (context, weeklyPlanProvider, _) {
        //           return Container(
        //             child: Center(
        //               child: CustomText(
        //                 text:
        //                 '${DateFormat('dd MMM y, EE').format(DateTime.now())}',
        //               ),
        //             ),
        //           );
        //         }),
        //   ],
        // ),
      ]),
    );
  }
  //----------------------------------------------------------------AlertDialog----------------------------------------------------------------//


  void openAlertDialog(context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: CustomColors.primaryWhite,
            elevation: 10,
            title: Center(child: CustomText(text: 'New Task',size: 24,fontWeight: FontWeight.w600,)),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: SingleChildScrollView(
                child: Form(
                  key: _addTaskFormKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: 'Activity',fontWeight: FontWeight.w600,size: 18,),
                      SizedBox(height: 8,),
                      Consumer<WeeklyPlanProvider>(
                        builder: (context,weeklyPlanProvider,_) {
                          return TextFromFieldWithPrefixSuffix(
                            controller: weeklyPlanProvider.taskActivityController,
                            autoFocus: false,
                            hintText: 'Activity',
                            labelText: 'Activity note',
                            maxLines: 2,
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
                          );
                        }
                      ),
                      SizedBox(height: 8,),
                      CustomText(text: 'Area',fontWeight: FontWeight.w600,size: 18,),
                      SizedBox(height: 8,),
                      Consumer<WeeklyPlanProvider>(
                        builder: (context,weeklyPlanProvider,_) {
                          return TextFromFieldWithPrefixSuffix(
                            controller: weeklyPlanProvider.taskAreaController,
                            autoFocus: false,
                            hintText: 'Area',
                            labelText: 'Area note',
                            maxLines: 2,
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
                          );
                        }
                      ),
                      SizedBox(height: 8,),
                      CustomText(text: 'Remark',fontWeight: FontWeight.w600,size: 18,),
                      SizedBox(height: 8,),
                      Consumer<WeeklyPlanProvider>(
                        builder: (context,weeklyPlanProvider,_) {
                          return TextFromFieldWithPrefixSuffix(
                            controller: weeklyPlanProvider.taskRemarkController,
                            autoFocus: false,
                            hintText: 'Remark',
                            labelText: 'Remark note',
                            maxLines: 2,
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
                            onTap: () {

                              // Navigator.pop(context);
                            },
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Consumer<WeeklyPlanProvider>(
                builder: (context,weeklyPlanProvider,_) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomElevatedButton(
                          onPressed: (){
                              // weeklyPlanProvider.setNewTask();
                            weeklyPlanProvider.postRequest(context);
                            weeklyPlanProvider.getAllPlans();
                              Navigator.pop(context);

                          },
                          backgroundColor: CustomColors.primaryColor,
                          widget: CustomText(
                              text: 'Submit'
                          )
                      ),
                    ],
                  );
                }
              ),
            ],
          );
        }
    );
  }
}

