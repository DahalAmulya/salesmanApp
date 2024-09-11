import 'package:deskgoo/providers/themes_provider/theme_changer_provider.dart';
import 'package:deskgoo/routes/app_route_constants.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../themes/custom_colors.dart';

class visitSummary extends StatelessWidget {
  final String? name;
  final String? itemName;
  final int? quantity;
  final int? perQuantityPrice;
  final int? totalPrice;
  final int? subTotalPrice;
  final int? schemeDiscountPrice;
  final int? discountPrice;
  final int? netPrice;
  final String? paymentMethod;
  final int? billNo;
  final int? receivedAmount;
  final String? followUp;


  const visitSummary({
    super.key,
    this.name = 'farhan',
    this.itemName = '',
    this.quantity ,
    this.perQuantityPrice,
    this.totalPrice,
    this.subTotalPrice,
    this.schemeDiscountPrice,
    this.discountPrice,
    this.netPrice,
    this.paymentMethod = '',
    this.billNo,
    this.receivedAmount,
    this.followUp = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(context),
      drawer: _customDrawer(context),
      body: _buildUI(context),
      bottomNavigationBar: _bottomNavBar(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: Consumer<ThemeChangerProvider>(
        builder: (context, provider, _) {
          return Builder(builder: (context) {
            return CustomAppBar(
              tabName: 'Visit Summary',
              showLeading: true,
              leadingIcon: FontAwesomeIcons.bars,
              applyShadow: true,
              onTapLeadingIcon: () {
                Scaffold.of(context).openDrawer();
              },
              onPressedThemeIcon: () {
                provider.toogleIsChooseThemePopUp();
              },
            );
          });
        },
      ),
    );
  }

  CustomDrawer _customDrawer(context) {
    return CustomDrawer(
      isHomeActive: true,
    );
  }

  Widget _buildUI(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 8.0,),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 1,
            // height: MediaQuery.of(context).size.height * 0.040,
            color: CustomColors.primaryWhite,
            child: Center(
              child: CustomText(
                text: name!,
                fontWeight: FontWeight.bold,
                size: 17,
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 1,
                  // height: MediaQuery.of(context).size.height * 0.050,
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 1,
                  // height: MediaQuery.of(context).size.height * 0.19,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 1,
                          // height: MediaQuery.of(context).size.height * 0.055,
                          color: Colors.grey.shade400,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: itemName!,
                                fontWeight: FontWeight.bold,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  CustomText(text: quantity.toString()),
                                  CustomText(text: perQuantityPrice.toString()),
                                  CustomText(text: totalPrice.toString()),
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
                                text: subTotalPrice.toString(),
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
                                text: schemeDiscountPrice.toString(),
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
                                text: discountPrice.toString(),
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
                                text: netPrice.toString(),
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 1,
                  // height: MediaQuery.of(context).size.height * 0.040,
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 1,
                  // height: MediaQuery.of(context).size.height * 0.11,
                  color: Color(0xfffFAFAFA),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: CustomText(
                          text: paymentMethod!,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomContainer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: billNo.toString(),
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText(
                              text: receivedAmount.toString(),
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 1,
                  // height: MediaQuery.of(context).size.height * 0.050,
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 1,
                  // height: MediaQuery.of(context).size.height * 0.05,
                  color: Colors.white,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    child: CustomText(
                      text: followUp!,
                      fontWeight: FontWeight.bold,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 1,
            // height: MediaQuery.of(context).size.height * 0.050,
            color: Colors.lightBlue.shade200,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 8.0),
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
      ),
    );
  }

  CustomGNavBar _bottomNavBar(context) {
    return CustomGNavBar(onTap: (value) {},
      selectedIndex: 3,
    );
  }
}