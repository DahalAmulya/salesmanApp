import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../routes/route_generator_constants.dart';
import '../../../../themes/custom_colors.dart';
import '../../../../widgets/app_bars/custom_app_bars.dart';

class MarketingAdminViewUser extends StatefulWidget {
  const MarketingAdminViewUser({super.key});

  @override
  State<MarketingAdminViewUser> createState() => _MarketingAdminViewUserState();
}

class _MarketingAdminViewUserState extends State<MarketingAdminViewUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _buildUI(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) {
          return CustomAppBar(
            tabName: 'View User',
            showLeading: true,
            leadingIcon: FontAwesomeIcons.arrowLeft,
            leadingIconColor: CustomColors.primaryBlack,
            onTapLeadingIcon: () {
              Navigator.of(context).pop(MarketingManagerConstants.settingPage);
            },
          );
        },
      ),
    );
  }

  Widget _buildUI(BuildContext context){
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: 3, // replace with actual number of users.
                itemBuilder: (context,index){
              return ListTile(
                title:  CustomContainer(
                  applyShadow: true,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: 'Name :',
                              isContent: true,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: 'Shuvam',
                              isContent: true,
                            ),
                          ),
                          Spacer(),
                          FaIcon(FontAwesomeIcons.pen,size: 16,)
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: 'Password :',
                              isContent: true,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: '',
                              isContent: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: 'Role :',
                              isContent: true,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: '',
                              isContent: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: 'Department :',
                              isContent: true,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: '',
                              isContent: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: 'Email :',
                              isContent: true,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: '',
                              isContent: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: 'Designation :',
                              isContent: true,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: '',
                              isContent: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: 'Address :',
                              isContent: true,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: '',
                              isContent: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: 'DOB :',
                              isContent: true,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: '',
                              isContent: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: 'Number :',
                              isContent: true,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: '',
                              isContent: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: 'Gender :',
                              isContent: true,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: '',
                              isContent: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: 'Marital Sataus :',
                              isContent: true,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: '',
                              isContent: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: 'DOJ :',
                              isContent: true,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: '',
                              isContent: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: 'Nationality :',
                              isContent: true,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: '',
                              isContent: true,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }



}