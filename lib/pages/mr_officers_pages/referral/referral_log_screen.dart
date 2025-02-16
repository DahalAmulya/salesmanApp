import 'package:deskgoo/providers/mr_officer_provider/mr_referral_provider.dart';
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
    final referralProvider =
        Provider.of<ReferralsDetailProvider>(context, listen: false);
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
      body: ListView(
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
                          updateSelectedDate(newValue.toString().split(' ')[0]);
                        }
                      }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
