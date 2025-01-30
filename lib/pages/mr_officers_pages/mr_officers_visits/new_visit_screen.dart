import 'dart:convert';
import 'package:deskgoo/providers/mr_officer_provider/mr_visit_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drop_downs/custom_dropdown.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MrOfficerNewVisitScreen extends StatefulWidget {
  const MrOfficerNewVisitScreen({super.key});

  @override
  State<MrOfficerNewVisitScreen> createState() =>
      _MrOfficerNewVisitScreenState();
}

class _MrOfficerNewVisitScreenState extends State<MrOfficerNewVisitScreen> {
  TextEditingController fullNameController = TextEditingController();
  final _createVisitFormKey = GlobalKey<FormState>();
  List<String> country = ['Nepal', 'India'];
  String selectedCountry = '';

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
        tabName: 'New Visit',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTapLeadingIcon: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    selectedCountry = country[0];
    return Consumer<MrOfficerVisitProvider>(
      builder: (context, createVisitProvider, _) {
        return SingleChildScrollView(
          child: Center(
            child: CustomContainer(
              verticalMargin: 24,
              applyShadow: true,
              child: Column(
                children: [
                  CustomText(
                    text: 'Personal Details',
                    isSubHeading: true,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFromFieldWithPrefixSuffix(
                    controller: createVisitProvider.nameController,
                    labelText: 'Full Name *',
                    validator: (newValue) {},
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFromFieldWithPrefixSuffix(
                    controller: createVisitProvider.ageController,
                    labelText: 'Age',
                    validator: (newValue) {},
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 125,
                        child: CustomDropdown(
                          withPrefixIcon: true,
                          labelText: 'Country Code',
                          items: createVisitProvider.countryCode,
                          value: createVisitProvider.selectedCountryCode,
                          onChanged: (newValue) {
                            createVisitProvider.setCountryCode(newValue);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextFromFieldWithPrefixSuffix(
                          controller: createVisitProvider.phoneNoController,
                          keyboardType: TextInputType.number,
                          labelText: 'Number *',
                          onTap: () {},
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Phone number Required'
                                : null;
                          },
                          onChange: (value) {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CustomDropdown(
                    labelText: 'Country',
                    items: createVisitProvider.country,
                    value: createVisitProvider.selectedCountry,
                    applyCountryFlag: true,
                    onChanged: (newValue) {
                      createVisitProvider.setCountry(newValue);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFromFieldWithPrefixSuffix(
                    controller: createVisitProvider.selectedCountry ==
                            createVisitProvider.country[0]
                        ? createVisitProvider.districtController
                        : createVisitProvider.stateController,
                    readOnly: true,
                    labelText: createVisitProvider.selectedCountry ==
                            createVisitProvider.country[0]
                        ? 'District *'
                        : 'State *',
                    validator: (newValue) {},
                    onTap: () async {
                      String fileName = createVisitProvider.selectedCountry ==
                              createVisitProvider.country[0]
                          ? 'district'
                          : 'states';
                      final file =
                          await rootBundle.loadString('assets/$fileName.json');
                      final content = await jsonDecode(file);
                      showModalBottomSheet(
                          isScrollControlled: true,
                          useSafeArea: true,
                          context: context,
                          builder: (context) => districtBottomSheet(
                              context, '$fileName', content));
                      createVisitProvider.searchController.text = '';
                      createVisitProvider.searchAddressResult(
                          createVisitProvider.searchController.value.text,
                          content);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFromFieldWithPrefixSuffix(
                    controller: createVisitProvider.cityController,
                    readOnly: true,
                    labelText: 'City *',
                    validator: (newValue) {},
                    onTap: () async {
                      createVisitProvider.searchController.text = '';
                      createVisitProvider.searchAddressResult(
                          createVisitProvider.searchController.value.text,
                          createVisitProvider.cities);
                      showModalBottomSheet(
                          isScrollControlled: true,
                          useSafeArea: true,
                          context: context,
                          builder: (context) => citiesBottomSheet(
                              context, createVisitProvider.cities));
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFromFieldWithPrefixSuffix(
                    controller: createVisitProvider.addressController,
                    labelText: 'Address *',
                    maxLines: 2,
                    validator: (newValue) {},
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CustomText(
                    text: 'More Details',
                    isSubHeading: true,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CustomDropdown(
                      labelText: 'Category',
                      items: createVisitProvider.category,
                      value: createVisitProvider.selectedCategory,
                      onChanged: (newValue) {
                        createVisitProvider.setCategory(newValue);
                      }),
                  SizedBox(
                    height: 16,
                  ),
                  CustomDropdown(
                    labelText: 'Specialization',
                    items: createVisitProvider.specialization,
                    value: createVisitProvider.selectedSpecialization.isEmpty
                        ? createVisitProvider.specialization[0]
                        : createVisitProvider.selectedSpecialization,
                    onChanged: (newValue) {
                      createVisitProvider.setSpecialization(newValue);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  createVisitProvider.selectedCategory == "Ambulance"
                      ? Column(
                          children: [
                            TextFromFieldWithPrefixSuffix(
                              controller:
                                  createVisitProvider.organizationController,
                              labelText: 'Ambulance Number *',
                              maxLines: 2,
                              validator: (newValue) {},
                            ),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        )
                      : Container(),
                  TextFromFieldWithPrefixSuffix(
                    controller: createVisitProvider.organizationController,
                    labelText: 'Organization',
                    maxLines: 2,
                    validator: (newValue) {},
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFromFieldWithPrefixSuffix(
                    controller: createVisitProvider.remarksController,
                    labelText: 'Remarks *',
                    maxLines: 2,
                    validator: (newValue) {},
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomElevatedButton(
                        onPressed: () async {
                          // Navigator.of(context).pop(
                          //     MarketingOfficerConstants.mrStaffDashboardConst);
                          // final file = await rootBundle
                          //     .loadString('assets/district.json');
                          // final content = await jsonDecode(file);
                          Navigator.of(context).pop();
                        },
                        widget: CustomText(
                          text: 'Back',
                          isContent: true,
                        ),
                        backgroundColor: CustomColors.lightRed,
                      ),
                      CustomElevatedButton(
                        onPressed: () {
                          createVisitProvider.createPOC();
                          pocDetails(context);
                          // showModalBottomSheet(
                          //     isScrollControlled: true,
                          //     useSafeArea: true,
                          //     context: context,
                          //     builder: (context) => districtBottomSheet());
                          // Navigator.of(context).pushNamed(
                          //     MarketingOfficerConstants.productConst);
                        },
                        widget: CustomText(
                          text: 'Submit',
                          isContent: true,
                        ),
                        backgroundColor: CustomColors.primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future pocDetails(context) => showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: CustomColors.primaryWhite,
            elevation: 10,
            title: Builder(builder: (context) {
              return Center(
                child: CustomText(
                  text: 'POC Details',
                  fontWeight: FontWeight.bold,
                  size: 22,
                  color: CustomColors.primaryBlack,
                ),
              );
            }),
            content: SingleChildScrollView(
              child: Consumer<MrOfficerVisitProvider>(
                  builder: (context, mrOfficerVisitProvider, _) {
                return Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Full Name',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['name'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Age',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['age'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Number',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['number'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Country',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['country'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // flex: ,
                          child: CustomText(
                            text: mrOfficerVisitProvider.selectedCountry ==
                                    'Nepal'
                                ? 'District'
                                : 'State',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          // flex: 2,
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['region'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'City',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['city'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Address',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['address'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Category',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['category'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Specialization',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['specialization'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Organization',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['organization'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Remarks',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['remarks'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }),
            ),
            actions: [
              Consumer<MrOfficerVisitProvider>(
                  builder: (context, mrOfficerVisitProvider, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // passing false
                      },
                      backgroundColor: CustomColors.lightRed,
                      widget: CustomText(
                        text: 'Edit',
                        color: CustomColors.primaryBlack,
                        isContent: true,
                      ),
                    ),
                    CustomElevatedButton(
                      onPressed: () {
                        mrOfficerVisitProvider.postPOCDetails(context);
                        // mrOfficerVisitProvider.postPOCDetails(body, context);
                        // Navigator.pop(context); // passing false
                      },
                      backgroundColor: CustomColors.primaryColor,
                      widget: CustomText(
                        text: 'Submit',
                        color: CustomColors.primaryBlack,
                        isContent: true,
                      ),
                    ),
                  ],
                );
              }),
            ],
          );
        },
      );

  Widget districtBottomSheet(context, String type, List<dynamic> content) {
    return Consumer<MrOfficerVisitProvider>(
      builder: (context, visitProvider, _) {
        return Container(
          color: CustomColors.primaryWhite,
          height: MediaQuery.of(context).size.height * 0.80,
          child: Column(
            children: [
              // SizedBox(
              //   height: 16,
              // ),
              Container(
                padding: const EdgeInsets.only(
                  top: 8,
                  right: 12.0,
                  bottom: 8,
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
                        controller: visitProvider.searchController,
                        labelText: 'Search District',
                        applySuffixIcon: true,
                        suffixIcon: Icon(Icons.search),
                        validator: (value) {},
                        onChange: (value) => visitProvider.searchAddressResult(
                            visitProvider.searchController.value.text, content),
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
                  itemCount: visitProvider.searchResult.length,
                  itemBuilder: (context, index) {
                    String name = visitProvider.searchResult[index]['$type'];
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        type == 'district'
                            ? visitProvider.setSelectedDistrict(name)
                            : visitProvider.setSelectedState(name);
                        visitProvider.getCities(
                            visitProvider.searchResult[index]['cities']);
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
    return Consumer<MrOfficerVisitProvider>(
      builder: (context, visitProvider, _) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.80,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 8,
                  right: 12.0,
                  bottom: 8,
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
                        controller: visitProvider.searchController,
                        labelText: 'Search City',
                        applySuffixIcon: true,
                        suffixIcon: Icon(Icons.search),
                        validator: (value) {},
                        onChange: (value) => visitProvider.searchAddressResult(
                            visitProvider.searchController.value.text, content),
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
                  itemCount: visitProvider.searchResult.length,
                  itemBuilder: (context, index) {
                    String cityName = visitProvider.searchResult[index];
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        visitProvider.setSelectedCity(cityName);
                        print(visitProvider.searchResult[index]);
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
}
