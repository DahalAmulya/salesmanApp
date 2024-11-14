import 'dart:convert' as convert;
import 'dart:convert';

import 'package:deskgoo/providers/auth_provider/user_auth_provider.dart';
import 'package:deskgoo/providers/themes_provider/theme_changer_provider.dart';
import 'package:deskgoo/routes/app_route_constants.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
// import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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

  // Create TextEditingControllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  // void didChangeDependencies() {
  //   // Initialize UserProvider after initState
  //   super.didChangeDependencies();
  //   _userProvider = Provider.of<UserProvider>(context, listen: false);
  // }

  // Create FocusNodes
  // FocusNode emailFocusNode = FocusNode();
  // FocusNode passwordFocusNode = FocusNode();

  // @override
  // void dispose() {
  //   // Dispose of controllers and focus nodes to free up resources
  //   emailController.dispose();
  //   passwordController.dispose();
  //   emailFocusNode.dispose();
  //   passwordFocusNode.dispose();
  //   super.dispose();
  // }

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
                        onPressed: () async {
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
      'usr': emailController.value.text.isEmpty
          ? 'Monica@gmail.com '
          : emailController.value.text,
      'pwd': passwordController.value.text.isEmpty
          ? 'Monica123@'
          : passwordController.value.text,
      // user = Phoebe@gmail.com // marketingOfficer
      // pwd = Phoebe123@
      // user = Rachel@gmail.com // marketingManager
      // pwd = Rachel123@
      // user = Monica@gmail.com // marketingAsstManager
      // pwd = Monica123@
    };
    ERPResponse response = await ERPServicer.ERPlogin(body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      full_name = data['full_name'];
      employee_details = data['employee_details'];
      user_roles = data['user_roles'];
      _userProvider!.setUserDetails(
        full_name,
        employee_details,
        user_roles,
      );
      Navigator.of(context).pushNamed(MarketingManagerConstants.homePage);
    }
  }
}
