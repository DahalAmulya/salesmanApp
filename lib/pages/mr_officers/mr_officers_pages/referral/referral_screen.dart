import 'dart:convert';

import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../providers/weeklyplan_provider/weeklyplan_provider.dart';
import '../../../../widgets/drop_downs/custom_dropdown.dart';
import '../../../../widgets/expansion_tile/custom_expansiontile.dart';
import '../../../../widgets/text_fields/text_from_field.dart';

class MrOfficerReferralScreen extends StatefulWidget {
  const MrOfficerReferralScreen({super.key});

  @override
  State<MrOfficerReferralScreen> createState() =>
      _MrOfficerReferralScreenState();
}

class _MrOfficerReferralScreenState extends State<MrOfficerReferralScreen> {
  bool _isVisibleForState = false;
  bool _isVisibleForDistrict = true;

  String selectedDistrict = 'Baglung';
  String defaultValue = 'Nepal';
  String selectedState = 'Achham';
  String selectedCountry = '';
  List<String> country = ['Nepal', 'India'];

  final districtTextEditingController = TextEditingController();
  final searchForDistrictTextEditingController = TextEditingController();
  final stateTextEditingController = TextEditingController();
  final searchForStatesTextEditingController = TextEditingController();

  TextEditingController nameText =  TextEditingController();
  TextEditingController ageText =  TextEditingController();
  TextEditingController genderText =  TextEditingController();
  TextEditingController provisionalDiagnosisText =  TextEditingController();
  TextEditingController countryText =  TextEditingController();
  TextEditingController districtText =  TextEditingController();
  TextEditingController cityText =  TextEditingController();
  TextEditingController addressText =  TextEditingController();
  TextEditingController driverNameText =  TextEditingController();
  TextEditingController ambulanceText =  TextEditingController();
  TextEditingController phoneNumberText =  TextEditingController();
  TextEditingController text =  TextEditingController();
  TextEditingController text2 =  TextEditingController();

