import 'package:deskgoo/providers/auth_provider/change_password_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping outside TextFormFields
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: CustomColors.primaryWhite,
        appBar: _appBar(context),
        body: _body(context),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: CustomAppBar(
        tabName: 'Change Password',
        centerTitle: false,
        titleColor: CustomColors.primaryBlack,
        automaticallyImplyLeading: true,
        backgroundColor: CustomColors.primaryColor,
        onTapLeadingIcon: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _body(context) {
    return Consumer<ChangePasswordProvider>(
      builder: (context, changePasswordProvider, _) {
        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomContainer(
                  child: Form(
                    key: changePasswordProvider.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Old Password *',
                          isSubHeading: true,
                        ),
                        SizedBox(height: 8),
                        TextFromFieldWithPrefixSuffix(
                          controller:
                              changePasswordProvider.oldPasswordController,
                          obscure: changePasswordProvider.oldPasswordObscure,
                          onTap: () {},
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Old Password required'
                                : null;
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
                              changePasswordProvider.toggleOldPasswordObscure();
                            },
                            child: Icon(
                              changePasswordProvider.oldPasswordObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        CustomText(
                          text: 'New Password *',
                          isSubHeading: true,
                        ),
                        SizedBox(height: 8),
                        TextFromFieldWithPrefixSuffix(
                          controller:
                              changePasswordProvider.newPasswordController,
                          obscure: changePasswordProvider.newPasswordObscure,
                          onTap: () {},
                          validator: (value) {
                            return value!.isEmpty
                                ? 'New Password required'
                                : null;
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
                              changePasswordProvider.toggleNewPasswordObscure();
                            },
                            child: Icon(
                              changePasswordProvider.newPasswordObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        CustomText(
                          text: 'Confirm Password *',
                          isSubHeading: true,
                        ),
                        SizedBox(height: 8),
                        TextFromFieldWithPrefixSuffix(
                          controller: changePasswordProvider
                              .newConfirmPasswordController,
                          obscure:
                              changePasswordProvider.newConfirmPasswordObscure,
                          onTap: () {},
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Confirm Password required'
                                : null;
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
                              changePasswordProvider
                                  .toggleNewConfirmPasswordObscure();
                            },
                            child: Icon(
                              changePasswordProvider.newConfirmPasswordObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomElevatedButton(
                              onPressed: () {
                                // if(changePasswordProvider.formKey.currentState!)
                                changePasswordProvider.onSubmit();
                              },
                              backgroundColor: CustomColors.primaryColor,
                              widget: CustomText(
                                text: 'Submit',
                                isHeading: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
