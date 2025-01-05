import 'dart:convert';

import 'package:deskgoo/consts.dart';
import 'package:deskgoo/pages/auth_screens/change_passowrd/change_password_screen.dart';
import 'package:deskgoo/providers/auth_provider/user_auth_provider.dart';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/login_provider/login_provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserProvider? _userProvider;

  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> apiData = [];
  var data;
  String full_name = '';
  Map<String, dynamic> employee_details = {};
  List<dynamic> user_roles = [];

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping outside TextFormFields
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: CustomColors.primaryColor,
        body: _buildUI(context),
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    print('body build');
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomContainer(
              color: Colors.white,
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
                      'assets/images/deskgooBlack.png',
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    // Use the TextFromFieldWithPrefixSuffix widget with emailFocusNode
                    TextFromFieldWithPrefixSuffix(
                      // focusNode: emailFocusNode, // Pass the FocusNode here
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      autoFocus: true, // Disable autoFocus for manual control
                      onTap: () {
                        // emailFocusNode
                        //     .requestFocus(); // Manually request focus when tapped
                      },
                      validator: (value) {
                        String pattern =
                            r'^[a-zA-Z]{3,}(?:\.[a-zA-Z]{2,})?@[a-zA-Z]{2,}\.[a-zA-Z]{2,}$';
                        RegExp regex = RegExp(pattern);
                        return value!.isEmpty
                            ? 'Email required'
                            // : !regex.hasMatch(value)
                            //     ? 'Invalid email'
                            : null;
                      },
                      onChange: (value) {},
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
                    // Use TextFromFieldWithPrefixSuffix for password with passwordFocusNode
                    Consumer<UserAuthProvider>(
                      builder: (context, authProvider, _) {
                        return TextFromFieldWithPrefixSuffix(
                          // focusNode:
                          //     passwordFocusNode, // Pass the FocusNode here
                          controller: passwordController,
                          obscure: authProvider.obscure,
                          onTap: () {
                            // passwordFocusNode
                            //     .requestFocus(); // Manually request focus when tapped
                          },
                          validator: (value) {
                            return value!.isEmpty ? 'Password required' : null;
                          },
                          onChange: (value) {},
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
                    Consumer<UserProvider>(builder: (context, userProvider, _) {
                      return CustomElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // login api call logic
                            login();
                            print('Form is valid');
                          } else {
                            login();
                            print('Form is not valid');
                          }
                        },
                        width: 0.90,
                        height: 50,
                        backgroundColor: CustomColors.primaryColor,
                        widget: CustomText(
                          text: 'Login',
                          fontWeight: FontWeight.w600,
                          color: CustomColors.primaryBlack,
                          size: 20.0,
                        ),
                      );
                    }),
                    SizedBox(height: 8.0),
                    CustomElevatedButton(
                      onPressed: () {
                        print('Pressed');
                        Navigator.of(context)
                            .pushNamed(MarketingManagerConstants.forgotPage);
                      },
                      widget: CustomText(
                        text: 'Forgot Password?',
                        fontWeight: FontWeight.w600,
                        color: CustomColors.primaryBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login() async {
    Map<String, dynamic> body = {
      'email': emailController.value.text.isEmpty
          ? 'farhan@example.com'
          : emailController.value.text,
      'password': passwordController.value.text.isEmpty
          ? 'farhan@123'
          : passwordController.value.text,
      // admin@example.com
      // admin@123
      // farhan@example.com
      // farhan@123
    };
    ERPResponse response = await ERPServicer.ERPlogin(body);
    if (response.statusCode == 200) {
      print(response.statusCode);
      final data = jsonDecode(response.body);
      accessToken = data['accessToken'];
      refreshToken = data['refreshToken'];
      userId = data['user']['userId'];
      isFirstLogin = data['user']['firstLogin'];
      isResetMobile = data['user']['resetMobile'];
      role = data['user']['role'];
      print(data);
      if (isFirstLogin || isResetMobile) {
        print('$isFirstLogin, $isResetMobile');
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
      } else {
        if (role == 'admin') {
          Navigator.of(context).pushNamed(MarketingManagerConstants.homePage);
          print('Administrator');
        } else {
          Navigator.of(context)
              .pushNamed(MarketingOfficerConstants.mrStaffDashboardConst);
          print('Marketing Officer');
        }
      }
    }
  }
}