  Future<List<Map<String, dynamic>>> readDistrictJson() async {
    // Load the JSON file from the assets
    final String response = await rootBundle.loadString('assets/district.json');

    // Decode the JSON into a List of Maps
    final List<dynamic> data = json.decode(response);
    return List<Map<String, dynamic>>.from(data);
  }
  void loadData() async {
    final districts = await readDistrictJson();
    print(districts);
  }
  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(context),
      body: _buildUI(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Referral',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTapLeadingIcon: () {
          Navigator.of(context)
              .pop(MarketingOfficerConstants.mrStaffDashboardConst);
        },
      ),
    );
  }

  Widget _buildUI(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomExpansionTile(
              applyAllBorderRadius: true,
                title:'Personal Details',
               size: 20,
              fontWeight: FontWeight.w600,
              children: [
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  hintText: 'Patient Name',
                  labelText: 'Patient Name',
                  controller: nameText,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Name is required'
                        : value.length < 3
                        ? 'Enter at least 3 characters'
                        : null;
                },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  hintText: 'Age',
                  labelText: 'Age',
                  controller: ageText,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Age is required'
                        : value.length < 3
                        ? 'Enter at least 1 characters'
                        : null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  hintText: 'Gender',
                  labelText: 'Gender',
                  controller: genderText,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Gender is required'
                        : value.length < 3
                        ? 'Enter at least 3 characters'
                        : null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  hintText: 'Provisional Diagnosis',
                  labelText: 'Provisional Diagnosis',
                  controller: provisionalDiagnosisText,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Provisional Diagnosis is required'
                        : value.length < 3
                        ? 'Enter at least 3 characters'
                        : null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                CustomDropdown(
                    labelText: 'Select Country',
                    items: country,
                    value: defaultValue,
                    onChanged: (newValue) {
                      selectedCountry = newValue!;
                      setState(() {
                        if (selectedCountry == country[0]) {
                          _isVisibleForDistrict = !_isVisibleForDistrict;
                          _isVisibleForState = false;
                          _AddTaskBottomSheetForDistrict(context);
                        } else {
                          _isVisibleForDistrict = false;
                          _isVisibleForState = true;
                          _AddTaskBottomSheetForStates(context);
                          // print(country[1]);
                        }
                      });
                    }),
                SizedBox(
                  height: 16,
                ),
                Visibility(
                  visible: _isVisibleForDistrict,
                  child: TextFromFieldWithPrefixSuffix(
                    controller: districtTextEditingController,
                    labelText: 'District',
                    onTap: () {
                      // weeklyPlanProvider.setDistrictList();
                      // _AddTaskBottomSheetForDistrict(context);
                    },
                    onChange: (value) => (){},
                    validator: (Value) {},
                  ),
                ),
                Visibility(
                  visible: _isVisibleForState,
                  child: TextFromFieldWithPrefixSuffix(
                    controller: stateTextEditingController,
                    labelText: 'State',
                    readOnly: true,
                    onTap: () {
                      // weeklyPlanProvider.setStateList();
                      // _AddTaskBottomSheetForStates(context);
                    },
                    onChange: (value) => (){},
                    validator: (Value) {},
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  hintText: 'City',
                  labelText: 'City',
                  controller: cityText,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Activity note is required'
                        : value.length < 3
                        ? 'Enter at least 3 characters'
                        : null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  hintText: 'Address',
                  labelText: 'Address',
                  controller: addressText,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Address is required'
                        : value.length < 3
                        ? 'Enter at least 3 characters'
                        : null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomExpansionTile(
              applyAllBorderRadius: true,
              radiusTopLeft: 16,
              radiusTopRight: 16,
              radiusBottomLeft: 16,
              radiusBottomRight: 16,
              title:'Referred By',
              size: 20,
              fontWeight: FontWeight.w600,
              children: [
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  hintText: 'Name',
                  labelText: 'Name',
                  controller: nameText,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Name is required'
                        : value.length < 3
                        ? 'Enter at least 3 characters'
                        : null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  labelText: '--------',
                  controller: ageText,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Age is required'
                        : value.length < 3
                        ? 'Enter at least 1 characters'
                        : null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  labelText: '-----------',
                  controller: genderText,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Gender is required'
                        : value.length < 3
                        ? 'Enter at least 3 characters'
                        : null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  labelText: '----------------',
                  controller: provisionalDiagnosisText,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Provisional Diagnosis is required'
                        : value.length < 3
                        ? 'Enter at least 3 characters'
                        : null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  labelText: '-------------------',
                  controller: countryText,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Activity note is required'
                        : value.length < 3
                        ? 'Enter at least 3 characters'
                        : null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  labelText: '----------------',
                  controller: districtText,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'District is required'
                        : value.length < 3
                        ? 'Enter at least 3 characters'
                        : null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomExpansionTile(
              applyAllBorderRadius: true,
              radiusTopLeft: 16,
              radiusTopRight: 16,
              radiusBottomLeft: 16,
              radiusBottomRight: 16,
              title:'Ambulance Details',
              size: 20,
              fontWeight: FontWeight.w600,
              children: [
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  hintText: 'Driver Name',
                  labelText: 'Driver Name',
                  controller: driverNameText,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Driver Name is required'
                        : value.length < 3
                        ? 'Enter at least 3 characters'
                        : null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  labelText: 'Ambulance Number',
                  hintText: 'Ambulance Number',
                  controller: ambulanceText,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Ambulance Number is required'
                        : value.length < 3
                        ? 'Enter at least 4 characters'
                        : null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  labelText: 'Phone Number',
                  hintText:  'Phone Number',
                  controller: phoneNumberText,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Phone Number is required'
                        : value.length < 3
                        ? 'Enter at least 10 characters'
                        : null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  labelText: '----------------',
                  controller: text,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Provisional Diagnosis is required'
                        : value.length < 3
                        ? 'Enter at least 3 characters'
                        : null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  labelText: '-------------------',
                  controller: text2,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Activity note is required'
                        : value.length < 3
                        ? 'Enter at least 3 characters'
                        : null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomElevatedButton(
                  borderRadius: 16,
                  backgroundColor:Colors.redAccent,
                    onPressed: (){},
                    widget: CustomText(text: 'Back',fontWeight: FontWeight.w600,size: 16,),
                ),
                CustomElevatedButton(
                  borderRadius: 16,
                  backgroundColor: CustomColors.primaryColor,
                  onPressed: (){},
                  widget: CustomText(text:'Submit',fontWeight: FontWeight.w600,size: 16,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  //------------------------------------------------------------------------------------------------------------------------//
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
  //------------------------------------------------------------------------------------------------------------------------//

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

}
