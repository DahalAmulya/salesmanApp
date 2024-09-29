import 'package:deskgoo/responsive/desktop_body.dart';
import 'package:deskgoo/responsive/moblie_body.dart';
import 'package:deskgoo/responsive/responsive_layout.dart';
import 'package:deskgoo/responsive/tablet_body_landscape.dart';
import 'package:deskgoo/responsive/tablet_body_potrait.dart';
import 'package:deskgoo/routes/app_route_constants.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

class NotchedBottomNavBar extends StatefulWidget {
  const NotchedBottomNavBar({super.key});

  @override
  State<NotchedBottomNavBar> createState() => _NotchedBottomNavBarState();
}

class _NotchedBottomNavBarState extends State<NotchedBottomNavBar> {
  List screens = [
    Center(
      child: CustomText(text: 'Screen 1'),
    ),
    Center(
      child: CustomText(text: 'Screen 2'),
    ),
    Center(
      child: CustomText(text: 'Screen 3'),
    ),
  ];

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: MobileBody(),
        tabletBodyPotrait: TabletBodyPotrait(),
        tabletBodyLandscape: TabletBodyLandscape(),
        desktopBody: DesktopBody(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {},
        child: Icon(
          Icons.camera_enhance,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlueAccent,
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              // color: Colors.amber,
              width: MediaQuery.sizeOf(context).width * 0.38,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.home),
                      ),
                      CustomText(
                        text: 'Home',
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.message),
                      ),
                      CustomText(
                        text: 'Messages',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              // color: Colors.deepOrangeAccent,
              width: MediaQuery.sizeOf(context).width * 0.38,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          print('Pressed');
                          // GoRouter.of(context).pushReplacementNamed(
                          //     MyAppRouteConstants.homeNavBarRouteName);
                          Navigator.of(context)
                              .pushNamed(RouteGeneratorConstants.homePage);
                        },
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.phone),
                      ),
                      CustomText(
                        text: 'Phone',
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.settings),
                      ),
                      CustomText(
                        text: 'Settings',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
