import 'package:deskgoo/pages/mr_officers/mr_officers_pages/mr_officers_visits/mr_officers_visits.dart';
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

class MrOfficersVisitTypeScreen extends StatefulWidget {
  const MrOfficersVisitTypeScreen({super.key});

  @override
  State<MrOfficersVisitTypeScreen> createState() =>
      _MrOfficersVisitTypeScreenState();
}

class _MrOfficersVisitTypeScreenState extends State<MrOfficersVisitTypeScreen> {
  MrOfficerVisitProvider? _mrOfficerVisitProvider;

  @override
  void initState() {
    _mrOfficerVisitProvider =
        Provider.of<MrOfficerVisitProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        Navigator.of(context).pop(RouteGeneratorConstants.homePage);
        _mrOfficerVisitProvider!.unSelectVisitType();
      }),
      child: Scaffold(
        backgroundColor: CustomColors.primaryWhite,
        appBar: _appBar(context),
        body: _chooseVisitType(context),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Visit Type',
        size: 24,
        showLeading: true,
        leadingIcon: FontAwesomeIcons.arrowLeft,
        leadingIconColor: CustomColors.primaryBlack,
        onTapLeadingIcon: () {
          Navigator.of(context).pop(RouteGeneratorConstants.homePage);
          _mrOfficerVisitProvider!.unSelectVisitType();
        },
      ),
    );
  }

  Widget _chooseVisitType(context) {
    return Center(
      child: Consumer<MrOfficerVisitProvider>(
        builder: (context, visitProvider, _) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomContainer(
                  applyShadow: true,
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
                              bool isSelected =
                                  visitProvider.setSelectedVisitType();
                              if (isSelected) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        MROfficersVisitsScreen()));
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
              ],
            ),
          );
        },
      ),
    );
  }
}
