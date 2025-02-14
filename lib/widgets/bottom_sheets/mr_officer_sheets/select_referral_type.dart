import 'package:deskgoo/providers/mr_officer_provider/mr_followup_provider.dart';
import 'package:deskgoo/providers/mr_officer_provider/mr_referral_provider.dart';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/radio_button/custom_radio_button.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MrOfficerSelectReferralTypeBottomSheet extends StatefulWidget {
  const MrOfficerSelectReferralTypeBottomSheet({super.key});

  @override
  State<MrOfficerSelectReferralTypeBottomSheet> createState() =>
      _MrOfficerSelectReferralTypeBottomSheetState();
}

class _MrOfficerSelectReferralTypeBottomSheetState
    extends State<MrOfficerSelectReferralTypeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return _buildUI(context);
  }

  Widget _buildUI(context) {
    return CustomContainer(
      width: 1,
      verticalPad: 12,
      child: Consumer<ReferralsDetailProvider>(
        builder: (context, referralProvider, _) {
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
                      radioGroupValue: referralProvider.radioGroupValue,
                      radioValue: referralProvider.referralTypeList[0],
                      radioTitle: referralProvider.referralTypeList[0],
                      onChange: (value) {
                        referralProvider.selectVisitType(value);
                      },
                    ),
                    CustomRadioButton(
                      radioGroupValue: referralProvider.radioGroupValue,
                      radioValue: referralProvider.referralTypeList[1],
                      radioTitle: referralProvider.referralTypeList[1],
                      // showTrailingWidget: true,
                      // trailingWidgetTitle: '15',
                      onChange: (value) {
                        referralProvider.selectVisitType(value);
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
                            referralProvider.unSelectVisitType();
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
                        Consumer<MrOfficerFollowUpProvider>(
                            builder: (context, followUpProvider, _) {
                          return CustomElevatedButton(
                            onPressed: () async {
                              bool isSelected =
                                  referralProvider.setSelectedVisitType();
                              if (isSelected) {
                                if (referralProvider.selectedReferralType ==
                                    referralProvider.referralTypeList[0]) {
                                  Navigator.pop(context);
                                  Navigator.of(context).pushNamed(
                                      MarketingOfficerConstants.referral);
                                } else {
                                  Navigator.pop(context);
                                  Navigator.of(context).pushNamed(
                                      MarketingOfficerConstants.visitLog);
                                }
                              }
                            },
                            backgroundColor: CustomColors.primaryColor,
                            widget: CustomText(
                              text: 'Next',
                              color: CustomColors.primaryBlack,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }),
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
