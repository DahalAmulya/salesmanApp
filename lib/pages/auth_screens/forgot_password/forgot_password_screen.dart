import 'dart:convert';

import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/toast_message.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPassController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  void togglePasswordVisibility() {
    // This function can be used to toggle password visibility if needed
    setState(() {
      obscurePassword = !obscurePassword;
      print(obscurePassword);
    });
  }

  void toggleConfirmPasswordVisibility() {
    // This function can be used to toggle password visibility if needed
    setState(() {
      obscureConfirmPassword = !obscureConfirmPassword;
      print(obscureConfirmPassword);
    });
  }

  void forgotPassword(context) async {
    try{
      showDialog(context: context, builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: CustomColors.primaryColor,),
        );
      });
      final body =
        {"email": emailController.value.text.toLowerCase().trim(), "password":passwordController.value.text.trim(), "confirmPassword": confirmPassController.value.text.trim()};

      ERPResponse response = await ERPServices.postRequest('/auth/forgot', body, context);
      final decodedBody = jsonDecode(response.body);
      if(response.statusCode == 200){
        ToastMessageUtils().showToastMessage(
            decodedBody['message'], ToastGravity.TOP, CustomColors.jadeGreen);
        Navigator.pop(context);
        Navigator.of(context).pushReplacementNamed(MarketingManagerConstants.indexPage);
      }else{
        ToastMessageUtils().showToastMessage(
            decodedBody['message'], ToastGravity.TOP, CustomColors.lightRed);
        Navigator.pop(context);
      }
      print(response.body);
    }catch(e){
      print('Error in forgotPassword: $e');
      ToastMessageUtils().showToastMessage(
          jsonDecode(e.toString())['message'], ToastGravity.TOP);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        // GoRouter.of(context)
        //     .pushReplacementNamed(MyAppRouteConstants.loginRouteName);
        Navigator.of(context).pushNamed(MarketingManagerConstants.indexPage);
      }),
      child: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping outside TextFormFields
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: CustomColors.primaryColor,
          body: SafeArea(
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomContainer(
                      width: 0.90,
                      applyShadow: true,
                      color: Colors.white,
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
                            height: 16.0,
                          ),
                          TextFromFieldWithPrefixSuffix(
                            keyboardType: TextInputType.emailAddress,
                            autoFocus: false,
                            controller: emailController,
                            onTap: () {},
                            validator: (value) {
                              String pattern =
                                  r'^[a-zA-Z]{3,}(?:\.[a-zA-Z]{2,})?@[a-zA-Z]{2,}\.[a-zA-Z]{2,}$';
                              RegExp regex = RegExp(pattern);

                              return value!.isEmpty
                                  ? 'email is required'
                                  : !regex.hasMatch(value)
                                      ? 'Invalid email'
                                      : null;
                            },
                            onChange: (value) {},
                            hintText: 'Email Address',
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.grey.shade600,
                            ),
                            applySuffixIcon: false,
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFromFieldWithPrefixSuffix(
                            // keyboardType: TextInputType.,
                            autoFocus: false,
                            controller: passwordController,
                            onTap: () {},
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'Password is required'
                                  : value.length < 8
                                      ? 'Password must be 8 character long'
                                      : null;
                            },
                            onChange: (value) {},
                            hintText: 'Password',
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.grey.shade600,
                            ),
                            applySuffixIcon: true,
                            obscure: obscurePassword,
                            suffixIcon: InkWell(
                              onTap: () {
                                togglePasswordVisibility();
                              },
                              child: Icon(
                                obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),TextFromFieldWithPrefixSuffix(
                            keyboardType: TextInputType.emailAddress,
                            autoFocus: false,
                            controller: confirmPassController,
                            onTap: () {},
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'ConfirmPassword is required'
                                  : value.trim() != passwordController.text.trim()
                                      ? 'Password and confirm password not matched'
                                      : null;
                            },
                            onChange: (value) {},
                            hintText: 'Confirm Password',
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.grey.shade600,
                            ),
                            applySuffixIcon: true,
                            obscure: obscureConfirmPassword,
                            suffixIcon: InkWell(
                              onTap: () {
                                toggleConfirmPasswordVisibility();
                              },
                              child: Icon(
                                obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          CustomElevatedButton(
                            onPressed: () {
                              if(formKey.currentState != null && formKey.currentState!.validate()) {
                                forgotPassword(context);
                                print('Form is valid');
                              }else{
                                print('Form is invalid');
                              }
                            },
                            width: 0.90,
                            height: 50,
                            backgroundColor: CustomColors.primaryColor,
                            widget: CustomText(
                              text: 'Reset Password',
                              fontWeight: FontWeight.w600,
                              color: CustomColors.primaryBlack,
                              size: 20.0,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          CustomElevatedButton(
                            onPressed: () {
                              // GoRouter.of(context).pushReplacementNamed(
                              //     MyAppRouteConstants.loginRouteName);
                              Navigator.of(context)
                                  .pushNamed(MarketingManagerConstants.indexPage);
                            },
                            widget: CustomText(
                              text: 'Back to Login',
                              fontWeight: FontWeight.w600,
                              color: CustomColors.primaryBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
