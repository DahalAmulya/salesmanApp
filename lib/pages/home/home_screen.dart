import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  int index = 0;
  bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              elevation: 10,
              title: CustomText(
                text: 'Exit',
                fontWeight: FontWeight.bold,
                size: 24.0,
                color: Colors.red,
              ),
              content: CustomText(
                text: 'Are you sure you want to exit ?',
                fontWeight: FontWeight.w500,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      // backgroundColor: Colors.green,
                      borderColor: CustomColors.primaryColor,
                      widget: CustomText(
                        text: 'No',
                        fontWeight: FontWeight.w500,
                        color: CustomColors.primaryColor,
                      ),
                    ),
                    CustomElevatedButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      // backgroundColor: Colors.red,
                      borderColor: Colors.red,
                      widget: CustomText(
                        text: 'Yes',
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
      child: Scaffold(
        backgroundColor: CustomColors.primaryWhite,
        appBar: _appBar(context),
        drawer: _drawer(context),
        // drawerDragStartBehavior: DragStartBehavior.start,
        body: _buildUI(context),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: CustomColors.primaryColor,
              onPressed: () async {
                if (!_isAuthenticated) {
                  final bool canAuthenticateWithBiometrics =
                      await auth.canCheckBiometrics;
                  if (canAuthenticateWithBiometrics) {
                    try {
                      print(canAuthenticateWithBiometrics);
                      final bool didAuthenticate = await auth.authenticate(
                        localizedReason: 'Please authenticate for attendance',
                        options: const AuthenticationOptions(
                          biometricOnly: false,
                        ),
                      );
                      setState(() {
                        _isAuthenticated = didAuthenticate;
                      });
                    } catch (err) {
                      print('err = $err');
                    }
                  }
                } else {
                  setState(() {
                    _isAuthenticated = false;
                  });
                }
              },
              child: FaIcon(
                _isAuthenticated
                    ? FontAwesomeIcons.unlock
                    : FontAwesomeIcons.lock,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            FloatingActionButton(
              backgroundColor: CustomColors.primaryColor,
              onPressed: () {
                print('Pressed camera');
              },
              child: FaIcon(FontAwesomeIcons.camera),
            ),
          ],
        ),
        bottomNavigationBar: _bottomNavBar(context),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) => CustomAppBar(
          tabName: 'Home',
          titleColor: CustomColors.primaryBlack,
          backgroundColor: CustomColors.primaryColor,
          showLeading: true,
          leadingIcon: FontAwesomeIcons.bars,
          leadingIconColor: CustomColors.primaryBlack,
          onTapLeadingIcon: () {
            // Use the context under the Scaffold
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
    );
  }

  // PreferredSize _appBar(context) {
  CustomDrawer _drawer(context) {
    return CustomDrawer(
      isHomeActive: true,
    );
  }

  Widget _buildUI(context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.all(6),
      child: Center(
        child: CustomText(
          text: _isAuthenticated ? 'Comming soon' : '********',
          fontWeight: FontWeight.w500,
          size: 20,
        ),
      ),
    );
  }

  CustomGNavBar _bottomNavBar(context) {
    return CustomGNavBar(
      selectedIndex: index,
      onTap: (value) {
        index = value;
        print(index);
      },
    );
  }
}
