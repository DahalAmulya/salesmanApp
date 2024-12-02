import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/expansion_tile/custom_expansiontile.dart';
import '../../../../widgets/text_fields/text_from_field.dart';

class MrOfficerReferralScreen extends StatefulWidget {
  const MrOfficerReferralScreen({super.key});

  @override
  State<MrOfficerReferralScreen> createState() =>
      _MrOfficerReferralScreenState();
}

class _MrOfficerReferralScreenState extends State<MrOfficerReferralScreen> {
  TextEditingController nameText =  TextEditingController();
  TextEditingController ageText =  TextEditingController();
  TextEditingController genderText =  TextEditingController();
  TextEditingController provisionalDiagnosisText =  TextEditingController();
  TextEditingController countryText =  TextEditingController();
  TextEditingController districtText =  TextEditingController();
  TextEditingController cityText =  TextEditingController();
  TextEditingController addressText =  TextEditingController();
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
      child: CustomAppBar(
        tabName: 'Referral',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTapLeadingIcon: () {
          Navigator.of(context)
              .pop(MarketingOfficerConstants.mrStaffDashboardConst);
        },
      ),
    );
  }

  Widget _buildUI(context) {
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CustomExpansionTile(
            radiusTopLeft: 16,
              radiusTopRight: 16,
              radiusBottomLeft: 16,
              radiusBottomRight: 16,
              title:'Personal Details',
             size: 20,
            fontWeight: FontWeight.w600,
            children: [
              TextFromFieldWithPrefixSuffix(
                autoFocus: false,
                hintText: 'Patient Name',
                labelText: 'Patient Name',
                controller: nameText,
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
                controller: ageText,
                validator: (value) {
                  return value!.isEmpty
                      ? 'Age is required'
                      : value.length < 3
                      ? 'Enter at least 1 characters'
                      : null;
                },
              ),
              SizedBox(
                height: 16,
              ),
              TextFromFieldWithPrefixSuffix(
                autoFocus: false,
                hintText: 'Gender',
                labelText: 'Gender',
                controller: genderText,
                validator: (value) {
                  return value!.isEmpty
                      ? 'Gender is required'
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
                hintText: 'Provisional Diagnosis',
                labelText: 'Provisional Diagnosis',
                controller: provisionalDiagnosisText,
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
              TextFromFieldWithPrefixSuffix(
                autoFocus: false,
                hintText: 'Country',
                labelText: 'Select Country',
                controller: countryText,
                validator: (value) {
                  return value!.isEmpty
                      ? 'Activity note is required'
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
                hintText: 'District',
                labelText: 'District',
                controller: districtText,
                validator: (value) {
                  return value!.isEmpty
                      ? 'District is required'
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
                hintText: 'City',
                labelText: 'City',
                controller: cityText,
                validator: (value) {
                  return value!.isEmpty
                      ? 'Activity note is required'
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
                hintText: 'Address',
                labelText: 'Address',
                controller: addressText,
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
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CustomExpansionTile(
            radiusTopLeft: 16,
            radiusTopRight: 16,
            radiusBottomLeft: 16,
            radiusBottomRight: 16,
            title:'Referred By',
            size: 20,
            fontWeight: FontWeight.w600,
            children: [
              TextFromFieldWithPrefixSuffix(
                autoFocus: false,
                hintText: 'Name',
                labelText: 'Name',
                controller: nameText,
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
                labelText: '--------',
                controller: ageText,
                validator: (value) {
                  return value!.isEmpty
                      ? 'Age is required'
                      : value.length < 3
                      ? 'Enter at least 1 characters'
                      : null;
                },
              ),
              SizedBox(
                height: 16,
              ),
              TextFromFieldWithPrefixSuffix(
                autoFocus: false,
                labelText: '-----------',
                controller: genderText,
                validator: (value) {
                  return value!.isEmpty
                      ? 'Gender is required'
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
                labelText: '----------------',
                controller: provisionalDiagnosisText,
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
              TextFromFieldWithPrefixSuffix(
                autoFocus: false,
                labelText: '-------------------',
                controller: countryText,
                validator: (value) {
                  return value!.isEmpty
                      ? 'Activity note is required'
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
                labelText: '----------------',
                controller: districtText,
                validator: (value) {
                  return value!.isEmpty
                      ? 'District is required'
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
        )
      ],
    );
  }
}
