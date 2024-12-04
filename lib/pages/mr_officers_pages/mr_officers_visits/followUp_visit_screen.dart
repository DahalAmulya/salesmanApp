import 'dart:convert';
import 'package:deskgoo/providers/mr_officer_provider/mr_visit_provider.dart';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        Navigator.of(context)
            .pop(MarketingOfficerConstants.mrStaffDashboardConst);
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
          Navigator.of(context)
              .pop(MarketingOfficerConstants.mrStaffDashboardConst);
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
                    text: 'POC Details',
                    isSubHeading: true,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFromFieldWithPrefixSuffix(
                    controller: createVisitProvider.nameController,
                    labelText: 'Full Name',
                    readOnly: true,
                    validator: (newValue) {},
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFromFieldWithPrefixSuffix(
                    controller: createVisitProvider.nameController,
                    labelText: 'Category',
                    readOnly: true,
                    validator: (newValue) {},
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFromFieldWithPrefixSuffix(
                    controller: createVisitProvider.nameController,
                    labelText: 'Specialization',
                    readOnly: true,
                    validator: (newValue) {},
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFromFieldWithPrefixSuffix(
                    controller: createVisitProvider.ageController,
                    labelText: 'Age',
                    readOnly: true,
                    validator: (newValue) {},
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFromFieldWithPrefixSuffix(
                    controller: createVisitProvider.phoneNoController,
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    labelText: 'Number',
                    onTap: () {},
                    validator: (value) {
                      return value!.isEmpty ? 'Phone number Required' : null;
                    },
                    onChange: (value) {},
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFromFieldWithPrefixSuffix(
                    controller: createVisitProvider.addressController,
                    readOnly: true,
                    labelText: 'Address',
                    maxLines: 23,
                    validator: (newValue) {},
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFromFieldWithPrefixSuffix(
                    controller: createVisitProvider.addressController,
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
                        },
                        widget: CustomText(
                          text: 'Back',
                          isContent: true,
                        ),
                        backgroundColor: CustomColors.lightRed,
                      ),
                      CustomElevatedButton(
                        onPressed: () {
                          createVisitProvider.getCurrentLocation();
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
}
