import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';

import '../../../routes/route_generator_constants.dart';
import '../../../themes/custom_colors.dart';
import '../../../widgets/app_bars/custom_app_bars.dart';
import '../../../widgets/buttons/elevated_button.dart';
import '../../../widgets/texts/custom_text.dart';

class TermsAndConditionScreen extends StatelessWidget {
  const TermsAndConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(context),
      body: _body(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) {
          return CustomAppBar(
            tabName: 'Terms & Conditions',
            leadingIcon: FontAwesomeIcons.arrowLeft,
            titleColor: CustomColors.primaryBlack,
            backgroundColor: CustomColors.primaryColor,
            showLeading: true,
            onTapLeadingIcon: () {
              Navigator.of(context)
                  .popAndPushNamed(MarketingManagerConstants.settingPage);
            },
          );
        },
      ),
    );
  }

  Widget _body(context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: FutureBuilder(
                future: Future.delayed(const Duration(milliseconds: 150))
                    .then((value) {
                  return rootBundle.loadString('assets/terms_and_conditions.md');
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
          CustomElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            width: 1,
            borderRadius: 0,
            backgroundColor: Colors.grey.shade300,
            widget: CustomText(
              text: 'Close',
              isSubHeading: true,
            ),
          ),
        ],
      ),
    );
  }
}
