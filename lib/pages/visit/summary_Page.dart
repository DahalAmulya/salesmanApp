import 'package:deskgoo/providers/themes_provider/theme_changer_provider.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import '../../themes/custom_colors.dart';
import '../../widgets/buttons/elevated_button.dart';

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

  visitSummary({
    super.key,
    this.name = 'Farhan',
    this.itemName = 'HEADPHONES HD001',
    this.quantity,
    this.perQuantityPrice,
    this.totalPrice,
    this.subTotalPrice,
    this.schemeDiscountPrice,
    this.discountPrice,
    this.netPrice,
    this.paymentMethod = 'Cash',
    this.billNo,
    this.receivedAmount,
    this.followUp = 'paid',
  });

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.red,
    exportBackgroundColor: Colors.lightBlue,
  );

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
      child: Center(
        child: CustomContainer(
          verticalPad: 0,
          horizontalPad: 0,
          verticalMargin: 24,
          // horizontalMargin: 24,
          child: Column(
            children: [
              SizedBox(
                height: 8.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                // color: CustomColors.primaryWhite,
                child: Center(
                  child: CustomText(
                    text: name!,
                    fontWeight: FontWeight.w600,
                    size: 20,
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      color: CustomColors.primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child: CustomText(
                          text: 'Order',
                          fontWeight: FontWeight.w600,
                          size: 18,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8.0),
                              width: MediaQuery.of(context).size.width * 1,
                              color: Colors.grey.shade400,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: itemName!,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        text: quantity.toString(),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      CustomText(
                                        text: perQuantityPrice.toString(),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      CustomText(
                                        text: totalPrice.toString(),
                                        fontWeight: FontWeight.w600,
                                      ),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: 'Sub Total:',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  CustomText(
                                    text: subTotalPrice.toString(),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: 'Scheme Discount:',
                                    fontWeight: FontWeight.w600,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: 'Discount:',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  CustomText(
                                    text: discountPrice.toString(),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: 'Total Amount:',
                                    fontWeight: FontWeight.w600,
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
                      width: MediaQuery.of(context).size.width * 1,
                      color: CustomColors.primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child: CustomText(
                          text: 'Payment',
                          fontWeight: FontWeight.w600,
                          size: 18,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      color: Color(0xfffFAFAFA),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            child: CustomText(
                              text: paymentMethod!,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          CustomContainer(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: billNo.toString(),
                                  fontWeight: FontWeight.w600,
                                ),
                                CustomText(
                                  text: receivedAmount.toString(),
                                  fontWeight: FontWeight.w600,
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
                      color: CustomColors.primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child: CustomText(
                          text: 'Followup',
                          fontWeight: FontWeight.w600,
                          size: 18,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child: CustomText(
                          text: followUp!,
                          fontWeight: FontWeight.w600,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                color: CustomColors.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Signature',
                        fontWeight: FontWeight.w600,
                        size: 18,
                      ),
                      InkWell(
                        onTap: () {
                          _controller.clear();
                        },
                        child: Icon(FontAwesomeIcons.rotateRight),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 1,
                child: Signature(
                  controller: _controller,
                  backgroundColor: Colors.grey.shade300,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomElevatedButton(
                    onPressed: () {},
                    height: MediaQuery.of(context).size.height * 0.060,
                    backgroundColor: CustomColors.primaryColor,
                    widget: CustomText(
                      text: 'Submit',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  CustomGNavBar _bottomNavBar(context) {
    return CustomGNavBar(
      onTap: (value) {},
      selectedIndex: 3,
    );
  }
}
