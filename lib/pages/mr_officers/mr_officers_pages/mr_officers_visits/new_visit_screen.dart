import 'package:deskgoo/pages/mr_officers/mr_officers_provider/mr_officer_provider.dart';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drop_downs/custom_dropdown.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
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
        tabName: 'New Visit',
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
                  text: 'Personal Details',
                  isSubHeading: true,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  controller: fullNameController,
                  labelText: 'Full Name',
                  validator: (newValue) {},
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  controller: fullNameController,
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
                  controller: fullNameController,
                  labelText: createVisitProvider.selectedCountry ==
                          createVisitProvider.country[0]
                      ? 'District'
                      : 'State',
                  validator: (newValue) {},
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  controller: fullNameController,
                  labelText: 'City',
                  validator: (newValue) {},
                ),
                SizedBox(
                  height: 16,
                ),
                TextFromFieldWithPrefixSuffix(
                  controller: fullNameController,
                  labelText: 'Address',
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
                TextFromFieldWithPrefixSuffix(
                  controller: fullNameController,
                  labelText: 'Organization',
                  validator: (newValue) {},
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(
                            MarketingOfficerConstants.mrStaffDashboardConst);
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
    });
  }
}
