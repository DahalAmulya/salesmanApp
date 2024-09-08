import 'package:deskgoo/providers/themes/theme_changer_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: _appBar(context),
      body: _buildUI(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: Consumer<ThemeChangerProvider>(
        builder: (context, provider, _) {
          return CustomAppBar(
            tabName: '',
            backgroundColor: Colors.grey.shade200,
            showTrailingIcons: true,
            showThemeIcon: true,
            onPressedThemeIcon: () {
              provider.toogleIsChooseThemePopUp();
              print(
                  'provider.isChooseThemePopup = ${provider.isChooseThemePopup}');
              // provider.setIsChooseThemePopup(isChooseThemePopup)
            },
          );
        },
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<ThemeChangerProvider>(builder: (context, provider, _) {
                return CustomContainer(
                  color: provider.themeMode == ThemeMode.light
                      ? Colors.white
                      : CustomColors.primaryBlack,
                  width: 0.90,
                  applyShadow: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SizedBox(
                      //   height: 16.0,
                      // ),
                      Image.asset(
                        provider.themeMode == ThemeMode.light
                            ? 'assets/images/deskgooBlack.png'
                            : 'assets/images/deskgooWhite.png',
                        width: 170,
                        height: 60,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xfff3f3f3),
                          // labelText: 'Email',
                          hintText: 'jane@example.com',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: provider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xfff3f3f3),
                          focusColor: Colors.blue,
                          // labelText: 'password',
                          hintText: '••••••',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: Icon(Icons.visibility),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      CustomElevatedButton(
                        onPressed: () {},
                        width: 0.90,
                        height: 50,
                        backgroundColor: Colors.black,
                        widget: CustomText(
                          text: 'Login',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      CustomText(
                        text: 'Forgot Password?',
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        Consumer<ThemeChangerProvider>(builder: (context, provider, _) {
          return Center(
            child: provider.isChooseThemePopup
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomContainer(
                        width: 0.90,
                        applyShadow: true,
                        child: Column(
                          children: [
                            CustomText(
                              text: 'Choose Theme',
                              size: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            RadioListTile(
                              title: CustomText(text: 'Light'),
                              value: ThemeMode.light,
                              groupValue: provider.themeMode,
                              onChanged: (newValue) {
                                provider.setThemeMode(newValue);
                              },
                            ),
                            RadioListTile(
                              title: CustomText(text: 'Dark'),
                              value: ThemeMode.dark,
                              groupValue: provider.themeMode,
                              onChanged: (newValue) {
                                provider.setThemeMode(newValue);
                              },
                            ),
                            RadioListTile(
                              title: CustomText(text: 'System'),
                              value: ThemeMode.system,
                              groupValue: provider.themeMode,
                              onChanged: (newValue) {
                                provider.setThemeMode(newValue);
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomElevatedButton(
                                  onPressed: () {
                                    provider.toogleIsChooseThemePopUp();
                                  },
                                  borderColor: Color(0xffff0000),
                                  widget: CustomText(
                                    text: 'Cancel',
                                    color: Colors.red,
                                  ),
                                ),
                                CustomElevatedButton(
                                  onPressed: () {
                                    provider.toogleIsChooseThemePopUp();
                                  },
                                  borderColor: Color(0xff171717),
                                  widget: CustomText(
                                    text: 'Save',
                                    color: Color(0xff171717),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                : null,
          );
        })
      ],
    );
  }
}
