import 'package:date_picker_timeline/date_picker_timeline.dart';
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

class WeeklyPlanScreen extends StatefulWidget {
  WeeklyPlanScreen({super.key});

  @override
  State<WeeklyPlanScreen> createState() => _WeeklyPlanScreenState();
}

class _WeeklyPlanScreenState extends State<WeeklyPlanScreen> {
  bool isVisibleForStateList = false;


  List<String> foundStates = [];
  List<String> foundDistrict = [];
  bool isVisibleForDistrictList = false;
  DateTime _selectedDate = DateTime.now();
  late String dropDownValue;

  final stateTextEditingController = TextEditingController();
  final districtTextEditingController = TextEditingController();
  final searchForStatesTextEditingController = TextEditingController();
  final searchForDistrictTextEditingController = TextEditingController();

  String selectedDistrict = 'Baglung';
  String defaultValue = 'Nepal';
  String selectedState = 'Achham';
  String selectedCountry = '';
  List<String> country = ['Nepal', 'India'];

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
        SizedBox(
          height: 56,
        ),
        // CustomContainer(
        //   verticalPad: 16,
        //   horizontalPad: 16,
        //   horizontalMargin: 8,
        //   color: Colors.white,
        //   applyShadow: true,
        //   child: Column(
        //     children: [
        //       SizedBox(
        //         height: 8,
        //       ),
        //       CustomDropdown(
        //           labelText: 'Select Country',
        //           items: country,
        //           value: defaultValue,
        //           onChanged: (newValue) {
        //             selectedCountry = newValue!;
        //             setState(() {
        //               if (selectedCountry == country[0]) {
        //                 _AddTaskBottomSheetForDistrict(context);
        //               } else {
        //                 _AddTaskBottomSheetForStates(context);
        //                 // print(country[1]);
        //               }
        //             });
        //           }),
        //       SizedBox(
        //         height: 8,
        //       ),
        //       TextFromFieldWithPrefixSuffix(
        //         applyPrefix: true,
        //         prefixIcon: Icon(Icons.search),
        //         applySuffixIcon: true,
        //         suffixIcon: Icon(Icons.arrow_drop_down),
        //         controller: districtTextEditingController,
        //         labelText: 'Select District',
        //         onTap: () {
        //           // weeklyPlanProvider.setDistrictList();
        //           // _AddTaskBottomSheetForDistrict(context);
        //         },
        //         onChange: (value) => (){},
        //         validator: (Value) {},
        //       ),
        //       SizedBox(
        //         height: 8,
        //       ),
        //       TextFromFieldWithPrefixSuffix(
        //         applyPrefix: true,
        //         prefixIcon: Icon(Icons.search),
        //         applySuffixIcon: true,
        //         suffixIcon: Icon(Icons.arrow_drop_down),
        //         controller: stateTextEditingController,
        //         labelText: 'Select State',
        //         readOnly: true,
        //         onTap: () {
        //           // weeklyPlanProvider.setStateList();
        //           // _AddTaskBottomSheetForStates(context);
        //         },
        //         onChange: (value) => (){},
        //         validator: (Value) {},
        //       ),
        //     ],
        //   ),
        // ),
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8,vertical: 16),
                height: MediaQuery.of(context).size.height * 0.090,
                width: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(8),
                  color: Colors.grey.shade200
                ),
                child: CustomText(text: 'Marketing Meeting',size: 18,fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(text: 'Area:',fontWeight: FontWeight.w600,size: 18,),
                ],
              ),
              SizedBox(height: 8,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8,vertical: 16),
                height: MediaQuery.of(context).size.height * 0.090,
                width:  MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(8),
                    color: Colors.grey.shade200
                ),
                child: CustomText(text: 'Brt to Ghuski, Harinagar, Bhutha',size: 18,fontWeight: FontWeight.w600),
                // child: Custom,
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(text: 'Remark:',fontWeight: FontWeight.w600,size: 18,),
                ],
              ),
              SizedBox(height: 8,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8,vertical: 16),
                height: MediaQuery.of(context).size.height * 0.090,
                width:  MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(8),
                    color: Colors.grey.shade200
                ),
                child: CustomText(text: 'All Marketing Officer & Hospital CEO',size: 18,fontWeight: FontWeight.w600),
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

  //--------------------------------------Bottom Sheets----------------------------------------------------//

  Future<void> _AddTaskBottomSheetForStates(context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take up more space
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: _AddTaskBottomSheetForStatesAppBar(context),
            body: _AddTaskBottomSheetForStatesBody(context),
          ),
        ),
      ),
    );
  }

  PreferredSize _AddTaskBottomSheetForStatesAppBar(context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          showLeading: true,
          leadingIcon: FontAwesomeIcons.arrowLeft,
          backgroundColor: CustomColors.primaryColor,
          tabName: 'Select State',
          onTapLeadingIcon: () {
            Navigator.pop(context);
          },
        ));
  }

  Widget _AddTaskBottomSheetForStatesBody(context) {
    return ListView(
      children: [
        SizedBox(
          height: 16,
        ),
        Consumer<WeeklyPlanProvider>(builder: (context, weeklyPlanProvider, _) {
          return TextFromFieldWithPrefixSuffix(
            applyPrefix: true,
            prefixIcon: Icon(Icons.search),
            applySuffixIcon: true,
            suffixIcon: Icon(Icons.arrow_drop_down),
            controller: searchForStatesTextEditingController,
            labelText: 'Select State',
            onTap: () {
              // weeklyPlanProvider.setStateList();
            },
            onChange: (value) => weeklyPlanProvider
                .runStateSearchFilter(searchForStatesTextEditingController.value.text),
            validator: (Value) {},
          );
        }),
        Consumer<WeeklyPlanProvider>(builder: (context, weeklyPlanProvider, _) {
          return Container(
            child: ListView.builder(
              physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: weeklyPlanProvider.foundStates.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: CustomText(
                        text: weeklyPlanProvider.foundStates[index].toString()),
                    onTap: () {
                      selectedState = weeklyPlanProvider.foundStates[index];
                      stateTextEditingController.text = selectedState;
                      Navigator.pop(context);
                    },
                  );
                }),
          );
        })
      ],
    );
  }

