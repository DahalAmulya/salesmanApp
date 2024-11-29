import 'package:deskgoo/pages/mr_officers/mr_officers_pages/mr_officers_visits/mr_officers_visit_type_screen.dart';
import 'package:deskgoo/pages/mr_officers/mr_officers_provider/mr_officer_provider.dart';
import 'package:deskgoo/pages/mr_officers/mr_officers_providers/mr_officer_visit_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_sheets/custom_bottom_sheet2.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drop_downs/custom_dropdown.dart';
import 'package:deskgoo/widgets/expansion_tile/custom_expansiontile.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/text_fields/text_from_field.dart';
// import 'package:getwidget/getwidget.dart';

class MROfficersVisitsScreen extends StatefulWidget {
  const MROfficersVisitsScreen({super.key});

  @override
  State<MROfficersVisitsScreen> createState() => _MROfficersVisitsScreenState();
}

class _MROfficersVisitsScreenState extends State<MROfficersVisitsScreen>
    with SingleTickerProviderStateMixin {
  MrOfficerVisitProvider? _mrOfficerVisitProvider;
  Widget? _selectedVisit;
  final _createVisitFormKey = GlobalKey<FormState>();

  bool _customIcon = false;
  late String dropDownValue;
  bool isOpen = false;
  bool isVisible = false;
  bool isVisibleForState = false;
  bool isVisibleForStateList = false;
  bool isVisibleForDistrictList = false;
  bool isVisibleForDistrict = false;

  String selectedOption = 'Self';
  String selectedDistrict = 'Baglung';
  String selectedCountry = 'Nepal';
  String selectedState = 'Achham';
  List<String> dropDownOptions = ['Self', 'Others'];
  List<String> country = ['Nepal', 'India'];
  List<String> districts = [
    'Achham',
    'Arghakhanchi',
    'Baglung',
    'Baitadi',
    'Bajhang',
    'Bajura',
    'Banke',
    'Bara',
    'Bardiya',
    'Bhaktapur',
    'Bhojpur',
    'Chitwan',
    'Dadeldhura',
    'Dailekh',
    'Dang',
    'Darchula',
    'Dhading',
    'Dhankuta',
    'Dhanusha',
    'Dolakha',
    'Dolpa',
    'Doti',
    'Eastern Rukum',
    'Gorkha',
    'Gulmi',
    'Humla',
    'Ilam',
    'Jajarkot',
    'Jhapa',
    'Jumla',
    'Kailali',
    'Kalikot',
    'Kanchanpur',
    'Kapilvastu',
    'Kaski',
    'Kathmandu',
    'Kavrepalanchok',
    'khotang',
    'Lalitpur',
    'Lamjung',
    'Mahottari',
    'Makwanpur',
    'Manang',
    'Morang',
    'Mugu',
    'Mustang',
    'Myagdi',
    'Nawalparasi(East of Bardaghat Susta)',
    'Nawalparasi(West of Bardaghat Susta)',
    'Nuwakot',
    'Okhaldhunga',
    'Palpa',
    'Panchathar',
    'Parbat',
    'Parsa',
    'Pyuthan',
    'Ramechhap',
    'Rasuwa',
    'Rautahat',
    'Rolpa',
    'Rupandehi',
    'Salyan',
    'Sankhuwasabha',
    'Saptari',
    'Sarlahi',
    'Sindhuli',
    'Sindhupalchok',
    'Siraha',
    'Solukhumbu',
    'Sunsari',
    'Surkhet',
    'Syangja',
    'Tanahun',
    'Taplejung',
    'Tehrathum',
    'Udayapur',
    'Western Rukum',
  ];
  List<String> foundStates = [];
  List<String> foundDistrict = [];
  List<String> states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chattisgarh',
    'Goa',
    'Gujrat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bangal',
  ];

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final diseasesController = TextEditingController();
  final referenceController = TextEditingController();
  final stateTextEditingController = TextEditingController();
  final districtTextEditingController = TextEditingController();
  // final referenceController = TextEditingController();

  void _stateFilter(String enteredKeyword) {
    setState(() {
      isVisibleForStateList = true;
    });
    List<String> stateResult = [];
    if (enteredKeyword.isEmpty) {
      stateResult = states;
    } else {
      stateResult = states
          .where((state) => state
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      foundStates = stateResult;
    });
  }

  void _countryFilter(String enteredKeyword) {
    setState(() {
      isVisibleForDistrictList = true;
      List<String> districtResult = [];
      if (enteredKeyword.isEmpty) {
        districtResult = districts;
      } else {
        districtResult = districts
            .where((district) => district
                .toString()
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();
      }
      setState(() {
        foundDistrict = districtResult;
      });
    });
  }

  @override
  void initState() {
    _mrOfficerVisitProvider =
        Provider.of<MrOfficerVisitProvider>(context, listen: false);
    foundStates = states;
    super.initState();
  }

  @override
  void dispose() {
    stateTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        Navigator.of(context)
            .pushReplacementNamed(MarketingManagerConstants.homePage);
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
          backgroundColor: Colors.grey.shade200,
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
        tabName: 'Visit',
        size: 24,
        showLeading: true,
        leadingIcon: FontAwesomeIcons.arrowLeft,
        leadingIconColor: CustomColors.primaryBlack,
        onTapLeadingIcon: () {
          Navigator.of(context)
              .pushReplacementNamed(MarketingManagerConstants.homePage);
        },
      ),
    );
  }

  Widget _buildUI(context) {
    return Consumer<MrOfficerVisitProvider>(
      builder: (context, mrOfficerVisitProvider, _) {
        if (mrOfficerVisitProvider.selectedVisitType == 'Create Visit') {
          _selectedVisit = _createVisit(context);
        } else if (mrOfficerVisitProvider.selectedVisitType == 'New Visit') {
          _selectedVisit = _newVisit(context);
        } else {
          _selectedVisit = _followUpVisit(context);
        }
        return GestureDetector(
          onHorizontalDragEnd: (details) {
            // Swiping in right direction.
            if (details.primaryVelocity! > 0) {
              if (mrOfficerVisitProvider.tabIndex > 0) {
                mrOfficerVisitProvider
                    .setTabIndex(mrOfficerVisitProvider.tabIndex - 1);
              }
            }

            // Swiping in left direction.
            String selectedVisitType =
                mrOfficerVisitProvider.selectedVisitTypeList[0];
            if (details.primaryVelocity! < 0) {
              if (mrOfficerVisitProvider.tabIndex <
                  mrOfficerVisitProvider.selectedVisitTypeList.length - 1) {
                if (selectedVisitType == 'Create Visit') {
                  if (_createVisitFormKey.currentState!.validate()) {
                    mrOfficerVisitProvider
                        .setTabIndex(mrOfficerVisitProvider.tabIndex + 1);
                  }
                } else if (selectedVisitType == 'New Visit') {
                  mrOfficerVisitProvider
                      .setTabIndex(mrOfficerVisitProvider.tabIndex + 1);
                } else {
                  mrOfficerVisitProvider
                      .setTabIndex(mrOfficerVisitProvider.tabIndex + 1);
                }
              }
            }
          },
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            height: double.infinity,
            color: Colors.grey.shade200,
            child: ListView(
              children: [
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        mrOfficerVisitProvider.selectedVisitTypeList.length,
                    itemBuilder: (context, index) {
                      String tabName =
                          mrOfficerVisitProvider.selectedVisitTypeList[index];
                      return InkWell(
                        onTap: () {
                          print('Pressed $tabName');
                          if (tabName == 'More Detail') {
                            if (mrOfficerVisitProvider
                                    .selectedVisitTypeList[0] ==
                                'Create Visit') {
                              if (_createVisitFormKey.currentState!
                                  .validate()) {
                                mrOfficerVisitProvider.setTabIndex(index);
                              }
                            } else if (mrOfficerVisitProvider
                                    .selectedVisitTypeList[0] ==
                                'New Visit') {
                              mrOfficerVisitProvider.setTabIndex(index);
                            } else {
                              mrOfficerVisitProvider.setTabIndex(index);
                            }
                          } else {
                            mrOfficerVisitProvider.setTabIndex(index);
                          }
                        },
                        child: AnimatedContainer(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: mrOfficerVisitProvider.tabIndex == index
                                ? CustomColors.primaryColor
                                : Colors.white,
                          ),
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          margin: EdgeInsets.all(4),
                          width: 120,
                          height: 40,
                          child: Center(
                            child: CustomText(
                              text: tabName,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                mrOfficerVisitProvider.tabIndex == 0
                    ? _selectedVisit!
                    : _visitDetails(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _newVisit(context) {
    return AnimatedContainer(
      // height: MediaQuery.of(context).size.height * 0.55,
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      // height: 200,
      color: Colors.red,
      child: Container(
        child: Text('coming soon '),
      ),
    );
  }

  Widget _createVisit(context) {
    return Consumer<MrOfficerCreateVisitProvider>(
      builder: (context, createVisitProvider, _) {
        return Column(
          children: [
            CustomContainer(
              verticalMargin: 4,
              child: Form(
                key: _createVisitFormKey,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      text: 'Enter Client Details',
                      fontWeight: FontWeight.w500,
                      size: 20,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    TextFromFieldWithPrefixSuffix(
                      controller: createVisitProvider.createNameController,
                      labelText: 'Name *',
                      onTap: () {},
                      validator: (value) {
                        return value!.isEmpty ? 'Name Required' : null;
                      },
                      onChange: (value) {},
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    TextFromFieldWithPrefixSuffix(
                      controller: createVisitProvider.createAgeController,
                      keyboardType: TextInputType.number,
                      labelText: 'Age',
                      onTap: () {},
                      validator: (value) {
                        return null;
                      },
                      onChange: (value) {},
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    TextFromFieldWithPrefixSuffix(
                      controller: createVisitProvider.createAddressController,
                      labelText: 'Address *',
                      onTap: () {},
                      validator: (value) {
                        return value!.isEmpty ? 'Address Required' : null;
                      },
                      onChange: (value) {},
                    ),
                    SizedBox(
                      height: 12.0,
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
                            controller:
                                createVisitProvider.createPhoneNoController,
                            keyboardType: TextInputType.number,
                            labelText: 'Phone *',
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
                      height: 12.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFromFieldWithPrefixSuffix(
                            controller:
                                createVisitProvider.createWhatsAppController,
                            keyboardType: TextInputType.number,
                            applySuffixIcon: true,
                            labelText: 'WhatsApp No.',
                            onTap: () {},
                            validator: (value) {
                              return null;
                            },
                            onChange: (value) => createVisitProvider
                                .checkWhatsappAndPhoneNo(value),
                          ),
                        ),
                        Switch(
                          activeColor: CustomColors.primaryBlack,
                          activeTrackColor: CustomColors.primaryColor,
                          inactiveTrackColor: CustomColors.primaryWhite,
                          inactiveThumbColor: CustomColors.primaryBlack,
                          value: createVisitProvider.isSwitched,
                          onChanged: (value) {
                            createVisitProvider.setWhatsAppNumber(value);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    TextFromFieldWithPrefixSuffix(
                      controller: createVisitProvider.createEmailController,
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Email',
                      onTap: () {},
                      validator: (value) {
                        return null;
                      },
                      onChange: (value) {},
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(MaterialPageRoute(
                                builder: (context) =>
                                    MrOfficersVisitTypeScreen()));
                          },
                          backgroundColor: CustomColors.lightRed,
                          widget: CustomText(
                            text: 'Back',
                            color: CustomColors.primaryBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        CustomElevatedButton(
                          onPressed: () {
                            if (_createVisitFormKey.currentState!.validate()) {
                              _mrOfficerVisitProvider!.setTabIndex(1);
                            }
                          },
                          backgroundColor: CustomColors.primaryColor,
                          widget: CustomText(
                            text: 'Next',
                            color: CustomColors.primaryBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _followUpVisit(context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      // height: 400,
      width: double.infinity,
      color: Colors.purpleAccent,
      child: Center(
        child: CustomText(text: 'FollowUp Visit'),
      ),
    );
  }

  Widget _visitDetails(context) {
    return Consumer<MrOfficerMoreDetailsProvider>(
      builder: (context, visitDetails, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              CustomContainer(
                verticalPad: 0,
                verticalMargin: 4,
                horizontalPad: 0,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    // GFSearchBar(
                    CustomExpansionTile(
                      radiusTopLeft: 16,
                      radiusTopRight: 16,
                      initiallyExpanded: true,
                      title: 'Visit Detail',
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        TextFromFieldWithPrefixSuffix(
                            labelText: 'Name',
                            controller: visitDetails.nameController,
                            validator: (value) {
                              return null;
                            }),
                        SizedBox(
                          height: 8,
                        ),
                        TextFromFieldWithPrefixSuffix(
                            labelText: 'Age',
                            controller: visitDetails.ageController,
                            validator: (value) {
                              return null;
                            }),
                        SizedBox(
                          height: 8,
                        ),
                        TextFromFieldWithPrefixSuffix(
                            labelText: 'Address',
                            controller: visitDetails.addressController,
                            validator: (value) {
                              return null;
                            }),
                        SizedBox(
                          height: 8,
                        ),
                        TextFromFieldWithPrefixSuffix(
                            labelText: 'Email',
                            controller: visitDetails.emailController,
                            validator: (value) {
                              return null;
                            }),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                    CustomExpansionTile(
                      title: 'Health Detail',
                      children: [
                        TextFromFieldWithPrefixSuffix(
                            labelText: 'Name',
                            controller: visitDetails.nameController,
                            validator: (value) {
                              return null;
                            }),
                        SizedBox(
                          height: 8,
                        ),
                        TextFromFieldWithPrefixSuffix(
                            labelText: 'Age',
                            controller: ageController,
                            validator: (value) {
                              return null;
                            }),
                        SizedBox(
                          height: 8,
                        ),
                        TextFromFieldWithPrefixSuffix(
                            labelText: 'Weight',
                            controller: weightController,
                            validator: (value) {
                              return null;
                            }),
                        SizedBox(
                          height: 8,
                        ),
                        TextFromFieldWithPrefixSuffix(
                            labelText: 'Diseases',
                            controller: diseasesController,
                            validator: (value) {
                              return null;
                            }),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                    CustomExpansionTile(
                      // applyShadow: false,
                      title: 'Family Detail',
                      children: [
                        ListTile(
                          title: Text('title 1'),
                        ),
                        ListTile(
                          title: Text('title 2'),
                        ),
                        ListTile(
                          title: Text('title 3'),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                    CustomExpansionTile(
                      title: 'Country & States',
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        CustomDropdown(
                            labelText: 'Select Country',
                            items: country,
                            value: selectedCountry,
                            onChanged: (newValue) {
                              setState(() {
                                selectedCountry = newValue!;
                                if (selectedCountry == 'Nepal') {
                                  isVisibleForDistrict = !isVisibleForDistrict;
                                  isVisibleForState = false;
                                  isVisibleForDistrictList =
                                      !isVisibleForDistrictList;
                                } else {
                                  isVisibleForState = !isVisibleForState;
                                  isVisibleForStateList =
                                      !isVisibleForStateList;
                                  isVisibleForDistrict = false;
                                }
                              });
                            }),
                        SizedBox(
                          height: 12,
                        ),
                        Visibility(
                          visible: isVisibleForDistrict,
                          child: TextFromFieldWithPrefixSuffix(
                            applyPrefix: true,
                            prefixIcon: Icon(Icons.search),
                            applySuffixIcon: true,
                            suffixIcon: Icon(Icons.arrow_drop_down),
                            controller: districtTextEditingController,
                            labelText: 'Select District',
                            onTap: () {
                              setState(() {
                                isVisibleForDistrictList =
                                    !isVisibleForDistrictList;
                                isVisibleForStateList = false;
                              });
                            },
                            onChange: (value) => _countryFilter(value!),
                            validator: (Value) {},
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Visibility(
                          visible: isVisibleForDistrictList,
                          child: ColoredBox(
                            color: Colors.white,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: foundDistrict.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    setState(() {
                                      print(foundDistrict.length);
                                      districtTextEditingController.text =
                                          foundDistrict[index];
                                      if (districtTextEditingController.text ==
                                          foundDistrict[index]) {
                                        isVisibleForDistrictList =
                                            !isVisibleForDistrictList;
                                      }
                                    });
                                    print('${foundDistrict[index]}');
                                  },
                                  title: Text('${foundDistrict[index]}'),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Visibility(
                          visible: isVisibleForState,
                          child: TextFromFieldWithPrefixSuffix(
                            applyPrefix: true,
                            prefixIcon: Icon(Icons.search),
                            applySuffixIcon: true,
                            suffixIcon: Icon(Icons.arrow_drop_down),
                            controller: stateTextEditingController,
                            labelText: 'Select State',
                            onTap: () {
                              setState(() {
                                isVisibleForStateList = !isVisibleForStateList;
                              });
                            },
                            onChange: (value) => _stateFilter(value!),
                            validator: (Value) {},
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Visibility(
                          visible: isVisibleForStateList,
                          child: ColoredBox(
                            color: Colors.white,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: foundStates.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    setState(() {
                                      stateTextEditingController.text =
                                          foundStates[index];
                                      if (stateTextEditingController.text ==
                                          foundStates[index]) {
                                        isVisibleForStateList =
                                            !isVisibleForStateList;
                                      }
                                    });
                                    print('${foundStates[index]}');
                                  },
                                  title: Text('${foundStates[index]}'),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                    CustomExpansionTile(
                      radiusBottomRight: 16,
                      radiusBottomLeft: 16,
                      // applyShadow: false,
                      title: 'Referral',
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        CustomDropdown(
                            labelText: 'Referred By *',
                            items: dropDownOptions,
                            value: selectedOption,
                            onChanged: (newValue) {
                              setState(() {
                                selectedOption = newValue!;
                                if (selectedOption == 'Others') {
                                  isVisible = !isVisible;
                                } else {
                                  isVisible = false;
                                }
                              });
                            }),
                        Visibility(
                          visible: isVisible,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              TextFromFieldWithPrefixSuffix(
                                  labelText: 'Name',
                                  controller: nameController,
                                  validator: (value) {
                                    return null;
                                  }),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        TextFromFieldWithPrefixSuffix(
                          borderRadius: 8,
                          controller: referenceController,
                          labelText: 'Referred To:',
                          onTap: () {},
                          validator: (value) {
                            return null;
                          },
                          onChange: (value) {},
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomElevatedButton(
                    onPressed: () {},
                    widget: CustomText(text: 'Back'),
                    backgroundColor: CustomColors.lightRed,
                  ),
                  CustomElevatedButton(
                    onPressed: () {},
                    widget: CustomText(text: 'Submit'),
                    backgroundColor: CustomColors.primaryColor,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}



// CustomDropdown(
//     labelText: 'Select States',
//     items: states,
//     value: selectedState,
//     onChanged: (newValue){
//       setState(() {
//         selectedState = newValue!;
//       });
//     }
// ),


// CustomDropdown(
// labelText: 'select State',
// items: states,
// value: selectedState,
// onChanged: (newValue){
// setState(() {
// selectedState = newValue!;
// // isVisibleForState = !isVisibleForState;
// });
// }
// )