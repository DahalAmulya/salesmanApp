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

  final _formState = GlobalKey<FormState>();
  // final link = 'http://108.181.195.185:5000/api/country/Nepal';

  @override
  void initState() {
    final referralsDetailProvider =
        Provider.of<ReferralsDetailProvider>(context, listen: false);
    referralsDetailProvider.getDataForDistrict();
    referralsDetailProvider.getDataForState();
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
            CustomDropdown(
              labelText: 'Country',
              items: referralsDetailProvider.country,
              value: referralsDetailProvider.selectedCountry,
              applyCountryFlag: true,
              onChanged: (newValue) {
                referralsDetailProvider.setCountry(newValue);
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextFromFieldWithPrefixSuffix(
              controller: referralsDetailProvider.selectedCountry ==
                      referralsDetailProvider.country[0]
                  ? referralsDetailProvider.districtController
                  : referralsDetailProvider.stateController,
              readOnly: true,
              labelText: referralsDetailProvider.selectedCountry ==
                      referralsDetailProvider.country[0]
                  ? 'District *'
                  : 'State *',
              validator: (newValue) {},
              onTap: () async {
                String fileName = referralsDetailProvider.selectedCountry ==
                        referralsDetailProvider.country[0]
                    ? 'district'
                    : 'states';
                final file =
                    await rootBundle.loadString('assets/$fileName.json');
                final content = await jsonDecode(file);
                showModalBottomSheet(
                    isScrollControlled: true,
                    useSafeArea: true,
                    context: context,
                    builder: (context) =>
                        districtBottomSheet(context, '$fileName', content));
                referralsDetailProvider.searchController.text = '';
                referralsDetailProvider.searchAddressResult(
                    referralsDetailProvider.searchController.value.text,
                    content);
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextFromFieldWithPrefixSuffix(
              controller: referralsDetailProvider.cityController,
              readOnly: true,
              labelText: 'City *',
              validator: (newValue) {},
              onTap: () async {
                referralsDetailProvider.searchController.text = '';
                referralsDetailProvider.searchAddressResult(
                    referralsDetailProvider.searchController.value.text,
                    referralsDetailProvider.cities);
                showModalBottomSheet(
                    isScrollControlled: true,
                    useSafeArea: true,
                    context: context,
                    builder: (context) => citiesBottomSheet(
                        context, referralsDetailProvider.cities));
              },
            ),
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
              controller: referralsDetailProvider.ambDriverSearchController,
              onChange: (value) => referralsDetailProvider.searchPocName(
                  referralsDetailProvider.ambDriverSearchController.value.text,
                  referralsDetailProvider.pocList),
              validator: (value) {
                return value!.isEmpty
                    ? 'Driver Name is required'
                    : value.length < 3
                        ? 'Enter at least 3 characters'
                        : null;
              },
              onTap: () {
                referralsDetailProvider.GetAmbulancePOCList(context);
                showModalBottomSheet(
                  isScrollControlled: true,
                  useSafeArea: true,
                  context: context,
                  builder: (context) => _AmbulanceBottomSheet(context),
                );
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

  Widget districtBottomSheet(context, String type, List<dynamic> content) {
    return Consumer<ReferralsDetailProvider>(
      builder: (context, referralProvider, _) {
        return Container(
          color: CustomColors.primaryWhite,
          height: MediaQuery.of(context).size.height * 0.80,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 16,
                  right: 12.0,
                  bottom: 12,
                ),
                decoration: BoxDecoration(
                  color: CustomColors.primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: () {
                            print('Pressed');
                            Navigator.pop(context);
                          },
                          child: Icon(FontAwesomeIcons.arrowLeft)),
                    ),
                    // ),
                    Expanded(
                      flex: 7,
                      child: TextFromFieldWithPrefixSuffix(
                        controller: referralProvider.searchController,
                        labelText: referralProvider.selectedCountry == 'Nepal'
                            ? 'Search District'
                            : 'Search State',
                        applySuffixIcon: true,
                        suffixIcon: Icon(Icons.search),
                        validator: (value) {},
                        onChange: (value) =>
                            referralProvider.searchAddressResult(
                                referralProvider.searchController.value.text, content),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: referralProvider.searchResult.length,
                  itemBuilder: (context, index) {
                    String name = referralProvider.searchResult[index]['$type'];
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        type == 'district'
                            ? referralProvider.setSelectedDistrict(name)
                            : referralProvider.setSelectedState(name);
                        referralProvider.getCities(
                            referralProvider.searchResult[index]['cities']);
                      },
                      title: CustomText(
                        text: name,
                        isContent: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget citiesBottomSheet(context, List<dynamic> content) {
    return Consumer<ReferralsDetailProvider>(
      builder: (context, referralProvider, _) {
        return Container(
          color: CustomColors.primaryWhite,
          height: MediaQuery.of(context).size.height * 0.80,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 16,
                  right: 12.0,
                  bottom: 12,
                ),
                decoration: BoxDecoration(
                  color: CustomColors.primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: () {
                            print('Pressed');
                            Navigator.pop(context);
                          },
                          child: Icon(FontAwesomeIcons.arrowLeft)),
                    ),
                    // ),
                    Expanded(
                      flex: 7,
                      child: TextFromFieldWithPrefixSuffix(
                        controller: referralProvider.searchController,
                        labelText: 'Search City',
                        applySuffixIcon: true,
                        suffixIcon: Icon(Icons.search),
                        validator: (value) {},
                        onChange: (value) =>
                            referralProvider.searchAddressResult(
                                referralProvider.searchController.value.text,
                                content),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: referralProvider.searchResult.length,
                  itemBuilder: (context, index) {
                    String cityName = referralProvider.searchResult[index];
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        referralProvider.setSelectedCity(cityName);
                        print(referralProvider.searchResult[index]);
                      },
                      title: CustomText(
                        text: cityName,
                        isContent: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //------------------------------------------------------------------------------------------------------------------------//

  Widget _ReferralBottomSheet(context) {
    return Consumer<ReferralsDetailProvider>(
        builder: (context, referralsDetailProvider, _) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          color: CustomColors.primaryWhite,
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
                        onChange: (newValue) =>
                            referralsDetailProvider.searchPocName(
                                referralsDetailProvider
                                    .searchByNameController.value.text,
                                referralsDetailProvider.pocList),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: referralsDetailProvider.pocSearchResult.length,
                    itemBuilder: (context, index) {
                      String id =
                          referralsDetailProvider.pocSearchResult[index]['_id'];
                      String name = referralsDetailProvider
                          .pocSearchResult[index]['pocName'];
                      String category = referralsDetailProvider
                          .pocSearchResult[index]['category'];
                      String specialization = referralsDetailProvider
                          .pocSearchResult[index]['specialization'];
                      String age = referralsDetailProvider
                          .pocSearchResult[index]['age']
                          .toString();
                      String number = referralsDetailProvider
                          .pocSearchResult[index]['number'];
                      String country = referralsDetailProvider
                          .pocSearchResult[index]['country'];
                      String region = referralsDetailProvider
                          .pocSearchResult[index]['region'];
                      String city = referralsDetailProvider
                          .pocSearchResult[index]['city'];
                      String address = referralsDetailProvider
                          .pocSearchResult[index]['address'];
                      String fullAddress = '$country, $region, $city, $address';
                      return ListTile(
                        onTap: () {
                          referralsDetailProvider.GetPOCList(context);
                          // String organization = referralsDetailProvider.pocList[index]['organization'];
                          referralsDetailProvider.setPOCDetails(
                              id,
                              name,
                              category,
                              specialization,
                              age,
                              number,
                              fullAddress);
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
                                        text: name,
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
                                        text: number,
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
                                        text: fullAddress,
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
        ),
      );
    });
  }

  //----------------------------------------------------------------Ambulance BottomSheet----------------------------------------------------------------//

  Widget _AmbulanceBottomSheet(context) {
    return Consumer<ReferralsDetailProvider>(
      builder: (context, referralsDetailProvider, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: CustomColors.primaryWhite,
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
                              referralsDetailProvider.ambDriverSearchController,
                          labelText: 'Search POC name',
                          applySuffixIcon: true,
                          suffixIcon: Icon(Icons.search),
                          onChange: (newValue) =>
                              referralsDetailProvider.searchAmbPocName(
                                  referralsDetailProvider
                                      .ambDriverSearchController.value.text,
                                  referralsDetailProvider.ambDriverList),
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
                    itemCount: referralsDetailProvider.ambSearchResult.length,
                    itemBuilder: (context, index) {
                      String id =
                          referralsDetailProvider.ambSearchResult[index]['_id'];
                      String name = referralsDetailProvider
                          .ambSearchResult[index]['pocName'];
                      String number = referralsDetailProvider
                          .ambSearchResult[index]['number'];
                      String country = referralsDetailProvider
                          .ambSearchResult[index]['country'];
                      String region = referralsDetailProvider
                          .ambSearchResult[index]['region'];
                      String city = referralsDetailProvider
                          .ambSearchResult[index]['city'];
                      String address = referralsDetailProvider
                          .ambSearchResult[index]['address'];
                      String fullAddress = '$country, $region, $city, $address';
                      String ambNumber = referralsDetailProvider
                          .ambSearchResult[index]['ambNumber'];
                      return ListTile(
                        onTap: () {
                          referralsDetailProvider.GetAmbulancePOCList(context);
                          // String organization = referralsDetailProvider.pocList[index]['organization'];
                          referralsDetailProvider.setAmbulancePOCDetails(
                              id, name, ambNumber, number);
                          print(referralsDetailProvider.ambSearchResult[index]);
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
                                        text: name,
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
                                        text: number,
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
                                        text: fullAddress,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
