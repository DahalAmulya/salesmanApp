import 'package:deskgoo/routes/app_route_constants.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  TextEditingController emailController = TextEditingController();

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
        Navigator.of(context)
            .pushReplacementNamed(RouteGeneratorConstants.indexPage);
      }),
      child: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping outside TextFormFields
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: CustomColors.primaryColor,
          body: SafeArea(
            child: Center(
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
                        CustomElevatedButton(
                          onPressed: () {},
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
                            Navigator.of(context).pushReplacementNamed(
                                RouteGeneratorConstants.indexPage);
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
    );
  }
}