//----------------------------------------------------------------------------------------------------------------//

  Future<void> _AddTaskBottomSheetForDistrict(context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take up more space
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: _AddTaskBottomSheetForDistrictAppBar(context),
            body: _AddTaskBottomSheetForDistrictBody(context),
          ),
        ),
      ),
    );
  }

  PreferredSize _AddTaskBottomSheetForDistrictAppBar(context){
    return PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          showLeading: true,
          leadingIcon: FontAwesomeIcons.arrowLeft,
          backgroundColor: CustomColors.primaryColor,
          tabName: 'Select District',
          onTapLeadingIcon: () {
            Navigator.pop(context);
          },
        ));
  }

  Widget _AddTaskBottomSheetForDistrictBody(context){
    return ListView(
      children: [
        SizedBox(height: 16,),
        Consumer<WeeklyPlanProvider>(
          builder: (context,weeklyPlanProvider,_) {
            return TextFromFieldWithPrefixSuffix(
              applyPrefix: true,
              prefixIcon: Icon(Icons.search),
              applySuffixIcon: true,
              suffixIcon: Icon(Icons.arrow_drop_down),
              controller: searchForDistrictTextEditingController,
              labelText: 'Select District',
              onTap: () {
                // weeklyPlanProvider.setDistrictList();
              },
              onChange: (value) => weeklyPlanProvider.runDistrictSearchFilter(searchForDistrictTextEditingController.value.text),
              validator: (Value) {},
            );
          }
        ),
        Consumer<WeeklyPlanProvider>(builder: (context, weeklyPlanProvider, _) {
          return Container(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: weeklyPlanProvider.foundDistrict.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: CustomText(
                        text: weeklyPlanProvider.foundDistrict[index].toString()),
                    onTap: () {
                      selectedState = weeklyPlanProvider.foundDistrict[index];
                      districtTextEditingController.text = selectedState;
                      Navigator.pop(context);
                    },
                  );
                }),
          );
        })
      ],
    );
  }

}

