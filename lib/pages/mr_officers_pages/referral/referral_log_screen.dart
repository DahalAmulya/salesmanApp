import 'package:deskgoo/providers/mr_officer_provider/mr_referral_provider.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../themes/custom_colors.dart';
import '../../../widgets/app_bars/custom_app_bars.dart';
import '../../../widgets/drop_downs/custom_dropdown.dart';
import '../../../widgets/texts/custom_text.dart';

class MarketingOfficerReferralLogScreen extends StatefulWidget {
  const MarketingOfficerReferralLogScreen({super.key});

  @override
  State<MarketingOfficerReferralLogScreen> createState() =>
      _MarketingOfficerReferralLogScreenState();
}

class _MarketingOfficerReferralLogScreenState
    extends State<MarketingOfficerReferralLogScreen> {
  List<String> dateList = ["Today", "Yesterday", "Custom"];
  String defaultValue = "Today";
  String selectedDate = "";
  bool isVisible = false;

  Future<void> selectDate(
      BuildContext context, ReferralsDetailProvider referralProvider) async {
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

        referralProvider.setSelectedDate(selectedDate);
      });
    }
    print(selectedDate);
    referralProvider.getReferralLogs();
  }

  void updateSelectedDate(String newValue) {
    final referralProvider = Provider.of<ReferralsDetailProvider>(context, listen: false);
    setState(() {
      selectedDate = newValue;
      if (selectedDate == "Today") {
        selectedDate =
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
        referralProvider.setSelectedDate(selectedDate.toString().split(" ")[0]);
      } else if (selectedDate == "Yesterday") {
        DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
        referralProvider.setSelectedDate(yesterday.toString().split(" ")[0]);
        selectedDate = "${yesterday.year}-${yesterday.month}-${yesterday.day}";
      } else {
        // Open date picker for custom date selection
        selectDate(context, referralProvider);
      }
      print("Selected Date: $selectedDate");
    });
    referralProvider.getReferralLogs();
  }

  @override
  void initState() {
    final referralProvider = Provider.of<ReferralsDetailProvider>(context, listen: false);
    referralProvider.getReferralLogs();
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
        tabName: 'Referral Logs',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTapLeadingIcon: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildUI(context) {
    return Scaffold(
      body: Consumer<ReferralsDetailProvider>(
        builder: (context,referralsDetailProvider,_) {
          return ListView(
            children: [
              SizedBox(
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
                            items: dateList,
                            value: defaultValue,
                            onChanged: (newValue) {
                              if (newValue != null) {
                                print('newValue = $newValue');
                                updateSelectedDate(newValue.toString().split(' ')[0]);
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8,),
              ListView.builder(
                  shrinkWrap: true, // This allows it to take only the required height
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: referralsDetailProvider.referralLogs.length,
                  itemBuilder: (context,index){
                    String patientId = referralsDetailProvider.body['referralLogs'][index]['patientId'];
                    String patientName = referralsDetailProvider.body['referralLogs'][index]['patientName'];
                    String patientCreatorId = referralsDetailProvider.body['referralLogs'][index]['createdById'];
                    String patientCreatorName = referralsDetailProvider.body['referralLogs'][index]['createdByName'];
                    String pocId = referralsDetailProvider.body['referralLogs'][index]['pocId'];
                    String pocName = referralsDetailProvider.body['referralLogs'][index]['pocName'];
                    String pocNumber = referralsDetailProvider.body['referralLogs'][index]['pocNumber'];
                    String ambulanceId = referralsDetailProvider.body['referralLogs'][index]['ambId'];
                    String ambulanceDriverName = referralsDetailProvider.body['referralLogs'][index]['ambDriverName'];
                    String ambulanceDriverNumber = referralsDetailProvider.body['referralLogs'][index]['ambDriverNumber'];
                    String ambulanceNumber = referralsDetailProvider.body['referralLogs'][index]['ambNumber'];
                    String latitude = referralsDetailProvider.body['referralLogs'][index]['latitude'].toString();
                    String longitude = referralsDetailProvider.body['referralLogs'][index]['longitude'].toString();
                    String mobileTime = referralsDetailProvider.body['referralLogs'][index]['mobileTime'].toString().split(' ')[0];
                    String referralDate = referralsDetailProvider.body['referralLogs'][index]['referralDate'].toString().split('T')[0];
                    String id = referralsDetailProvider.body['referralLogs'][index]['_id'];
                    String createdAt = referralsDetailProvider.body['referralLogs'][index]['createdAt'].toString().split('T')[0];
                    String updatedAt = referralsDetailProvider.body['referralLogs'][index]['updatedAt'].toString().split('T')[0];
                return ListTile(
                  title: CustomContainer(
                      applyShadow: true,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomText(text: 'Patient Id',isContent: true,),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomText(text: patientId,isContent: true,),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomText(text: 'Patient Name',isContent: true,),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomText(text: patientName,isContent: true),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomText(text: 'Patient Creator Id',isContent: true),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomText(text: patientCreatorId,isContent: true),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomText(text: 'Patient Creator Name',isContent: true),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomText(text: patientCreatorName,isContent: true),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomText(text: 'POC Id',isContent: true),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomText(text: pocId,isContent: true),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomText(text: 'POC Name',isContent: true),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomText(text: pocName,isContent: true),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomText(text: 'POC Number',isContent: true),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomText(text: pocNumber,isContent: true),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomText(text: 'Ambulance Id',isContent: true),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomText(text: ambulanceId,isContent: true),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomText(text: 'Ambulance Driver Name',isContent: true),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomText(text: ambulanceDriverName,isContent: true),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomText(text: 'Ambulance Driver Number',isContent: true),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomText(text: ambulanceDriverNumber,isContent: true),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomText(text: 'Ambulance Number',isContent: true),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomText(text: ambulanceNumber,isContent: true),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomText(text: 'Latitude',isContent: true),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomText(text: latitude,isContent: true),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomText(text: 'Longitude',isContent: true),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomText(text: longitude,isContent: true),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomText(text: 'mobile Time',isContent: true),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomText(text: mobileTime,isContent: true),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomText(text: 'Referral Date',isContent: true),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomText(text: referralDate,isContent: true),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomText(text: 'Id',isContent: true),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomText(text: id,isContent: true),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomText(text: 'Created At',isContent: true),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomText(text: createdAt,isContent: true),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomText(text: 'Updated At',isContent: true),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomText(text: updatedAt,isContent: true),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ),
                );
              })
            ],
          );
        }
      ),
    );
  }
}
