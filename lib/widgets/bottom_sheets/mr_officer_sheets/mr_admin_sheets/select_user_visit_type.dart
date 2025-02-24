import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/radio_button/custom_radio_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../pages/mr_admin/mr_admin_providers/mr_admin_createuser_provider.dart';
import '../../../../routes/route_generator_constants.dart';
import '../../../../themes/custom_colors.dart';
import '../../../texts/custom_text.dart';

class MrAdminSelectUserTypeBottomSheet extends StatefulWidget {
  const MrAdminSelectUserTypeBottomSheet({super.key});

  @override
  State<MrAdminSelectUserTypeBottomSheet> createState() =>
      _MrAdminSelectUserTypeBottomSheetState();
}

class _MrAdminSelectUserTypeBottomSheetState
    extends State<MrAdminSelectUserTypeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return _buildUI(context);
  }

  Widget _buildUI(context) {
    return CustomContainer(
        width: 1,
        verticalPad: 12,
        child: Consumer<CreateUserProvider>(
            builder: (context, createUserProvider, _) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    CustomText(
                      text: 'Select User Type',
                      isHeading: true,
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Divider(),
                    SizedBox(
                      height: 0,
                    ),
                    CustomRadioButton(
                        radioGroupValue: createUserProvider.radioGroupValue,
                        radioValue: createUserProvider.userTypeList[0],
                        radioTitle: createUserProvider.userTypeList[0],
                        onChange: (value) {
                          createUserProvider.selectUserVisitType(value);
                        }),
                    SizedBox(
                      height: 8,
                    ),
                    CustomRadioButton(
                        radioGroupValue: createUserProvider.radioGroupValue,
                        radioValue: createUserProvider.userTypeList[1],
                        radioTitle: createUserProvider.userTypeList[1],
                        onChange: (value) {
                          createUserProvider.selectUserVisitType(value);
                        }),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomElevatedButton(
                          onPressed: () {
                            createUserProvider.unSelectUserVisitType();
                            Navigator.pop(context);
                          },
                          widget: CustomText(
                            text: 'Cancel',
                            color: CustomColors.primaryBlack,
                            isContent: true,
                          ),
                          backgroundColor: CustomColors.lightRed,
                        ),
                        Consumer<CreateUserProvider>(
                            builder: (context, createUserProvider, _) {
                          return CustomElevatedButton(
                            onPressed: () async {
                              // createUserProvider.unSelectUserVisitType();
                              bool isSelected =
                                  createUserProvider.setSelectedUserVisitType();
                              if (isSelected) {
                                if (createUserProvider.selectedUserVisitType ==
                                    createUserProvider.userTypeList[0]) {
                                  createUserProvider.resetRoles();
                                  createUserProvider.getRoleList(context);
                                  Navigator.pop(context);
                                  Navigator.of(context).pushNamed(
                                      MarketingManagerConstants
                                          .mrManagerCreateUserPage);
                                } else if (createUserProvider
                                        .selectedUserVisitType ==
                                    createUserProvider.userTypeList[1]) {
                                  Navigator.pop(context);
                                  createUserProvider.getUserDetails();
                                  Navigator.of(context).pushNamed(
                                      MarketingManagerConstants
                                          .mrManagerViewUserPage);
                                } else {
                                  Navigator.pop(context);
                                  Navigator.of(context).pushNamed(
                                      MarketingManagerConstants.settingPage);
                                }
                              }
                            },
                            widget: CustomText(
                              text: 'Next',
                              color: CustomColors.primaryBlack,
                              isContent: true,
                            ),
                            backgroundColor: CustomColors.primaryColor,
                          );
                        })
                      ],
                    )
                  ],
                )
              ],
            ),
          );
        }));
  }
}
