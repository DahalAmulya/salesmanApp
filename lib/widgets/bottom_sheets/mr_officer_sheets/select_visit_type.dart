import 'package:deskgoo/pages/mr_officers/mr_officers_pages/mr_officers_visits/mr_officers_visits.dart';
import 'package:deskgoo/pages/mr_officers/mr_officers_providers/mr_officer_visit_provider.dart';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/radio_button/custom_radio_button.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MrOfficerSelectVisitTypeBottomSheet extends StatefulWidget {
  const MrOfficerSelectVisitTypeBottomSheet({super.key});

  @override
  State<MrOfficerSelectVisitTypeBottomSheet> createState() =>
      _MrOfficerSelectVisitTypeBottomSheetState();
}

class _MrOfficerSelectVisitTypeBottomSheetState
    extends State<MrOfficerSelectVisitTypeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return _buildUI(context);
  }

  Widget _buildUI(context) {
    return CustomContainer(
      width: 1,
      verticalPad: 12,
      child: Consumer<MrOfficerVisitProvider>(
        builder: (context, visitProvider, _) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    CustomText(
                      text: 'Select Visit Type',
                      fontWeight: FontWeight.w600,
                      size: 22,
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Divider(),
                    SizedBox(
                      height: 0,
                    ),
                    CustomRadioButton(
                      radioGroupValue: visitProvider.radioGroupValue,
                      radioValue: visitProvider.visitTypeList[0],
                      radioTitle: visitProvider.visitTypeList[0],
                      onChange: (value) {
                        visitProvider.selectVisitType(value);
                      },
                    ),
                    CustomRadioButton(
                      radioGroupValue: visitProvider.radioGroupValue,
                      radioValue: visitProvider.visitTypeList[1],
                      radioTitle: visitProvider.visitTypeList[1],
                      // showTrailingWidget: true,
                      // trailingWidgetTitle: '15',
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
                                .pop(MarketingManagerConstants.homePage);
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
                              if (visitProvider.selectedVisitType ==
                                  visitProvider.visitTypeList[0]) {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamed(
                                    MarketingOfficerConstants.newVisit);
                              } else {
                                Navigator.pop(context);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        MROfficersVisitsScreen()));
                              }
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
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
