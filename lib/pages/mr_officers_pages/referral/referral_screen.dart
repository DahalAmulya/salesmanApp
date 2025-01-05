import 'dart:convert';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/services/erp_services.dart';
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
import 'package:http/http.dart' as http;

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
  String selectedCity = '';
  List<String> country = ['Nepal', 'India'];
  List<dynamic> districtList = [];
  List<dynamic> stateList = [];
  List<dynamic> citiesList = [];
  final _formState = GlobalKey<FormState>();
  final link = 'http://108.181.195.185:5000/api/country/Nepal';

  final districtTextEditingController = TextEditingController();
  final searchForDistrictTextEditingController = TextEditingController();
  final stateTextEditingController = TextEditingController();
  final searchForStatesTextEditingController = TextEditingController();

  TextEditingController nameText = TextEditingController();
  TextEditingController ageText = TextEditingController();
  TextEditingController genderText = TextEditingController();
  TextEditingController provisionalDiagnosisText = TextEditingController();
  TextEditingController countryText = TextEditingController();
  TextEditingController districtText = TextEditingController();
  TextEditingController cityText = TextEditingController();
  TextEditingController addressText = TextEditingController();
  TextEditingController driverNameText = TextEditingController();
  TextEditingController ambulanceText = TextEditingController();
  TextEditingController phoneNumberText = TextEditingController();
  TextEditingController text = TextEditingController();
  TextEditingController referralNameText = TextEditingController();
  TextEditingController referralAgeText = TextEditingController();
  TextEditingController referredNumberText = TextEditingController();
  TextEditingController referredCityText = TextEditingController();
  TextEditingController referredAddressText = TextEditingController();
  TextEditingController referredCategoryText = TextEditingController();
  TextEditingController referredSpecializationText = TextEditingController();
  TextEditingController referralRemarkText = TextEditingController();

  void getDataForDistrict() async {
    final respose = await rootBundle.loadString('assets/district.json');
    print(respose.runtimeType);
    List<dynamic> districtData = json.decode(respose);
    // print(districtData);
    districtList = districtData;
  }

  void getDataForState() async {
    final respose = await rootBundle.loadString('assets/states.json');
    List<dynamic> stateData = json.decode(respose);
    stateList = stateData;
    // print(stateList);
  }

  void fetchData() async {
    final response = await http.get(Uri.parse(link));
    print("response = ${response.runtimeType}");
    // print(response.runtimeType);
    // final districtList = await json.decode(response);
  }

  Future<void> getByCountry() async {
    ERPResponse response = await ERPServices.getRequest(link);
    print('response = ${response.body}');
  }

  @override
  void initState() {
    getDataForDistrict();
    getDataForState();
    // fetchData();
    getByCountry();
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
      child: Form(
        key: _formState,
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            _personalDetails(context),
            SizedBox(
              height: 16,
            ),
            _refferedBy(context),
            SizedBox(
              height: 16,
            ),
            _ambulanceDetails(context),
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
                    backgroundColor: Colors.redAccent,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    widget: CustomText(
                      text: 'Back',
                      fontWeight: FontWeight.w600,
                      size: 16,
                    ),
                  ),
                  Consumer<WeeklyPlanProvider>(
                      builder: (context, weeklyPlanProvider, _) {
                    return CustomElevatedButton(
                      borderRadius: 16,
                      backgroundColor: CustomColors.primaryColor,
                      onPressed: () {
                        // weeklyPlanProvider.setList()
                        _formState.currentState!.validate();
                      },
                      widget: CustomText(
                        text: 'Submit',
                        fontWeight: FontWeight.w600,
                        size: 16,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _personalDetails(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CustomExpansionTile(
        initiallyExpanded: true,
        applyAllBorderRadius: true,
        title: 'Personal Details',
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
                    _isVisibleForDistrict = true;
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
                _AddTaskBottomSheetForDistrict(context);
              },
              onChange: (value) => () {},
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
                _AddTaskBottomSheetForStates(context);
              },
              onChange: (value) => () {},
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
            onTap: () {
              _AddTaskBottomSheetForCities(context);
            },
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
    );
  }

  Widget _refferedBy(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CustomExpansionTile(
        applyAllBorderRadius: true,
        radiusTopLeft: 16,
        radiusTopRight: 16,
        radiusBottomLeft: 16,
        radiusBottomRight: 16,
        title: 'Referred By',
        size: 20,
        fontWeight: FontWeight.w600,
        children: [
          TextFromFieldWithPrefixSuffix(
            autoFocus: false,
            hintText: 'Full Name *',
            labelText: 'Full Name *',
            controller: referralNameText,
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
            labelText: 'Category',
            hintText: 'Category',
            controller: referredCategoryText,
            validator: (value) {
              return value!.isEmpty
                  ? 'Category is required'
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
            labelText: 'Specialization',
            hintText: 'Specialization',
            controller: referredSpecializationText,
            validator: (value) {
              return value!.isEmpty
                  ? 'Specialization is required'
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
            labelText: 'Age',
            hintText: 'Age',
            controller: referralAgeText,
            validator: (value) {
              return value!.isEmpty
                  ? 'Number is required'
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
            labelText: 'Number',
            hintText: 'Number',
            controller: referredNumberText,
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
          TextFromFieldWithPrefixSuffix(
            autoFocus: false,
            labelText: 'Address',
            hintText: 'Address',
            controller: referredAddressText,
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
    );
  }

  Widget _ambulanceDetails(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CustomExpansionTile(
        applyAllBorderRadius: true,
        radiusTopLeft: 16,
        radiusTopRight: 16,
        radiusBottomLeft: 16,
        radiusBottomRight: 16,
        title: 'Ambulance Details',
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
            hintText: 'Phone Number',
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

  PreferredSize _AddTaskBottomSheetForDistrictAppBar(context) {
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

  Widget _AddTaskBottomSheetForDistrictBody(context) {
    return ListView(
      children: [
        SizedBox(
          height: 16,
        ),
        // Consumer<WeeklyPlanProvider>(
        //     builder: (context,weeklyPlanProvider,_) {
        //       return TextFromFieldWithPrefixSuffix(
        //         applyPrefix: true,
        //         prefixIcon: Icon(Icons.search),
        //         applySuffixIcon: true,
        //         suffixIcon: Icon(Icons.arrow_drop_down),
        //         controller: searchForDistrictTextEditingController,
        //         labelText: 'Select District',
        //         onTap: () {
        //           // weeklyPlanProvider.setDistrictList();
        //         },
        //         onChange: (value) => weeklyPlanProvider.runDistrictSearchFilter(searchForDistrictTextEditingController.value.text),
        //         validator: (Value) {},
        //       );
        //     }
        // ),
        Container(
          child: ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: districtList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: CustomText(
                    text: districtList[index]['district'],
                  ),
                  onTap: () {
                    // print(districtList);
                    selectedDistrict = districtList[index]['district'];
                    citiesList = districtList[index]['cities'];
                    print(citiesList);
                    districtTextEditingController.text = selectedDistrict;
                    Navigator.pop(context);
                  },
                );
              }),
        ),
        // Consumer<WeeklyPlanProvider>(builder: (context, weeklyPlanProvider, _) {
        //   return Container(
        //     child: ListView.builder(
        //         shrinkWrap: true,
        //         itemCount: weeklyPlanProvider.foundDistrict.length,
        //         itemBuilder: (context, index) {
        //           return ListTile(
        //             title: CustomText(
        //                 text: weeklyPlanProvider.foundDistrict[index].toString()),
        //             onTap: () {
        //               selectedState = weeklyPlanProvider.foundDistrict[index];
        //               districtTextEditingController.text = selectedState;
        //               Navigator.pop(context);
        //             },
        //           );
        //         }),
        //   );
        // })
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
        Container(
          child: ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: stateList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: CustomText(
                    text: stateList[index]['states'],
                  ),
                  onTap: () {
                    // print(districtList);
                    selectedState = stateList[index]['states'];
                    stateTextEditingController.text = selectedState;
                    Navigator.pop(context);
                  },
                );
              }),
        ),
      ],
    );
  }
  //------------------------------------------------------------------------------------------------------------------------//

  Future<void> _AddTaskBottomSheetForCities(context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take up more space
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: _AddTaskBottomSheetForCitiesAppBar(context),
            body: _AddTaskBottomSheetForCitiesBody(context),
          ),
        ),
      ),
    );
  }

  PreferredSize _AddTaskBottomSheetForCitiesAppBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        showLeading: true,
        leadingIcon: FontAwesomeIcons.arrowLeft,
        backgroundColor: CustomColors.primaryColor,
        tabName: 'Select Cities',
        onTapLeadingIcon: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _AddTaskBottomSheetForCitiesBody(context) {
    return ListView(
      children: [
        SizedBox(
          height: 16,
        ),
        Container(
          child: ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: citiesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: CustomText(
                    text: citiesList[index].toString(),
                  ),
                  onTap: () {
                    // print(districtList);
                    selectedCity = citiesList[index];
                    cityText.text = selectedCity;
                    Navigator.pop(context);
                  },
                );
              }),
        ),
      ],
    );
  }
}
