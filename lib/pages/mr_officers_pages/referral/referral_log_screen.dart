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
    referralProvider.getReferralLogs(context);
  }

  void updateSelectedDate(String newValue) {
    final referralProvider =
    Provider.of<ReferralsDetailProvider>(context, listen: false);
    setState(() {
      selectedDate = newValue;
      if (selectedDate == "Today") {
        DateTime today = DateTime.now();
        selectedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
        referralProvider.setSelectedDate(selectedDate);
      } else if (selectedDate == "Yesterday") {
        DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
        selectedDate =
        "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";
        referralProvider.setSelectedDate(selectedDate);
      } else {
        // Open date picker for custom date selection
        selectDate(context, referralProvider);
      }
      print("Selected Date: $selectedDate");
    });
    referralProvider.getReferralLogsByDate(context);
  }


  @override
  void initState() {
    final referralProvider =
        Provider.of<ReferralsDetailProvider>(context, listen: false);
    referralProvider.getReferralLogsByDate(context);
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
    return Consumer<ReferralsDetailProvider>(
      builder: (context, referralsDetailProvider, _) {
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
            ),
            const SizedBox(
              height: 8,
            ),
            referralsDetailProvider.referralLogs.isNotEmpty
                ? ListView.builder(
                    shrinkWrap:
                        true, // This allows it to take only the required height
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: referralsDetailProvider.referralLogs.length,
                    itemBuilder: (context, index) {
                      String patientId = referralsDetailProvider.referralLogs[index]['_id']?.toString() ?? '';
                      String patientName = referralsDetailProvider.referralLogs[index]['fullName']?.toString() ?? '';
                      String patientCreatorId = referralsDetailProvider.referralLogs[index]['userId']?['_id']?.toString() ?? '';
                      String patientCreatorName = referralsDetailProvider.referralLogs[index]['userId']?['username']?.toString() ?? '';
                      String pocId = referralsDetailProvider.referralLogs[index]['pocId']?['_id']?.toString() ?? '';
                      String pocName = referralsDetailProvider.referralLogs[index]['pocId']?['pocName']?.toString() ?? '';
                      String pocNumber = referralsDetailProvider.referralLogs[index]['pocId']?['number']?.toString() ?? '';
                      String ambulanceId = referralsDetailProvider.referralLogs[index]['ambId']?['_id']?.toString() ?? '';
                      String ambulanceDriverName = referralsDetailProvider.referralLogs[index]['ambId']?['pocName']?.toString() ?? '';
                      String ambulanceDriverNumber = referralsDetailProvider.referralLogs[index]['ambId']?['number']?.toString() ?? '';
                      String ambulanceNumber = referralsDetailProvider.referralLogs[index]['ambId']?['ambNumber']?.toString() ?? '';
                      String latitude = referralsDetailProvider.referralLogs[index]['latitude']?.toString() ?? '';
                      String longitude = referralsDetailProvider.referralLogs[index]['longitude']?.toString() ?? '';

                      String mobileTimeRaw = referralsDetailProvider.referralLogs[index]['mobileTime']?.toString() ?? '';
                      String mobileTime = mobileTimeRaw.isNotEmpty ? mobileTimeRaw.split(' ')[0] : '';

                      String referralDateRaw = referralsDetailProvider.referralLogs[index]['createdAt']?.toString() ?? '';
                      String referralDate = referralDateRaw.contains('T') ? referralDateRaw.split('T')[0] : '';

                      String id = referralsDetailProvider.referralLogs[index]['_id']?.toString() ?? '';

                      String createdAtRaw = referralsDetailProvider.referralLogs[index]['createdAt']?.toString() ?? '';
                      String createdAt = createdAtRaw.contains('T') ? createdAtRaw.split('T')[0] : '';

                      String updatedAtRaw = referralsDetailProvider.referralLogs[index]['updatedAt']?.toString() ?? '';
                      String updatedAt = updatedAtRaw.contains('T') ? updatedAtRaw.split('T')[0] : '';

                      return ListTile(
                        title: CustomContainer(
                          applyShadow: true,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: 'Patient Name',
                                      isContent: true,
                                      size: 16,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                        text: patientName, isContent: true),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: 'M.O Name',
                                      isContent: true,
                                      size: 16,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: patientCreatorName,
                                      isContent: true,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: 'POC Name',
                                      isContent: true,
                                      size: 16,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: pocName,
                                      isContent: true,
                                      maxLines: 2,
                                      textOverflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: 'POC Number',
                                      isContent: true,
                                      size: 16,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                        text: pocNumber, isContent: true),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: 'AMB Driver Name',
                                      isContent: true,
                                      size: 16,
                                      maxLines: 3,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                        text: ambulanceDriverName,
                                        isContent: true),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: 'AMB Driver Number',
                                      isContent: true,
                                      size: 16,
                                      maxLines: 3,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: ambulanceDriverNumber,
                                      isContent: true,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: 'AMB Number',
                                      isContent: true,
                                      size: 16,
                                      maxLines: 3,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: ambulanceNumber,
                                      isContent: true,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: 'Mobile Time',
                                      isContent: true,
                                      size: 16,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                        text: mobileTime, isContent: true),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: 'Referral Date',
                                      isContent: true,
                                      size: 16,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                        text: referralDate, isContent: true),
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
                            'No visit logs found for ${referralsDetailProvider.selectedDate}',
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
