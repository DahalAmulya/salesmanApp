import 'package:deskgoo/pages/mr_officers/mr_officers_providers/mr_officer_visit_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/radio_button/custom_radio_button.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MROfficersVisitsScreen extends StatefulWidget {
  const MROfficersVisitsScreen({super.key});

  @override
  State<MROfficersVisitsScreen> createState() => _MROfficersVisitsScreenState();
}

class _MROfficersVisitsScreenState extends State<MROfficersVisitsScreen>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;
  List<String> tabs = [
    'New Visit',
    'Create Visit',
    'FollowUp Visit',
    'Visit Details',
  ];
  double scrollOffset = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: _appBar(context),
      // body: _buildUI(context),
      body: _chooseVisitType(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(tabName: 'MROfficersVisitsScreen'),
    );
  }

  Widget _chooseVisitType(context) {
    return Center(
      child: Consumer<MrOfficerVisitProvider>(
          builder: (context, visitProvider, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomContainer(
              child: Column(
                children: [
                  CustomText(
                    text: 'Select Visit Type',
                    fontWeight: FontWeight.w600,
                    size: 22,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomRadioButton(
                    radioGroupValue: visitProvider.radioGroupValue,
                    radioValue: 'Create Visit',
                    radioTitle: 'Create Visit',
                    onChange: (value) {
                      visitProvider.selectVisitType(value);
                    },
                  ),
                  CustomRadioButton(
                    radioGroupValue: visitProvider.radioGroupValue,
                    radioValue: 'New Visit',
                    radioTitle: 'New Visit',
                    onChange: (value) {
                      visitProvider.selectVisitType(value);
                    },
                  ),
                  CustomRadioButton(
                    radioGroupValue: visitProvider.radioGroupValue,
                    radioValue: 'FollowUp Visit',
                    radioTitle: 'FollowUp Visit',
                    onChange: (value) {
                      visitProvider.selectVisitType(value);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomElevatedButton(
                        onPressed: () {
                          visitProvider.unSelectVisitType();
                          Navigator.of(context)
                              .pop(RouteGeneratorConstants.homePage);
                        },
                        // backgroundColor: ,
                        borderColor: CustomColors.lightRed,
                        widget: CustomText(
                          text: 'Cancel',
                          color: CustomColors.lightRed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      CustomElevatedButton(
                        onPressed: () {},
                        borderColor: CustomColors.primaryColor,
                        widget: CustomText(
                          text: 'Next',
                          color: CustomColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildUI(context) {
    return GestureDetector(
      onTap: () {
        print('Tapepd on body');
      },
      onHorizontalDragEnd: (details) {
        // Swiping in right direction.
        if (details.primaryVelocity! > 0) {
          setState(() {
            if (tabIndex > 0) {
              tabIndex -= 1;
              scrollOffset = 100;
            }
          });
          // print('${details.delta.dx}');
          print('Swipped right $tabIndex ${tabIndex > 0}');
        }

        // Swiping in left direction.
        if (details.primaryVelocity! < 0) {
          setState(() {
            if (tabIndex < tabs.length - 1) {
              tabIndex += 1;
              scrollOffset = 200;
            }
            // tabIndex < tabs.length ? tabIndex + 1 : null;
          });
          print('Swipped left $tabIndex ${tabIndex < tabs.length}');
          // print('${details.delta.dx}');
        }
      },
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        height: double.infinity,
        color: Colors.grey.shade200,
        child: ListView(
          children: [
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      print('Pressed ${tabs[index]}');
                      setState(() {
                        tabIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      color: (tabIndex == 0 && index == 0)
                          ? Colors.red
                          : (tabIndex == 1 && index == 1)
                              ? Colors.yellow
                              : (tabIndex == 2 && index == 2)
                                  ? Colors.purpleAccent
                                  : (tabIndex == 3 && index == 3)
                                      ? Colors.lightGreenAccent
                                      : Colors.white,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.all(8),
                      width: 120,
                      height: 40,
                      child: Center(
                        child: CustomText(
                          text: '${tabs[index]}',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            GestureDetector(
              // position: _offsetAnimation,
              child: tabIndex == 0
                  ? _newVisit(context)
                  : tabIndex == 1
                      ? _createVisit(context)
                      : tabIndex == 2
                          ? _followUpVisit(context)
                          : tabIndex == 3
                              ? _visitDetails(context)
                              : Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _newVisit(context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 400,
      width: double.infinity,
      color: Colors.red,
      child: Center(
        child: CustomText(text: 'New Visit'),
      ),
    );
  }

  Widget _createVisit(context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 400,
      width: double.infinity,
      color: Colors.yellow,
      child: Center(
        child: CustomText(text: 'Create Visit'),
      ),
    );
  }

  Widget _visitDetails(context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 400,
      width: double.infinity,
      color: Colors.lightGreenAccent,
      child: Center(
        child: CustomText(text: 'Visit Details'),
      ),
    );
  }

  Widget _followUpVisit(context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 400,
      width: double.infinity,
      color: Colors.purpleAccent,
      child: Center(
        child: CustomText(text: 'FollowUp Visit'),
      ),
    );
  }
}
