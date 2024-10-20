import 'package:deskgoo/pages/home/home_screen.dart';
import 'package:deskgoo/pages/mr_officers/mr_officers_providers/mr_officer_visit_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/radio_button/custom_radio_button.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../providers/marketing_provider/officersDescription_provider.dart';
import '../../../../providers/visit_provider/visit_screen_provider.dart';
import '../../../../widgets/text_fields/text_from_field.dart';

class MROfficersVisitsScreen extends StatefulWidget {
  const MROfficersVisitsScreen({super.key});

  @override
  State<MROfficersVisitsScreen> createState() => _MROfficersVisitsScreenState();
}

class _MROfficersVisitsScreenState extends State<MROfficersVisitsScreen>
    with SingleTickerProviderStateMixin {
  MrOfficerVisitProvider? _mrOfficerVisitProvider;
  int tabIndex = 0;
  List<String> tabs = [
    'New Visit',
    'Create Visit',
    'FollowUp Visit',
    'Visit Details',
  ];
  double scrollOffset = 0;

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
        // _mrOfficerVisitProvider!.resetSelectedVisitType();
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
          // body: Consumer<MrOfficerVisitProvider>(
          //     builder: (context, visitProvider, _) {
          //   return visitProvider.selectedVisitType.isEmpty
          //       ? _chooseVisitType(context)
          //       : _buildUI(context);
          // }),
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
          // _mrOfficerVisitProvider!.resetSelectedVisitType();
        },
      ),
    );
  }

  Widget _chooseVisitType(context) {
    return Center(
      child: Consumer<MrOfficerVisitProvider>(
          builder: (context, visitProvider, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomContainer(
              child: Column(
                children: [
                  CustomText(
                    text: 'Select Visit Type',
                    fontWeight: FontWeight.w600,
                    size: 22,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomRadioButton(
                    radioGroupValue: visitProvider.radioGroupValue,
                    radioValue: visitProvider.vistTypeList[0],
                    radioTitle: visitProvider.vistTypeList[0],
                    onChange: (value) {
                      visitProvider.selectVisitType(value);
                    },
                  ),
                  CustomRadioButton(
                    radioGroupValue: visitProvider.radioGroupValue,
                    radioValue: visitProvider.vistTypeList[1],
                    radioTitle: visitProvider.vistTypeList[1],
                    showTrailingWidget: true,
                    trailingWidgetTitle: '15',
                    onChange: (value) {
                      visitProvider.selectVisitType(value);
                    },
                  ),
                  CustomRadioButton(
                    radioGroupValue: visitProvider.radioGroupValue,
                    radioValue: visitProvider.vistTypeList[2],
                    radioTitle: visitProvider.vistTypeList[2],
                    showTrailingWidget: true,
                    trailingWidgetTitle: '5',
                    onChange: (value) {
                      visitProvider.selectVisitType(value);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomElevatedButton(
                        onPressed: () {
                          visitProvider.unSelectVisitType();
                          Navigator.of(context)
                              .pop(RouteGeneratorConstants.homePage);
                        },
                        // backgroundColor: ,
                        backgroundColor: CustomColors.lightRed,
                        widget: CustomText(
                          text: 'Cancel',
                          color: CustomColors.primaryBlack,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      CustomElevatedButton(
                        onPressed: () {
                          visitProvider.setSelectedVisitType();
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
          ],
        );
      }),
    );
  }

  Widget _buildUI(context) {
    return GestureDetector(
      onTap: () {
        print('Tapepd on body');
      },
      onHorizontalDragEnd: (details) {
        // Swiping in right direction.
        if (details.primaryVelocity! > 0) {
          setState(() {
            if (tabIndex > 0) {
              tabIndex -= 1;
              scrollOffset = 100;
            }
          });
          // print('${details.delta.dx}');
          print('Swipped right $tabIndex ${tabIndex > 0}');
        }

        // Swiping in left direction.
        if (details.primaryVelocity! < 0) {
          setState(() {
            if (tabIndex < tabs.length - 1) {
              tabIndex += 1;
              scrollOffset = 200;
            }
            // tabIndex < tabs.length ? tabIndex + 1 : null;
          });
          print('Swipped left $tabIndex ${tabIndex < tabs.length}');
          // print('${details.delta.dx}');
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
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      print('Pressed ${tabs[index]}');
                      setState(() {
                        tabIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      color: (tabIndex == 0 && index == 0)
                          ? Colors.red
                          : (tabIndex == 1 && index == 1)
                              ? Colors.yellow
                              : (tabIndex == 2 && index == 2)
                                  ? Colors.purpleAccent
                                  : (tabIndex == 3 && index == 3)
                                      ? Colors.lightGreenAccent
                                      : Colors.white,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.all(8),
                      width: 120,
                      height: 40,
                      child: Center(
                        child: CustomText(
                          text: '${tabs[index]}',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            GestureDetector(
              // position: _offsetAnimation,
              child: tabIndex == 0
                  ? _newVisit(context)
                  : tabIndex == 1
                      ? _createVisit(context)
                      : tabIndex == 2
                          ? _followUpVisit(context)
                          : tabIndex == 3
                              ? _visitDetails(context)
                              : Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _newVisit(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      height: MediaQuery.of(context).size.height * 0.55,
      duration: const Duration(milliseconds: 250),
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
                  // hintText: 'Select Client Name',
                  onTap: () {},
                  validator: (value) {
                    // if (value!.isNotEmpty) {
                    //   isVisitFormValid = true;
                    //   return null;
                    // }
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
                  Container(
                    width: screenWidth * 0.75,
                    child: TextFromFieldWithPrefixSuffix(
                      controller: clientWhatsAppController,
                      applySuffixIcon: true,
                      labelText: 'WhatsApp No',
                      onTap: () {},
                      validator: (value) {
                        return null;
                      },
                      onChange: (value) {},
                    ),
                  ),
                  Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                          if (isSwitched) {
                            clientWhatsAppController.text = clientPhoneController.text;
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
                  print('name = $clientNameController');
                  print('age = $clientAgeTextController');
                  print('address = $clientAddressController');
                  print('phone = $clientPhoneController');
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

  // Future<void> _newVisitshowBottomSheet(context) async {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     useSafeArea: true,
  //     context: context,
  //     builder: (context) => ClipRRect(
  //       borderRadius: BorderRadius.circular(16.0),
  //       child: SizedBox(
  //         height: MediaQuery.of(context).size.height * 0.90,
  //         child: Scaffold(
  //           backgroundColor: Colors.grey.shade200,
  //           appBar: _newVisitbottomSheetAppBar(context),
  //           body: _newVisitbottomSheetBody(context),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // PreferredSize _newVisitbottomSheetAppBar(context) {
  //   return PreferredSize(
  //     preferredSize: Size.fromHeight(kToolbarHeight),
  //     child: CustomAppBar(
  //       showLeading: true,
  //       leadingIcon: FontAwesomeIcons.arrowLeft,
  //       tabName: 'Search Client',
  //       onTapLeadingIcon: () {
  //         Navigator.pop(context);
  //       },
  //     ),
  //   );
  // }

  // Widget _newVisitbottomSheetBody(context) {
  //   DetailsProvider detailsProvider =
  //   Provider.of<DetailsProvider>(context, listen: true);
  //   return Center(
  //     child: CustomContainer(
  //       verticalMargin: 16.0,
  //       child: Column(
  //         children: [
  //           Consumer<VisitScreenProvider>(
  //             builder: (context, provider, _) {
  //               return TextFromFieldWithPrefixSuffix(
  //                 controller: searchClientController,
  //                 labelText: 'Search Client',
  //                 applyPrefix: true,
  //                 prefixIcon: Icon(Icons.search),
  //                 validator: (value) {
  //                   return null;
  //                 },
  //                 onChange: (value) => provider
  //                     .runSearchClientFilter(searchClientController.value.text),
  //                 onTap: () {},
  //               );
  //             },
  //           ),
  //           Expanded(
  //             child: Consumer<VisitScreenProvider>(
  //               builder: (context, provider, _) {
  //                 return ListView.builder(
  //                   itemCount: provider.searchVistiCleintResults.length,
  //                   itemBuilder: (context, index) {
  //                     return InkWell(
  //                       onTap: () {
  //                         print(provider.searchVistiCleintResults[index]);
  //                         provider.setClientName(
  //                           provider.searchVistiCleintResults[index]['client']
  //                               .toString(),
  //                           provider.searchVistiCleintResults[index]['address']
  //                               .toString(),
  //                           provider.searchVistiCleintResults[index]['phone']
  //                               .toString(),
  //                           '${DateTime.now().toString().split('.')[0]}',
  //                           provider.searchVistiCleintResults[index]['email'],
  //                           provider.searchVistiCleintResults[index]['pan'],
  //                         );
  //                         clientNameController.text = provider
  //                             .searchVistiCleintResults[index]['client']
  //                             .toString();
  //                         addressController.text = provider
  //                             .searchVistiCleintResults[index]['address']
  //                             .toString();
  //                         phoneController.text = provider
  //                             .searchVistiCleintResults[index]['phone']
  //                             .toString();
  //                         emailController.text = provider
  //                             .searchVistiCleintResults[index]['email']
  //                             .toString();
  //                         panController.text = provider
  //                             .searchVistiCleintResults[index]['pan']
  //                             .toString();
  //                         Navigator.pop(context);
  //                         provider.resetSearchClientFilter();
  //                       },
  //                       child: ListTile(
  //                         leading: CustomText(
  //                             text: provider.searchVistiCleintResults[index]
  //                             ['client']),
  //                       ),
  //                     );
  //                   },
  //                 );
  //               },
  //             ),
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               CustomElevatedButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 borderColor: CustomColors.lightRed,
  //                 widget: CustomText(
  //                   text: 'Cancel',
  //                   color: CustomColors.lightRed,
  //                 ),
  //               ),
  //               // CustomElevatedButton(
  //               //   onPressed: () {
  //               //     Navigator.pop(context);
  //               //   },
  //               //   borderColor: CustomColors.primaryColor,
  //               //   widget: CustomText(
  //               //     text: 'Create',
  //               //     color: CustomColors.primaryColor,
  //               //   ),
  //               // ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _createVisit(context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 400,
      width: double.infinity,
      color: Colors.yellow,
      child: Center(
        child: CustomText(text: 'Create Visit'),
      ),
    );
  }

  Widget _visitDetails(context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 400,
      width: double.infinity,
      color: Colors.lightGreenAccent,
      child: Center(
        child: CustomText(text: 'Visit Details'),
      ),
    );
  }

  Widget _followUpVisit(context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 400,
      width: double.infinity,
      color: Colors.purpleAccent,
      child: Center(
        child: CustomText(text: 'FollowUp Visit'),
      ),
    );
  }
}
