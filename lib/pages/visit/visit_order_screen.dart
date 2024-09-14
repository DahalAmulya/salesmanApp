import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VisitOrderScreen extends StatelessWidget {
  const VisitOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(context),
      drawer: _drawer(context),
      body: _buildUI(context),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   child: FaIcon(
      //     FontAwesomeIcons.plus,
      //     size: 32,
      //     color: CustomColors.primaryColor,
      //   ),
      // ),
      bottomNavigationBar: _bottomNavBar(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) {
          return CustomAppBar(
            tabName: 'Visit Client',
            showLeading: true,
            leadingIcon: FontAwesomeIcons.bars,
            onTapLeadingIcon: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    );
  }

  CustomDrawer _drawer(context) {
    return CustomDrawer(
      isVisitActive: true,
    );
  }

  Widget _buildUI(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // CustomText(
              //   text: 'Anu Yadav',
              //   fontWeight: FontWeight.w600,
              //   size: 20,
              // ),
              // Divider(),
              // Wrap ListView.builder with Expanded to give it flexible space
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    Color cardColor =
                        index.isEven ? Colors.white : CustomColors.primaryColor;
                    return ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Card(
                        color: cardColor,
                        elevation: 2,
                        margin: EdgeInsets.all(0),
                        child: CustomContainer(
                          color: Colors.transparent,
                          verticalPad: 8,
                          horizontalPad: 0,
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.s,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: CustomText(
                                        text: 'Macbook pro M3 pro',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: CustomColors.primaryBlack,
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        children: [
                                          CustomText(text: 'Quantity'),
                                          CustomText(text: '1'),
                                        ],
                                      ),
                                    ),
                                    // VerticalDivider(
                                    //   color: CustomColors.primaryBlack,
                                    // ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        children: [
                                          CustomText(text: 'Price'),
                                          CustomText(text: '0.0'),
                                        ],
                                      ),
                                    ),
                                    // VerticalDivider(
                                    //   // indent: 5,
                                    //   color: CustomColors.primaryBlack,
                                    // ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        children: [
                                          CustomText(text: 'Total'),
                                          CustomText(text: '410000.0'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Divider(),
              // CustomElevatedButton(
              //   onPressed: () {},
              //   height: 10,
              //   widget: FaIcon(
              //     FontAwesomeIcons.plus,
              //     size: 32,
              //     color: CustomColors.primaryColor,
              //   ),
              // ),
            ],
          ),
        ),
        Column(
          children: [
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Payable Amount:',
                        fontWeight: FontWeight.w500,
                      ),
                      CustomText(
                        text: '0.0',
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Discount:',
                        fontWeight: FontWeight.w500,
                      ),
                      CustomText(
                        text: '0.0',
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Total Amount:',
                        fontWeight: FontWeight.w500,
                      ),
                      CustomText(
                        text: '0.0',
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  CustomGNavBar _bottomNavBar(context) {
    return CustomGNavBar(
      selectedIndex: 0,
      onTap: (value) {},
    );
  }
}
