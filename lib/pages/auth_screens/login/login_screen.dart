import 'package:deskgoo/providers/auth_provider/user_auth_provider.dart';
import 'package:deskgoo/providers/themes_provider/theme_changer_provider.dart';
import 'package:deskgoo/routes/app_route_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      backgroundColor: CustomColors.primaryBackgroundColor,
      // appBar: _appBar(context),
      body: _buildUI(context),
    );
  }

  PreferredSize _appBar(context) {
    print('appbar build');
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: Consumer<ThemeChangerProvider>(
        builder: (context, provider, _) {
          print('CustomAppBar build');
          return CustomAppBar(
            tabName: '',
            backgroundColor: Colors.grey.shade100,
            showTrailingIcons: true,
            showThemeIcon: true,
            onPressedThemeIcon: () {
              provider.toogleIsChooseThemePopUp();
            },
          );
        },
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    print('body build');
    return SafeArea(
      child: Stack(
        children: [
          // _appBar(context),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<ThemeChangerProvider>(builder: (context, provider, _) {
                  print('CustomContainer build');
                  return CustomContainer(
                    color: provider.isDarkMode
                        ? CustomColors.primaryBlack
                        : Colors.white,
                    width: 0.90,
                    applyShadow: true,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            width: 170,
                            height: 60,
                            provider.isDarkMode
                                ? 'assets/images/deskgooWhite.png'
                                : 'assets/images/deskgooBlack.png',
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          TextFromFieldWithPrefixSuffix(
                            keyboardType: TextInputType.emailAddress,
                            autoFocus: true,
                            controller: emailController,
                            validator: (value) {
                              String pattern =
                                  r'^[a-zA-Z]{3,}(?:\.[a-zA-Z]{2,})?@[a-zA-Z]{2,}\.[a-zA-Z]{2,}$';
                              RegExp regex = RegExp(pattern);

                              return value!.isEmpty
                                  ? 'Email required'
                                  : !regex.hasMatch(value)
                                      ? 'Invalid email'
                                      : null;
                            },
                            hintText: 'jane@example.com',
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.grey.shade600,
                            ),
                            applySuffixIcon: false,
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Consumer<UserAuthProvider>(
                            builder: (context, authProvider, _) {
                              return TextFromFieldWithPrefixSuffix(
                                controller: passwordController,
                                obscure: authProvider.obscure,
                                validator: (value) {
                                  // String pattern =
                                  //     r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}$';
                                  // RegExp regex = RegExp(pattern);
                                  return value!.isEmpty
                                      ? 'Password required'
                                      : null;
                                },
                                hintText: '••••••',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.grey.shade600,
                                ),
                                applySuffixIcon: true,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    authProvider.toggleObscure();
                                  },
                                  child: Icon(
                                    authProvider.obscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Consumer<ThemeChangerProvider>(
                              builder: (context, provider, _) {
                            return CustomElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  print('Form is valid');
                                } else {
                                  print('Form is not valid');
                                  GoRouter.of(context).pushReplacementNamed(
                                      MyAppRouteConstants.homeNavBarRouteName);
                                }
                              },
                              width: 0.90,
                              height: 50,
                              backgroundColor: provider.isDarkMode
                                  ? Colors.white
                                  : CustomColors.primaryBlack,
                              widget: CustomText(
                                text: 'Login',
                                fontWeight: FontWeight.w600,
                                color: !provider.isDarkMode
                                    ? Colors.white
                                    : CustomColors.primaryBlack,
                                size: 20.0,
                              ),
                            );
                          }),
                          SizedBox(height: 8.0),
                          CustomElevatedButton(
                            onPressed: () {
                              print('Pressed');
                              GoRouter.of(context).pushReplacementNamed(
                                  MyAppRouteConstants.forgotPasswordRouteName);
                            },
                            widget: CustomText(
                              text: 'Forgot Password?',
                              fontWeight: FontWeight.w500,
                              color: provider.isDarkMode
                                  ? Colors.white
                                  : CustomColors.primaryBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Consumer<ThemeChangerProvider>(
            builder: (context, provider, _) {
              print('Theme option build');
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
            },
          ),
        ],
      ),
    );
  }
}
