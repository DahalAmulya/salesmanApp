import 'package:animations/animations.dart';
import 'package:deskgoo/utils/policy_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'By creating an account, you are agreeing to our\n',
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                  text: 'Terms & Conditions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // OpenDialog to show terms and conditions
                      showModal(context: context, configuration: FadeScaleTransitionConfiguration(), builder: (context){
                        return PolicyDialog(
                          mdFileName: 'terms_and_conditions.md',
                        );
                      });
                    }),
              TextSpan(text: ' and '),
              TextSpan(
                  text: 'Privacy Policy!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    showModal(context: context, configuration: FadeScaleTransitionConfiguration(), builder: (context){
                      return PolicyDialog(
                        mdFileName: 'privacy_policy.md',
                      );
                    });
                  }),
            ]),
      ),
    );
  }
}
