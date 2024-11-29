import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';

class MrOfficerNewVisitScreen extends StatefulWidget {
  const MrOfficerNewVisitScreen({super.key});

  @override
  State<MrOfficerNewVisitScreen> createState() =>
      _MrOfficerNewVisitScreenState();
}

class _MrOfficerNewVisitScreenState extends State<MrOfficerNewVisitScreen> {
  TextEditingController fullNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              TextFromFieldWithPrefixSuffix(
                controller: fullNameController,
                labelText: 'Number',
                validator: (newValue) {},
              ),
              SizedBox(
                height: 16,
              ),
              TextFromFieldWithPrefixSuffix(
                controller: fullNameController,
                labelText: 'Country',
                validator: (newValue) {},
              ),
              SizedBox(
                height: 16,
              ),
              TextFromFieldWithPrefixSuffix(
                controller: fullNameController,
                labelText: 'District',
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
              TextFromFieldWithPrefixSuffix(
                controller: fullNameController,
                labelText: 'Category',
                validator: (newValue) {},
              ),
              SizedBox(
                height: 16,
              ),
              TextFromFieldWithPrefixSuffix(
                controller: fullNameController,
                labelText: 'Specialization',
                validator: (newValue) {},
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
                      Navigator.of(context)
                          .pop(MarketingOfficerConstants.mrStaffDashboardConst);
                    },
                    widget: CustomText(
                      text: 'Back',
                      isContent: true,
                    ),
                    backgroundColor: CustomColors.lightRed,
                  ),
                  CustomElevatedButton(
                    onPressed: () {},
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
  }
}
