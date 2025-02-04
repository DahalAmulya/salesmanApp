import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/drop_downs/custom_dropdown.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  Future<void> selectDate () async{
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
    );
    if(picked == null){
      return;
    }else{
      setState(() {
        selectedDate = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
    print(selectedDate);
  }
  void updateSelectedDate(String newValue) {
    setState(() {
      selectedDate = newValue;
      if (selectedDate == "Today") {
        selectedDate =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
      } else if (selectedDate == "Yesterday") {
        DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
        selectedDate = "${yesterday.year}-${yesterday.month}-${yesterday.day}";
      } else if (selectedDate == "Custom") {
        selectDate(); // Open date picker for custom date selection
      }
      print("Selected Date: $selectedDate");
    });
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
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              children: [
                Expanded(flex: 1, child: CustomText(text: 'Select Date : ')),
                Expanded(
                  flex: 2,
                  child: CustomDropdown(
                      labelText: 'Select Date',
                      items: dateList,
                      value: defaultValue,
                      onChanged: (newValue) {
                        if(newValue != null) {
                          updateSelectedDate(newValue);
                        }
                      }),
                )
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
