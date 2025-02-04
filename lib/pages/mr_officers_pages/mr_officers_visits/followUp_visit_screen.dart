import 'dart:convert';
import 'package:deskgoo/providers/mr_officer_provider/mr_followup_provider.dart';
import 'package:deskgoo/providers/mr_officer_provider/mr_visit_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MrOfficerFollowUpVisitScreen extends StatefulWidget {
  const MrOfficerFollowUpVisitScreen({super.key});

  @override
  State<MrOfficerFollowUpVisitScreen> createState() =>
      _MrOfficerFollowUpVisitScreenState();
}

class _MrOfficerFollowUpVisitScreenState
    extends State<MrOfficerFollowUpVisitScreen> {
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
        tabName: 'Follow Up',
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
    return Consumer<MrOfficerFollowUpProvider>(
      builder: (context, followUpProvider, _) {
        followUpProvider.getCurrentTimeAndLocation();
        return SingleChildScrollView(
          child: Center(
            child: Stack(
              children: [
                CustomContainer(
                  verticalMargin: 24,
                  applyShadow: true,
                  child: Column(
                    children: [
                      CustomText(
                        text: 'POC Details',
                        isSubHeading: true,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFromFieldWithPrefixSuffix(
                        controller: followUpProvider.fullNameController,
                        labelText: 'Full Name *',
                        readOnly: true,
                        validator: (newValue) {},
                        onTap: () {
                          // followUpProvider.GetPOCList(context);
                          showModalBottomSheet(
                              isScrollControlled: true,
                              useSafeArea: true,
                              context: context,
                              builder: (context) =>
                                  _POCModalBottomSheet(context));
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFromFieldWithPrefixSuffix(
                        controller: followUpProvider.categoryController,
                        labelText: 'Category',
                        readOnly: true,
                        validator: (newValue) {},
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFromFieldWithPrefixSuffix(
                        controller: followUpProvider.specializationController,
                        labelText: 'Specialization',
                        maxLines: 2,
                        readOnly: true,
                        validator: (newValue) {},
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFromFieldWithPrefixSuffix(
                        controller: followUpProvider.ageController,
                        labelText: 'Age',
                        readOnly: true,
                        validator: (newValue) {},
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFromFieldWithPrefixSuffix(
                        controller: followUpProvider.numberController,
                        keyboardType: TextInputType.number,
                        readOnly: true,
                        labelText: 'Number',
                        onTap: () {},
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Phone number Required'
                              : null;
                        },
                        onChange: (value) {},
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFromFieldWithPrefixSuffix(
                        controller: followUpProvider.addressController,
                        readOnly: true,
                        labelText: 'Address',
                        maxLines: 2,
                        validator: (newValue) {},
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFromFieldWithPrefixSuffix(
                        controller: followUpProvider.organizationController,
                        readOnly: true,
                        labelText: 'Organization',
                        maxLines: 2,
                        validator: (newValue) {},
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFromFieldWithPrefixSuffix(
                        controller: followUpProvider.remarksController,
                        maxLines: 3,
                        labelText: 'Remarks *',
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
                              final file = await rootBundle
                                  .loadString('assets/district.json');
                              final content = await jsonDecode(file);
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
                              followUpProvider.postFollowUp();
                              // followUpProvider.GetPOCList();
                              // followUpProvider.getCurrentLocation();
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
                Positioned(
                  right: 8,
                  top: 28,
                  child: IconButton(
                    onPressed: () {
                      print('Pressed on edit');
                    },
                    icon: Icon(FontAwesomeIcons.edit),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//---------------------------------------------------------------- bottomSheet-------------------------------------------------------------------//
  Widget _POCModalBottomSheet(context) {
    return Consumer<MrOfficerFollowUpProvider>(
      builder: (context, followUpProvider, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.90,
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
                          controller: followUpProvider.searchByNameController,
                          labelText: 'Search POC name',
                          applySuffixIcon: true,
                          suffixIcon: Icon(Icons.search),
                          validator: (value) {},
                          // onChange: (value) => visitProvider.searchAddressResult(
                          //     visitProvider.searchController.value.text, content),
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
                    itemCount: followUpProvider.pocList.length,
                    itemBuilder: (context, index) {
                      // String cityName = visitProvider.searchResult[index];
                      return ListTile(
                        onTap: () {
                          // print(followUpProvider.pocList[index]);
                          // followUpProvider.getPOCDetailByID(
                          //     followUpProvider.pocList[index]['_id']);
                          print(followUpProvider.pocList[index]);
                          String id = followUpProvider.pocList[index]['_id'];
                          String name =
                              followUpProvider.pocList[index]['pocName'];
                          String category =
                              followUpProvider.pocList[index]['category'];
                          String specialization =
                              followUpProvider.pocList[index]['specialization'];
                          String age =
                              followUpProvider.pocList[index]['age'].toString();
                          String number =
                              followUpProvider.pocList[index]['number'];
                          String address =
                              followUpProvider.pocList[index]['address'];
                          String organization =
                              followUpProvider.pocList[index]['organization'];
                          followUpProvider.setPOCDetails(
                              id,
                              name,
                              category,
                              specialization,
                              age,
                              number,
                              address,
                              organization);
                          Navigator.pop(context);
                        },
                        title: CustomContainer(
                          applyShadow: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CustomText(
                                      text: 'Name',
                                      isContent: true,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: followUpProvider.pocList[index]
                                          ['pocName'],
                                      isContent: true,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CustomText(
                                      text: 'Number',
                                      isContent: true,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: followUpProvider.pocList[index]
                                          ['number'],
                                      isContent: true,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CustomText(
                                      text: 'Address',
                                      isContent: true,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: followUpProvider.pocList[index]
                                          ['address'],
                                      isContent: true,
                                      maxLines: 2,
                                    ),
                                  ),
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
