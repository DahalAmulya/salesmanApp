import 'package:deskgoo/providers/mr_officer_provider/mr_visitLog_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drop_downs/custom_dropdown.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MrOfficerVisitLogScreen extends StatefulWidget {
  const MrOfficerVisitLogScreen({super.key});

  @override
  State<MrOfficerVisitLogScreen> createState() =>
      _MrOfficerVisitLogStateScreen();
}

class _MrOfficerVisitLogStateScreen extends State<MrOfficerVisitLogScreen> {
  List<String> dateList = ["Today", "Yesterday", "Custom"];
  String defaultValue = "Today";
  String selectedDate = "";
  bool isVisible = false;

  Future<void> selectDate(
      BuildContext context, MrOfficeVisitLogProvider visitLogProvider) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );
    if (picked == null) {
      return;
    } else {
      setState(() {
        selectedDate = "${picked.year}-${picked.month}-${picked.day}";

        visitLogProvider.setSelectedDate(selectedDate);
      });
    }
    print(selectedDate);
    visitLogProvider.getVisitLogs();
  }

  void updateSelectedDate(String newValue) {
    final visitLogProvider =
        Provider.of<MrOfficeVisitLogProvider>(context, listen: false);
    setState(() {
      selectedDate = newValue;
      if (selectedDate == "Today") {
        selectedDate =
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
        visitLogProvider.setSelectedDate(selectedDate.toString().split(" ")[0]);
      } else if (selectedDate == "Yesterday") {
        DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
        visitLogProvider.setSelectedDate(yesterday.toString().split(" ")[0]);
        selectedDate = "${yesterday.year}-${yesterday.month}-${yesterday.day}";
      } else {
        // Open date picker for custom date selection
        selectDate(context, visitLogProvider);
      }
      print("Selected Date: $selectedDate");
    });
    visitLogProvider.getVisitLogs();
  }

  MrOfficeVisitLogProvider? _visitLogProvider;

  @override
  void initState() {
    _visitLogProvider =
        Provider.of<MrOfficeVisitLogProvider>(context, listen: false);
    _visitLogProvider?.getVisitLogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        Navigator.of(context).pop();
      }),
      child: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping outside TextFormFields
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: CustomColors.primaryWhite,
          appBar: _appBar(context),
          body: _buildUI(context),
        ),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Visit Logs',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTapLeadingIcon: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Consumer<MrOfficeVisitLogProvider>(
      builder: (context, visitLogProvider, _) {
        return ListView(
          children: [
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomText(
                      text: 'Select Date : ',
                      isContent: true,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomDropdown(
                        labelText: 'Select Date',
                        items: dateList,
                        value: defaultValue,
                        onChanged: (newValue) {
                          if (newValue != null) {
                            print('newValue = $newValue');
                            updateSelectedDate(
                                newValue.toString().split(' ')[0]);
                          }
                        }),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            visitLogProvider.visitLog.length != 0
                ? ListView.builder(
                    shrinkWrap:
                        true, // This allows it to take only the required height
                    physics:
                        NeverScrollableScrollPhysics(), // Disables scrolling for outer ListView, so the inner ListViews can handle scrolling
                    padding: EdgeInsets.all(0),
                    itemCount: visitLogProvider.visitLog.length,
                    itemBuilder: (context, index) {
                      String pocName =
                          visitLogProvider.visitLog[index]['pocName'];
                      String dateTime =
                          visitLogProvider.visitLog[index]['mobileTime'];
                      String time = dateTime.split(' ')[0];
                      String date = dateTime.split(' ')[1];
                      String remarks =
                          visitLogProvider.visitLog[index]['remarks'];
                      return ListTile(
                        onTap: () {
                          print(visitLogProvider.visitLog[index]);
                        },
                        title: CustomContainer(
                          applyShadow: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CustomText(
                                        text: 'Name', isContent: true),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: CustomText(
                                        text: pocName, isContent: true),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CustomText(
                                        text: 'Remarks', isContent: true),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: CustomText(
                                        text: remarks, isContent: true),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CustomText(
                                        text: 'Time', isContent: true),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: CustomText(
                                        text: '$time  $date', isContent: true),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 160.0),
                      child: CustomText(
                        text: 'No visit logs found for today',
                        isSubHeading: true,
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
