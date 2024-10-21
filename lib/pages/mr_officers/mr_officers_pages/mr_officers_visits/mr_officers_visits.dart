import 'package:deskgoo/pages/mr_officers/mr_officers_providers/mr_officer_visit_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
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
  int tabIndex = 0;
  double scrollOffset = 0;
  Widget? _selectedVisit;

  final _newVisitFormKey = GlobalKey<FormState>();
  final clientNameController = TextEditingController();
  final clientAddressController = TextEditingController();
  final clientPhoneController = TextEditingController();
  final clientEmailController = TextEditingController();
  final clientWhatsAppController = TextEditingController();
  final clientAgeTextController = TextEditingController();
  final searchClientController = TextEditingController();
  bool isVisitFormValid = false;
  bool isSwitched = false;

  void clearNewVisitValues() {
    searchClientController.clear();
    clientNameController.clear();
    clientAddressController.clear();
    clientPhoneController.clear();
    clientEmailController.clear();
    clientWhatsAppController.clear();
  }

  @override
  void initState() {
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
          // onTap: () {
          //   print('Tapepd on body');
          // },
          onHorizontalDragEnd: (details) {
            // Swiping in right direction.
            if (details.primaryVelocity! > 0) {
              if (mrOfficerVisitProvider.tabIndex > 0) {
                mrOfficerVisitProvider
                    .setTabIndex(mrOfficerVisitProvider.tabIndex - 1);
              }
              print('Swipped right $tabIndex ${tabIndex > 0}');
            }

            // Swiping in left direction.
            if (details.primaryVelocity! < 0) {
              if (mrOfficerVisitProvider.tabIndex <
                  mrOfficerVisitProvider.selectedVisitTypeList.length - 1) {
                mrOfficerVisitProvider
                    .setTabIndex(mrOfficerVisitProvider.tabIndex + 1);
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
                  height: 60,
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
                          mrOfficerVisitProvider.setTabIndex(index);
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
                          margin: EdgeInsets.all(8),
                          width: 120,
                          height: 40,
                          child: Center(
                            child: CustomText(
                              text: tabName,
                              fontWeight: FontWeight.w500,
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      // height: 400,
      width: double.infinity,
      child: CustomContainer(
        horizontalMargin: 8,
        verticalMargin: 8,
        child: Form(
          key: _newVisitFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Builder(builder: (context) {
                return TextFromFieldWithPrefixSuffix(
                  controller: clientNameController,
                  labelText: 'Name*',
                  onTap: () {},
                  validator: (value) {
                    return value!.isEmpty ? 'Client Name Required' : null;
                  },
                  onChange: (value) {},
                );
              }),
              SizedBox(
                height: 10.0,
              ),
              TextFromFieldWithPrefixSuffix(
                controller: clientAgeTextController,
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
                controller: clientAddressController,
                labelText: 'Address*',
                onTap: () {},
                validator: (value) {
                  return value!.isEmpty ? 'Client Address Required' : null;
                },
                onChange: (value) {},
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFromFieldWithPrefixSuffix(
                controller: clientPhoneController,
                labelText: 'Phone*',
                onTap: () {},
                validator: (value) {
                  return value!.isEmpty ? 'Phone number Required' : null;
                },
                onChange: (value) {},
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFromFieldWithPrefixSuffix(
                controller: clientAddressController,
                labelText: 'Email',
                onTap: () {},
                validator: (value) {
                  return null;
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
                      controller: clientWhatsAppController,
                      applySuffixIcon: true,
                      labelText: 'WhatsApp No.',
                      onTap: () {},
                      validator: (value) {
                        return null;
                      },
                      onChange: (value) {},
                    ),
                  ),
                  Switch(
                      activeColor: CustomColors.primaryBlack,
                      activeTrackColor: CustomColors.primaryColor,
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                          if (isSwitched) {
                            clientWhatsAppController.text =
                                clientPhoneController.text;
                          } else {
                            clientWhatsAppController.clear();
                          }
                        });
                      }),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              InkWell(
                onTap: () {
                  _newVisitFormKey.currentState!.validate();
                  print('name = ${clientNameController.value.text}');
                  print('age = ${clientAgeTextController.value.text}');
                  print('address = ${clientAddressController.value.text}');
                  print('phone = ${clientPhoneController.value.text}');
                  print('email = $clientEmailController');
                  print('whatsapp = $clientWhatsAppController');
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.24,
                  height: MediaQuery.of(context).size.height * 0.048,
                  decoration: BoxDecoration(
                    color: CustomColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomText(
                      text: 'Submit',
                      size: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      // height: 400,
      width: double.infinity,
      color: CustomColors.primaryColor,
      child: Center(
        child: CustomText(text: 'Visit Details'),
      ),
    );
  }
}
