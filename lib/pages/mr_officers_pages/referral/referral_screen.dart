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

import '../../../providers/mr_officer_provider/mr_referral_provider.dart';
import '../../../providers/mr_officer_provider/mr_visit_provider.dart';

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
  String? SelectedCountry = '';
  String selectedCity = '';
  List<String> country = ['Nepal', 'India'];

  // List<dynamic> districtList = [];
  List<dynamic> foundDistrictList = [];
  List<dynamic> foundStateList = [];
  List<dynamic> foundDistrict = [];
  List<dynamic> foundState = [];
  List<dynamic> foundCities = [];
  List<dynamic> stateList = [];
  List<dynamic> citiesList = [];
  final _formState = GlobalKey<FormState>();
  final link = 'http://108.181.195.185:5000/api/country/Nepal';


  @override
  void initState() {
    final referralsDetailProvider = Provider.of<ReferralsDetailProvider>(context,listen: false);
    referralsDetailProvider.getDataForDistrict();
    referralsDetailProvider.getDataForState();
    super.initState();
  }

  void runDistrictSearchFilter(String enteredKeyword) {
    List<dynamic> districtResult = [];
    print("Entered Keyword: $enteredKeyword");
    // print("Found District List: $foundDistrictList");
    if (enteredKeyword.isEmpty) {
      districtResult = foundDistrictList;
    } else {
      districtResult = foundDistrictList
          .where((district) => district
          .toString()
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
      print("Filtered District Result: $districtResult");
    }
    setState(() {
      foundDistrict = districtResult;
    });
  }

  void runStateSearchFilter(String enteredKeyword) {
    List<String> stateResult = [];
    if (enteredKeyword.isEmpty) {
      stateResult = foundStateList.cast<String>();
    } else {
      stateResult = foundStateList
          .where((state) => state
          .toString()
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .cast<String>()
          .toList();
    }
    setState(() {
      foundState = stateResult;
    });
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
      child: Consumer<ReferralsDetailProvider>(
          builder: (context, referralsDetailProvider, _) {
            return CustomAppBar(
              tabName: 'Referral',
              centerTitle: true,
              automaticallyImplyLeading: true,
              onTapLeadingIcon: () {
                referralsDetailProvider.clearValues();
                Navigator.of(context)
                    .pop(MarketingOfficerConstants.mrStaffDashboardConst);
              },
            );
          }),
    );
  }

  Widget _buildUI(context) {
    return Consumer<ReferralsDetailProvider>(
        builder: (context, referralsDetailProvider, _) {
          return SingleChildScrollView(
            child: Form(
              key: _formState,
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  _patientDetails(context),
                  SizedBox(
                    height: 16,
                  ),
                  _referredBy(context),
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
                            referralsDetailProvider.clearValues();
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
                                  referralsDetailProvider.PostReferralPOCList(context);
                                  referralsDetailProvider.clearValues();
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
                  SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          );
        });
  }

  //------------------------------------------------------patients details----------------------------------------------------//

  Widget _patientDetails(context) {
    return Consumer<ReferralsDetailProvider>(
        builder: (context, referralsDetailProvider, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomExpansionTile(
              initiallyExpanded: true,
              applyAllBorderRadius: true,
              title: 'Patient Details',
              size: 20,
              fontWeight: FontWeight.w600,
              children: [
                SizedBox(
                  height: 4,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  hintText: 'Patient Name',
                  labelText: 'Patient Name',
                  controller: referralsDetailProvider.patientNameTextController,
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
                  keyboardType: TextInputType.number,
                  controller: referralsDetailProvider.patientAgeTextController,
                  validator: (value) {},
                ),
                SizedBox(
                  height: 16,
                ),
                CustomDropdown(
                    labelText: 'Select Gender',
                    items: referralsDetailProvider.gender,
                    value: referralsDetailProvider.defaultGenderValue,
                    onChanged: (selectedGender) {
                      referralsDetailProvider.setGender(selectedGender);
                    }),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  hintText: 'Provisional Diagnosis',
                  labelText: 'Provisional Diagnosis',
                  controller: referralsDetailProvider
                      .patientProvisionalDiagnosisTextController,
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
                Consumer<WeeklyPlanProvider>(
                    builder: (context, weeklyPlanProvider, _) {
                      return CustomDropdown(
                          labelText: 'Country',
                          items: country,
                          value: defaultValue,
                          applyCountryFlag: true,
                          onChanged: (newValue) {
                            SelectedCountry = newValue!;
                            setState(() {
                              if (SelectedCountry == country[0]) {
                                _isVisibleForDistrict = true;
                                _isVisibleForState = false;
                              } else {
                                _isVisibleForState = true;
                                _isVisibleForDistrict = false;
                              }
                            });
                          });
                    }),
                SizedBox(
                  height: 16,
                ),
                Visibility(
                  visible: _isVisibleForDistrict,
                  child: TextFromFieldWithPrefixSuffix(
                    controller:
                    referralsDetailProvider.patientDistrictTextController,
                    labelText: 'District',
                    readOnly: true,
                    onTap: () {
                      // weeklyPlanProvider.setDistrictList();
                      showModalBottomSheet(
                          isScrollControlled: true,
                          useSafeArea: true,
                          context: context,
                          builder: (context) =>
                              _DistrictBottomSheet(context));
                    },
                    onChange: (value) => () {},
                    validator: (Value) {},
                  ),
                ),
                Visibility(
                  visible: _isVisibleForState,
                  child: TextFromFieldWithPrefixSuffix(
                    controller: referralsDetailProvider.patientStateTextController,
                    labelText: 'State',
                    readOnly: true,
                    onTap: () {
                      // weeklyPlanProvider.setStateList();
                      showModalBottomSheet(
                          isScrollControlled: true,
                          useSafeArea: true,
                          context: context,
                          builder: (context) =>

                              _StateBottomSheet(context));
                    },
                    onChange: (value) => () {},
                    validator: (Value) {},
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Consumer<MrOfficerVisitProvider>(
                    builder: (context, createVisitProvider, _) {
                      return TextFromFieldWithPrefixSuffix(
                        autoFocus: false,
                        hintText: 'City',
                        labelText: 'City',
                        controller: referralsDetailProvider.patientCityTextController,
                        onTap: () {
                          referralsDetailProvider.patientCityTextController.clear();
                          referralsDetailProvider.searchAddressResult(
                              referralsDetailProvider
                                  .patientCityTextController.value.text,
                              createVisitProvider.cities);
                          showModalBottomSheet(
                              isScrollControlled: true,
                              useSafeArea: true,
                              context: context,
                              builder: (context) =>
                              // _AddTaskBottomSheetForCitiesBody(context));
                              _CitiesBottomSheet(context));
                        },
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Activity note is required'
                              : value.length < 3
                              ? 'Enter at least 3 characters'
                              : null;
                        },
                      );
                    }),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  hintText: 'Address',
                  labelText: 'Address',
                  controller: referralsDetailProvider.patientAddressTextController,
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
        });
  }
  //------------------------------------------------------Referred by----------------------------------------------------//

  Widget _referredBy(context) {
    return Consumer<ReferralsDetailProvider>(
        builder: (context, referralsDetailProvider, _) {
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
                SizedBox(
                  height: 4,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  readOnly: true,
                  hintText: 'Full Name *',
                  labelText: 'Full Name *',
                  controller: referralsDetailProvider.referralNameTextController,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Name is required'
                        : value.length < 3
                        ? 'Enter at least 3 characters'
                        : null;
                  },
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      useSafeArea: true,
                      context: context,
                      builder: (context) => _ReferralBottomSheet(context),
                    );
                    referralsDetailProvider.GetPOCList(context);
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  readOnly: true,
                  labelText: 'Category',
                  hintText: 'Category',
                  controller:
                  referralsDetailProvider.referredCategoryTextController,
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
                  readOnly: true,
                  labelText: 'Specialization',
                  hintText: 'Specialization',
                  controller:
                  referralsDetailProvider.referredSpecializationTextController,
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
                  readOnly: true,
                  labelText: 'Age',
                  hintText: 'Age',
                  controller: referralsDetailProvider.referralAgeTextController,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Number is required'
                        : value.length < 1
                        ? 'Enter at least 2 characters'
                        : null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  readOnly: true,
                  labelText: 'Number',
                  hintText: 'Number',
                  controller: referralsDetailProvider.referredNumberTextController,
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
                  readOnly: true,
                  maxLines: 2,
                  labelText: 'Address',
                  hintText: 'Address',
                  controller: referralsDetailProvider.referredAddressTextController,
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
        });
  }
  //------------------------------------------------------ambulance details----------------------------------------------------//

  Widget _ambulanceDetails(context) {
    return Consumer<ReferralsDetailProvider>(
        builder: (context, referralsDetailProvider, _) {
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
                SizedBox(
                  height: 4,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  readOnly: true,
                  hintText: 'Driver Name',
                  labelText: 'Driver Name',
                  controller: referralsDetailProvider.ambDriverNameTextController,
                  validator: (value) {
                    return value!.isEmpty
                        ? 'Driver Name is required'
                        : value.length < 3
                        ? 'Enter at least 3 characters'
                        : null;
                  },
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      useSafeArea: true,
                      context: context,
                      builder: (context) => _AmbulanceBottomSheet(context),
                    );
                    referralsDetailProvider.GetAmbulancePOCList(context);
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  autoFocus: false,
                  readOnly: true,
                  labelText: 'Ambulance Number',
                  hintText: 'Ambulance Number',
                  controller: referralsDetailProvider.ambNumberTextController,
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
                  readOnly: true,
                  labelText: 'Phone Number',
                  hintText: 'Phone Number',
                  controller: referralsDetailProvider.ambPhoneNumberTextController,
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
        });
  }

  //-------------------------------------------------------------------District Bottom Sheet-----------------------------------------------------//

  Widget _DistrictBottomSheet(context) {
    return Consumer<ReferralsDetailProvider>(
        builder: (context, referralsDetailProvider, _) {
          return Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  height: MediaQuery.of(context).size.height * 0.10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    color: CustomColors.primaryColor,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextFromFieldWithPrefixSuffix(
                          applyPrefix: true,
                          prefixIcon: Icon(Icons.search),
                          applySuffixIcon: true,
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          controller: referralsDetailProvider.searchForDistrictTextEditingController,
                          labelText: 'Select District',
                          onChange: (value) => runDistrictSearchFilter(
                              referralsDetailProvider.searchForDistrictTextEditingController
                                  .value.text),
                          validator: (Value) {},
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: referralsDetailProvider.foundDistrictList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: CustomText(
                              text: referralsDetailProvider.foundDistrictList[index].toString()),
                          onTap: (){
                            print(referralsDetailProvider.foundDistrictList[index].toString());
                            referralsDetailProvider.getCitiesForSelection(referralsDetailProvider.foundDistrictList[index].toString());
                            referralsDetailProvider.patientDistrictTextController.text = referralsDetailProvider.foundDistrictList[index].toString();

                            Navigator.pop(context);
                          },
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }

  //-----------------------------------------------------------------State Bottom Sheet-------------------------------------------------------//

  Widget _StateBottomSheet(context) {
    return Consumer<ReferralsDetailProvider>(
        builder: (context, referralsDetailProvider, _) {
          return Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  height: MediaQuery.of(context).size.height * 0.10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    color: CustomColors.primaryColor,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextFromFieldWithPrefixSuffix(
                          applyPrefix: true,
                          prefixIcon: Icon(Icons.search),
                          applySuffixIcon: true,
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          controller: referralsDetailProvider.searchForStatesTextEditingController,
                          labelText: 'Select State',
                          onChange: (value) => runStateSearchFilter(
                              referralsDetailProvider.searchForStatesTextEditingController
                                  .value.text),
                          validator: (Value) {},
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: referralsDetailProvider.foundStateList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: CustomText(
                              text: referralsDetailProvider.foundStateList[index].toString()),
                          onTap: (){
                            referralsDetailProvider.getCitiesForSelection(referralsDetailProvider.foundStateList[index].toString());
                            referralsDetailProvider.patientStateTextController.text = referralsDetailProvider.foundStateList[index].toString();
                            Navigator.pop(context);
                          },
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }

  //-------------------------------------------------------------------City Bottom Sheet-----------------------------------------------------//

  Widget _CitiesBottomSheet(context) {
    return Consumer<ReferralsDetailProvider>(
        builder: (context, referralsDetailProvider, _) {
          return Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  height: MediaQuery.of(context).size.height * 0.10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    color: CustomColors.primaryColor,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextFromFieldWithPrefixSuffix(
                          applyPrefix: true,
                          prefixIcon: Icon(Icons.search),
                          applySuffixIcon: true,
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          controller: referralsDetailProvider.searchForCityTextEditingController,
                          labelText: 'Select City',
                          onChange: (value) {},
                          validator: (Value) {},
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: referralsDetailProvider.foundCities.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: CustomText(
                              text: referralsDetailProvider.foundCities[index].toString()),
                          onTap: (){
                            referralsDetailProvider.patientCityTextController.text = referralsDetailProvider.foundCities[index].toString();
                            Navigator.pop(context);
                          },
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }

  //------------------------------------------------------------------------------------------------------------------------//

  Widget _ReferralBottomSheet(context) {
    return Consumer<ReferralsDetailProvider>(
        builder: (context, referralsDetailProvider, _) {
          return Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  height: MediaQuery.of(context).size.height * 0.10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    color: CustomColors.primaryColor,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextFromFieldWithPrefixSuffix(
                          controller:
                          referralsDetailProvider.searchByNameController,
                          labelText: 'Search POC name',
                          applySuffixIcon: true,
                          suffixIcon: Icon(Icons.search),
                          validator: (newValue) {},
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: referralsDetailProvider.pocList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            referralsDetailProvider.GetPOCList(context);
                            String id =
                            referralsDetailProvider.pocList[index]['_id'];
                            String name =
                            referralsDetailProvider.pocList[index]['pocName'];
                            String category =
                            referralsDetailProvider.pocList[index]['category'];
                            String specialization = referralsDetailProvider
                                .pocList[index]['specialization'];
                            String age = referralsDetailProvider.pocList[index]
                            ['age']
                                .toString();
                            String number =
                            referralsDetailProvider.pocList[index]['number'];
                            String country =
                            referralsDetailProvider.pocList[index]['country'];
                            String region =
                            referralsDetailProvider.pocList[index]['region'];
                            String city =
                            referralsDetailProvider.pocList[index]['city'];
                            String address =
                            referralsDetailProvider.pocList[index]['address'];
                            String fullAddress =
                                '$country, $region, $city, $address';
                            // String organization = referralsDetailProvider.pocList[index]['organization'];
                            referralsDetailProvider.setPOCDetails(id, name,
                                category, specialization, age, number, fullAddress);
                            print(referralsDetailProvider.pocList[index]);
                            Navigator.pop(context);
                          },
                          title: CustomContainer(
                            applyShadow: true,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: CustomText(
                                          text: 'Name ',
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: CustomText(
                                          text: referralsDetailProvider
                                              .pocList[index]['pocName'],
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: CustomText(
                                          text: 'Number',
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: CustomText(
                                          text: referralsDetailProvider
                                              .pocList[index]['number'],
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: CustomText(
                                          text: 'Address',
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: CustomText(
                                          text: referralsDetailProvider
                                              .pocList[index]['address'],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }

  //----------------------------------------------------------------Ambulance BottomSheet----------------------------------------------------------------//

  Widget _AmbulanceBottomSheet(context) {
    return Consumer<ReferralsDetailProvider>(
        builder: (context, referralsDetailProvider, _) {
          return Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  height: MediaQuery.of(context).size.height * 0.10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    color: CustomColors.primaryColor,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextFromFieldWithPrefixSuffix(
                          controller:
                          referralsDetailProvider.searchByNameController,
                          labelText: 'Search POC name',
                          applySuffixIcon: true,
                          suffixIcon: Icon(Icons.search),
                          validator: (newValue) {},
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: referralsDetailProvider.pocList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            referralsDetailProvider.GetAmbulancePOCList(context);
                            String id =
                            referralsDetailProvider.pocList[index]['_id'];
                            String name =
                            referralsDetailProvider.pocList[index]['pocName'];
                            String category =
                            referralsDetailProvider.pocList[index]['category'];
                            String specialization = referralsDetailProvider
                                .pocList[index]['specialization'];
                            String age = referralsDetailProvider.pocList[index]
                            ['age']
                                .toString();
                            String number =
                            referralsDetailProvider.pocList[index]['number'];
                            String address =
                            referralsDetailProvider.pocList[index]['address'];
                            String ambNumber =
                            referralsDetailProvider.pocList[index]['ambNumber'];
                            // String organization = referralsDetailProvider.pocList[index]['organization'];
                            referralsDetailProvider.setAmbulancePOCDetails(
                                id, name, ambNumber, number);
                            print(referralsDetailProvider.pocList[index]);
                            Navigator.pop(context);
                          },
                          title: CustomContainer(
                            applyShadow: true,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: CustomText(
                                          text: 'Name ',
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: CustomText(
                                          text: referralsDetailProvider
                                              .pocList[index]['pocName'],
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: CustomText(
                                          text: 'Number',
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: CustomText(
                                          text: referralsDetailProvider
                                              .pocList[index]['number'],
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: CustomText(
                                          text: 'Address',
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: CustomText(
                                          text: referralsDetailProvider
                                              .pocList[index]['address'],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }
}