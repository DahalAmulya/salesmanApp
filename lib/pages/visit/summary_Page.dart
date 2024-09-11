import 'package:deskgoo/providers/themes_provider/theme_changer_provider.dart';
import 'package:deskgoo/routes/app_route_constants.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../themes/custom_colors.dart';

class visitSummary extends StatefulWidget {
  const visitSummary({super.key});

  @override
  State<visitSummary> createState() => _visitSummaryState();
}

class _visitSummaryState extends State<visitSummary> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryColor,
      appBar: _appBar(context),
      body: _buildUI(context),
    );
  }
}

PreferredSize _appBar(context) {
  return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: Consumer<ThemeChangerProvider>(builder: (context, provider, _) {
        return CustomAppBar(
          tabName: 'Visit Summary',
          showLeading: true,
          leadingIcon: Icons.arrow_back,
          backgroundColor: Colors.grey.shade100,
          applyShadow: true,
          onTapLeadingIcon: () {
            GoRouter.of(context)
                .pushReplacementNamed(MyAppRouteConstants.homeNavBarRouteName);
          },
          onPressedThemeIcon: () {
            provider.toogleIsChooseThemePopUp();
          },
        );
      }));
}

Widget _buildUI(context) {
  return Column(
    children: [
      Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 0.040,
        color: Colors.grey.shade300,
        child: Center(
          child: CustomText(
            text: 'ANISH YADAV',
            fontWeight: FontWeight.bold,
            size: 17,
          ),
        ),
      ),
      Container(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.050,
              color: Colors.lightBlue.shade200,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: CustomText(
                  text: 'Order',
                  fontWeight: FontWeight.bold,
                  size: 18,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.19,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.055,
                      color: Colors.grey.shade400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'HEADPHONE HD001',
                            fontWeight: FontWeight.bold,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(text: '1'),
                              CustomText(text: '1,349.10'),
                              CustomText(text: '1,349.10'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Sub Total:',
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            text: '1,349.10',
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Scheme Discount:',
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            text: '0.00',
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Discount:',
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            text: '0.0',
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Total Amount:',
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            text: '1,349.10',
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.040,
              color: Colors.lightBlue.shade200,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: CustomText(
                  text: 'Payment',
                  fontWeight: FontWeight.bold,
                  size: 18,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.11,
              color: Color(0xfffFAFAFA),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: CustomText(
                      text: 'Cash',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: '51617',
                          fontWeight: FontWeight.bold,
                        ),
                        CustomText(
                          text: '1,300.00',
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.050,
              color: Colors.lightBlue.shade200,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: CustomText(
                  text: 'Followup',
                  fontWeight: FontWeight.bold,
                  size: 18,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.05,
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: CustomText(
                  text: 'paid',
                  fontWeight: FontWeight.bold,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 0.050,
        color: Colors.lightBlue.shade200,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Row(
            children: [
              CustomText(
                text: 'Signature',
                fontWeight: FontWeight.bold,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
