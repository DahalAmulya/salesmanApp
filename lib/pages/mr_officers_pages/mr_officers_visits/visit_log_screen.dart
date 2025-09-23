import 'package:deskgoo/providers/mr_officer_provider/mr_visitLog_provider.dart';
import 'package:deskgoo/providers/mr_officer_provider/mr_visit_provider.dart';
import 'package:deskgoo/services/database_service.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/utils/toast_message.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drop_downs/custom_dropdown.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:provider/provider.dart';

class MrOfficerVisitLogScreen extends StatefulWidget {
  const MrOfficerVisitLogScreen({super.key});

  @override
  State<MrOfficerVisitLogScreen> createState() =>
      _MrOfficerVisitLogStateScreen();
}

class _MrOfficerVisitLogStateScreen extends State<MrOfficerVisitLogScreen> {
  // List<String> dateList = ["Today", "Yesterday", "Custom", "Offline Visit"];
  // String defaultValue = "Today";
  // String selectedDate = "";
  // bool isVisible = false;
  // final DatabaseService _dbService = DatabaseService.instance;

  MrOfficeVisitLogProvider? _visitLogProvider;

  @override
  void initState() {
    _visitLogProvider =
        Provider.of<MrOfficeVisitLogProvider>(context, listen: false);
    _visitLogProvider?.getVisitLogs(context);
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
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              child: CustomContainer(
                applyShadow: true,
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
                        items: visitLogProvider.dateList,
                        value: visitLogProvider.defaultValue,
                        onChanged: (newValue) {
                          if (newValue != null) {
                            print('newValue = $newValue');
                            visitLogProvider.updateSelectedDate(
                                newValue, context);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),

            // visitLogProvider.offlinePoc != 0
            //     ?

            if(visitLogProvider.isOffline || visitLogProvider.selectedDate == visitLogProvider.dateList[3])
            ListView.builder(
              shrinkWrap:
              true, // This allows it to take only the required height
              physics:
              NeverScrollableScrollPhysics(), // Disables scrolling for outer ListView, so the inner ListViews can handle scrolling
              padding: EdgeInsets.all(0),
              itemCount: visitLogProvider.offlinePoc.length,
              itemBuilder: (context, index) {
                int pocId = visitLogProvider.offlinePoc[index].pocId!;
                String pocName =
                visitLogProvider.offlinePoc[index].pocName!;
                String number =
                visitLogProvider.offlinePoc[index].number!;
                String gender =
                visitLogProvider.offlinePoc[index].gender!;
                String dateTime =
                visitLogProvider.offlinePoc[index].mobileTime!;
                String time = dateTime.split(' ')[0];
                String date = dateTime.split(' ')[1];
                String country = visitLogProvider.offlinePoc[index].country!;
                String region = visitLogProvider.offlinePoc[index].region!;
                String city = visitLogProvider.offlinePoc[index].city!;
                String addressLine = visitLogProvider.offlinePoc[index].address!;
                String address = '$country, $region, $city, $addressLine';
                String category =
                visitLogProvider.offlinePoc[index].category!;
                String specialization =
                visitLogProvider.offlinePoc[index].specialization!;
                String ambNumber =
                visitLogProvider.offlinePoc[index].ambNumber!;
                String remarks =
                visitLogProvider.offlinePoc[index].remarks!;
                return Stack(
                  children: [
                    ListTile(
                      onTap: () {
                        print(visitLogProvider.offlinePoc[index]);
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
                                  flex: 2,
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
                                  flex: 2,
                                  child: CustomText(
                                      text: 'Gender', isContent: true),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: CustomText(
                                      text: gender, isContent: true),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                      text: 'Number', isContent: true),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: CustomText(
                                      text: number, isContent: true),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                      text: 'Category', isContent: true),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: CustomText(
                                      text: category, isContent: true),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                    text: 'Specialization', isContent: true, maxLines: 3,),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: CustomText(
                                    text: specialization, isContent: true, maxLines: 3,),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                    text: 'Amb Number', isContent: true, maxLines: 3,),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: CustomText(
                                      text: ambNumber.isEmpty ? 'N/A' : ambNumber, isContent: true),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
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
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
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
                                  flex: 2,
                                  child: CustomText(
                                      text: 'Address', isContent: true),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: CustomText(
                                    text: address, isContent: true, maxLines: 3,),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12,),
                            Consumer<MrOfficerVisitProvider>(
                              builder: (context, visitProvider, _) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    CustomElevatedButton(onPressed: (){
                                      visitProvider.setLocalControllerValues(context, poc: visitLogProvider.offlinePoc[index]);
                                    },backgroundColor: CustomColors.lightRed, widget: CustomText(text: 'Edit')),
                                    CustomElevatedButton(
                                        onPressed: (){
                                          debugPrint('VisitProvider isOffline = ${visitProvider.isOffline}');
                                          if(visitProvider.isOffline){
                                            ToastMessageUtils().showToastMessage('Cannot submit in offline mode');
                                          }else{
                                            visitProvider.setPocModel(context: context, poc: visitLogProvider.offlinePoc[index]);
                                          }
                                        },
                                      backgroundColor: CustomColors.primaryColor,
                                      widget: CustomText(
                                        text: 'Submit', isContent: true, maxLines: 3,),
                                    ),
                                  ],
                                );
                              }
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(top: 16, right: 32, child: Consumer<MrOfficerVisitProvider>(
                      builder: (context, visitProvider, _) {
                        return InkWell(
                            onTap: () async {
                              showDialog(context: context, builder: (_) =>
                                AlertDialog(
                                  title: CustomText(text: 'Delete Confirmation', isHeading: true,),
                                  content: CustomText(text: 'Are you sure you want to delete this offline visit to "${visitLogProvider.offlinePoc[index].pocName}" ?', isContent: true,maxLines: 3,),
                                  actions: [
                                    TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: CustomText(text: 'Cancel', isContent: true, color: Colors.black,),
                                    ),
                                    TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                        visitProvider.deletePocModel(poc: visitLogProvider.offlinePoc[index]);
                                      },
                                      child: CustomText(text: 'Delete', isContent: true, color: Colors.red,),
                                    ),
                                  ],
                                )
                              );
                                // visitProvider.deletePocModel(poc: visitLogProvider.offlinePoc[index]);
                              },
                            child: Icon(FontAwesomeIcons.trash, size: 20, color: Colors.red,));
                      }
                    ))
                  ],
                );
              },
            ),

            if(!visitLogProvider.isOffline && visitLogProvider.selectedDate != visitLogProvider.dateList[3])
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
                      String number =
                          visitLogProvider.visitLog[index]['pocNumber'];
                      String gender =
                          visitLogProvider.visitLog[index]['pocGender'];
                      String dateTime =
                          visitLogProvider.visitLog[index]['mobileTime'];
                      String time = dateTime.split(' ')[0];
                      String date = dateTime.split(' ')[1];
                      String address =
                          visitLogProvider.visitLog[index]['pocAddress'];
                      String category =
                          visitLogProvider.visitLog[index]['pocCategory'];
                      String specialization =
                          visitLogProvider.visitLog[index]['pocSpecialization'];
                      String ambNumber =
                          visitLogProvider.visitLog[index]['ambNumber'];
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
                                    flex: 2,
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
                                    flex: 2,
                                    child: CustomText(
                                        text: 'Gender', isContent: true),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: CustomText(
                                        text: gender, isContent: true),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                        text: 'Number', isContent: true),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: CustomText(
                                        text: number, isContent: true),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                        text: 'Category', isContent: true),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: CustomText(
                                        text: category, isContent: true),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                        text: 'Specialization', isContent: true, maxLines: 3,),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: CustomText(
                                        text: specialization, isContent: true, maxLines: 3,),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                        text: 'Amb Number', isContent: true, maxLines: 3,),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: CustomText(
                                        text: ambNumber.isEmpty ? 'N/A' : ambNumber, isContent: true),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
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
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
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
                                    flex: 2,
                                    child: CustomText(
                                        text: 'Address', isContent: true),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: CustomText(
                                      text: address, isContent: true, maxLines: 3,),
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
                        text:
                            'No visit logs found for ${visitLogProvider.selectedDate}',
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
