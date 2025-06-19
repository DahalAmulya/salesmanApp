import 'package:deskgoo/providers/auth_provider/user_auth_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:provider/provider.dart';

class PolicyDialog extends StatelessWidget {
  PolicyDialog({
    super.key,
    this.radius = 8,
    required this.mdFileName,
  }) : assert(mdFileName.contains('.md'),
            'The file must contain the .md extension');

  final double radius;
  final String mdFileName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: Future.delayed(const Duration(milliseconds: 150))
                    .then((value) {
                  return rootBundle.loadString('assets/$mdFileName');
                }),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Markdown(data: snapshot.data!);
                  } else {
                    return Center(
                        child: CircularProgressIndicator(
                      color: CustomColors.primaryColor,
                    ));
                  }
                }),
          ),
          Consumer<UserAuthProvider>(
            builder: (context, userAuthProvider, _) {
              return Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        activeColor: Colors.red,
                          value: mdFileName == 'terms_and_conditions.md' ? userAuthProvider.isAgreedTermsAndConditions : userAuthProvider.isAgreedPrivacyPolicy,
                          onChanged: (value){
                            mdFileName == 'terms_and_conditions.md'
                              ? userAuthProvider.toggleTermsAndConditions(value!)
                              : userAuthProvider.togglePrivacyPolicy(value!);
                      }),
                      CustomText(text: mdFileName == 'terms_and_conditions.md' ? 'I agree to the Terms and Conditions' : 'I agree to the Privacy Policy', isContent: true, color: Colors.red,),
                    ],
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    width: 1,
                    borderRadius: 0,
                    backgroundColor: Colors.red,
                    widget: CustomText(text: 'Agree', color: Colors.white,isSubHeading: true,),
                  ),
                ],
              );
            }
          ),
        ],
      ),
    );
  }
}
