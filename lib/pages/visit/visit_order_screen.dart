import 'package:deskgoo/providers/visit_provider/order_items.dart';
import 'package:deskgoo/providers/visit_provider/order_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class VisitOrderScreen extends StatelessWidget {
  const VisitOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildUI(context);
    // Scaffold(
    //   backgroundColor: CustomColors.primaryWhite,
    //   appBar: _appBar(context),
    //   drawer: _drawer(context),
    //   body: _buildUI(context),
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
    // bottomNavigationBar: _bottomNavBar(context),
    // );
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
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: 'Anu Yadav',
                  fontWeight: FontWeight.w600,
                  size: 20,
                ),
                // Divider(),
                // Wrap ListView.builder with Expanded to give it flexible space
                Expanded(
                  child:
                      Consumer<OrderProvider>(builder: (context, provider, _) {
                    print(provider.items.length);
                    return ListView.builder(
                      padding: EdgeInsets.only(bottom: 48, top: 0),
                      itemCount: provider.items.length,
                      itemBuilder: (context, index) {
                        Orders orders = provider.items[index];
                        Color cardColor = Colors.white;
                        return ListTile(
                          minVerticalPadding: 5,
                          contentPadding: EdgeInsets.all(0),
                          onLongPress: () {
                            cardColor = Colors.red;
                            print('Long Pressed');
                          },
                          titleAlignment: ListTileTitleAlignment.center,
                          title: Card(
                            shape: ShapeBorder.lerp(
                              Border.all(color: Colors.transparent),
                              Border.all(),
                              0,
                            ),
                            color: cardColor,
                            elevation: 2,
                            margin: EdgeInsets.all(0),
                            child: CustomContainer(
                              verticalMargin: 0,
                              color: cardColor,
                              verticalPad: 8,
                              horizontalPad: 0,
                              width: 1,
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.s,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomText(
                                                text: orders.productName,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              // SizedBox(
                                              //   height: 20,
                                              //   width: 20,
                                              //   child: IconButton(
                                              //     padding: EdgeInsets.all(0),
                                              //     onPressed: () {},
                                              //     icon: Center(
                                              //       child: Icon(
                                              //         Icons.delete,
                                              //         size: 20,
                                              //         color: CustomColors.lightRed,
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                              // Checkbox(
                                              //     value: false,
                                              //     onChanged: (value) {})
                                              // // _showPopupMenu(context),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Divider(
                                  //   color: CustomColors.primaryBlack,
                                  // ),
                                  IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.30,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: CustomText(
                                            text:
                                                '\$ ${orders.netAmount.toStringAsFixed(2)}',
                                            size: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          // width: MediaQuery.of(context).size.width *
                                          //     0.22,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: CustomText(
                                            text:
                                                '\$ ${(orders.totalPrice).toStringAsFixed(2)}',
                                            size: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          // width: MediaQuery.of(context).size.width *
                                          //     0.23,
                                          width: 100,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  color: Colors.grey.shade300,
                                                  child: Center(
                                                    child: IconButton(
                                                      onPressed: null,
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      icon: Icon(
                                                        Icons.remove,
                                                        size: 16,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              CustomText(
                                                text:
                                                    orders.quantity.toString(),
                                                size: 14,
                                              ),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  color:
                                                      CustomColors.primaryColor,
                                                  child: Center(
                                                    child: IconButton(
                                                      onPressed: null,
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      icon: Icon(
                                                        Icons.add,
                                                        size: 16,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                          ),
                        );
                      },
                    );
                  }),
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
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     Container(
          //       padding:
          //           const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          //       color: CustomColors.primaryColor,
          //       child: Column(
          //         children: [
          //           // Row(
          //           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           //   children: [
          //           //     CustomText(
          //           //       text: 'Payable Amount:',
          //           //       fontWeight: FontWeight.w500,
          //           //     ),
          //           //     CustomText(
          //           //       text: '0.0',
          //           //       fontWeight: FontWeight.w500,
          //           //     ),
          //           //   ],
          //           // ),
          //           // Row(
          //           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           //   children: [
          //           //     CustomText(
          //           //       text: 'Net Amount:',
          //           //       fontWeight: FontWeight.w500,
          //           //     ),
          //           //     CustomText(
          //           //       text: '0.0',
          //           //       fontWeight: FontWeight.w500,
          //           //     ),
          //           //   ],
          //           // ),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               CustomText(
          //                 text: 'Total Amount:',
          //                 fontWeight: FontWeight.w500,
          //               ),
          //               CustomText(
          //                 text: '0.00',
          //                 fontWeight: FontWeight.w500,
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  CustomGNavBar _bottomNavBar(context) {
    return CustomGNavBar(
      selectedIndex: 0,
      onTap: (value) {},
    );
  }

  PopupMenuButton _showPopupMenu(context) {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      iconSize: 16.0,
      color: Colors.white,
      padding: const EdgeInsets.all(0.0),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: CustomText(text: 'Edit'),
            onTap: () {
              debugPrint('id = ');
              debugPrint('index = ');
            },
          ),
          PopupMenuItem(
            onTap: () {
              // delete(index);
            },
            child: CustomText(text: 'Delete'),
          ),
        ];
      },
    );
  }
}
