import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drop_downs/custom_dropdown.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';

class MrAdminReportScreen extends StatefulWidget {
  const MrAdminReportScreen({super.key});

  @override
  State<MrAdminReportScreen> createState() => _MrAdminReportScreenState();
}

class _MrAdminReportScreenState extends State<MrAdminReportScreen> {
  List<String> filterBy = [
    'Area-wise',
    'Coverage-wise',
    'Officer-wise',
    'visit-wise',
  ];
  String selectedFilter = '';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        Navigator.of(context).pop(MarketingManagerConstants.homePage);
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
          body: _buildI(context),
        ),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Report',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTap: () {
          Navigator.of(context).pop(MarketingManagerConstants.homePage);
        },
      ),
    );
  }

  Widget _buildI(context) {
    selectedFilter = filterBy[0];
    return Center(
      child: Column(
        children: [
          CustomContainer(
            applyShadow: true,
            verticalMargin: 16,
            child: Column(
              children: [
                CustomText(
                  text: 'Marking Officers',
                  isSubHeading: true,
                ),
                SizedBox(
                  height: 16,
                ),
                CustomDropdown(
                  labelText: 'Filter by',
                  items: filterBy,
                  value: selectedFilter,
                  onChanged: (newValue) {
                    setState(() {
                      selectedFilter = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
