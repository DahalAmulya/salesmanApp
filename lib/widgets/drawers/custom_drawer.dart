import 'package:deskgoo/routes/app_route_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/drawers/drawers_items/custom_listTile.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    this.userImg = 'assets/images/deskgooBlack.png',
    this.userName = 'Farhan Ansari',
    this.userRole = 'Developer',
  });

  final String userImg;
  final String userName;
  final String userRole;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  left: 16.0,
                  bottom: 8.0,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: CustomColors.primaryBackgroundColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Image.asset(
                        userImg,
                      ),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: userName,
                          color: CustomColors.primaryBackgroundColor,
                          fontWeight: FontWeight.w600,
                        ),
                        CustomText(
                          text: userRole,
                          color: CustomColors.primaryBackgroundColor,
                          fontWeight: FontWeight.w400,
                          size: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: ListView(
                  children: [
                    CustomListTile(
                      onTap: () {},
                      isTabActive: true,
                      icon: FontAwesomeIcons.house,
                      text: 'Home',
                    ),
                    CustomListTile(
                      onTap: () {
                        GoRouter.of(context).pushReplacementNamed(
                            MyAppRouteConstants.remoteAttendanceRouteName);
                      },
                      isTabActive: false,
                      isIcon: false,
                      imgName: 'assets/images/biometricAttendanceWhite.png',
                      imgBoxFit: BoxFit.scaleDown,
                      imgHeigt: 32,
                      imgWidth: 32,
                      imgColor: Colors.white,
                      text: 'Attendance',
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
