import 'package:deskgoo/pages/mr_officers/mr_officers_pages/mr_officers_visits/mr_officers_visit_type_screen.dart';
import 'package:deskgoo/pages/mr_officers/mr_officers_provider/mr_officer_provider.dart';
import 'package:deskgoo/pages/mr_officers/mr_officers_providers/mr_officer_visit_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/text_fields/text_from_field.dart';

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

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final diseasesController = TextEditingController();

  @override
  void initState() {
    _mrOfficerVisitProvider =
        Provider.of<MrOfficerVisitProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
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
            .pushReplacementNamed(RouteGeneratorConstants.homePage);
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
              .pushReplacementNamed(RouteGeneratorConstants.homePage);
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
                      height: 10.0,
                    ),
                    TextFromFieldWithPrefixSuffix(
                      controller: createVisitProvider.createAgeController,
                      labelText: 'Age',
                      onTap: () {},
                      validator: (value) {
                        return null;
                      },
                      onChange: (value) {},
                    ),
                    SizedBox(
                      height: 10.0,
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
                      height: 10.0,
                    ),
                    TextFromFieldWithPrefixSuffix(
                      controller: createVisitProvider.createPhoneNoController,
                      labelText: 'Phone *',
                      onTap: () {},
                      validator: (value) {
                        return value!.isEmpty ? 'Phone number Required' : null;
                      },
                      onChange: (value) {},
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFromFieldWithPrefixSuffix(
                            controller:
                                createVisitProvider.createWhatsAppController,
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
                      height: 10.0,
                    ),
                    TextFromFieldWithPrefixSuffix(
                      controller: createVisitProvider.createEmailController,
                      labelText: 'Email',
                      onTap: () {},
                      validator: (value) {
                        return null;
                      },
                      onChange: (value) {},
                    ),
                    SizedBox(
                      height: 8.0,
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
    return CustomContainer(
      applyShadow: true,
      horizontalMargin: 8,
      verticalMargin: 8,
      child: Column(
        children: <Widget>[
          Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: true,
              title: Text('Visit Detail'),
              children: [
                TextFromFieldWithPrefixSuffix(
                    labelText: 'Name',
                    controller: nameController,
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
                    labelText: 'Address',
                    controller: addressController,
                    validator: (value) {
                      return null;
                    }),
                SizedBox(
                  height: 8,
                ),
                TextFromFieldWithPrefixSuffix(
                    labelText: 'Email',
                    controller: emailController,
                    validator: (value) {
                      return null;
                    }),
              ],
              onExpansionChanged: (bool value) {
                setState(() => _customIcon = value);
              },
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text('Health Details'),
              children: [
                TextFromFieldWithPrefixSuffix(
                    labelText: 'Name',
                    controller: nameController,
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
              ],
              onExpansionChanged: (bool value) {
                setState(() => _customIcon = value);
              },
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text('Family Details'),
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
              ],
              onExpansionChanged: (bool value) {
                setState(() => _customIcon = value);
              },
            ),
          )
        ],
      ),
    );
  }
}
