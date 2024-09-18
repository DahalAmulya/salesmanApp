import 'dart:async';

import 'package:deskgoo/pages/visit/summary_Page.dart';
import 'package:deskgoo/pages/visit/visit_order_screen.dart';
import 'package:deskgoo/providers/visit_provider/order_items.dart';
import 'package:deskgoo/providers/visit_provider/order_provider.dart';
import 'package:deskgoo/providers/visit_provider/visit_screen_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:provider/provider.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'colltectionSummary_bottomSheet.dart';

class VisitScreen extends StatefulWidget {
  VisitScreen({super.key});

  @override
  State<VisitScreen> createState() => _VisitScreenState();
}

class _VisitScreenState extends State<VisitScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  NepaliDateTime nepaliDateTime = NepaliDateTime.now();
  NepaliDateFormat nepaliDateFormatter = NepaliDateFormat('yyyy-MM-ddThh:mm');
  String formatedDateTime = '';
  final String name = 'Shuvam';

  List<Map<String, dynamic>> searchResult = [];
  List<String> items = [
    'History',
    'New Visit',
    'Order',
    'Collection',
    'Follow Up',
    'Summary',
  ];

  List<IconData> icons = [
    FontAwesomeIcons.hourglassHalf,
    FontAwesomeIcons.userPlus,
    FontAwesomeIcons.cartPlus,
    FontAwesomeIcons.moneyBillWave,
    FontAwesomeIcons.arrowRightArrowLeft,
    FontAwesomeIcons.noteSticky,
  ];
  int currentIndex = 0;

  @override
  void initState() {
    // searchResult = visitStats;

    // Initialize the animation controller
    formatedDateTime = nepaliDateFormatter.format(nepaliDateTime);
    _controller = AnimationController(
      duration:
          const Duration(milliseconds: 1250), // Animation duration of 1 second
      vsync: this,
    );

    // Define the bounce animation using CurvedAnimation
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Smooth transition up and down
    );

    // Start the animation with a periodic timer
    Timer.periodic(const Duration(seconds: 7), (timer) {
      _controller.forward().then((_) => _controller.reverse());
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      // backgroundColor: Colors.amberAccent,
      appBar: _appBar(context),
      drawer: CustomDrawer(
        isVisitActive: true,
      ),
      body: _buildUI(context),
      floatingActionButton:
          currentIndex == 1 || currentIndex == 2 || currentIndex == 3
              ? AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -_animation.value * 50),
                      child: Transform.scale(
                        scale: 1 + (_animation.value * 0.20),
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: CustomColors.primaryColor,
                          foregroundColor: CustomColors.primaryBlack,
                          onPressed: () {
                            if (currentIndex == 1) {
                              print('Current index = $currentIndex 1');
                              _newVisitshowBottomSheet(context);
                            } else if (currentIndex == 2) {
                              print('Current index = $currentIndex 2');
                              openCreateOrderDialog(context);
                            } else if (currentIndex == 3) {
                              showModalBottomSheet(
                                isScrollControlled: false,
                                useSafeArea: true,
                                context: context,
                                builder: (builder) =>
                                    CollectionsummaryBottomsheet(),
                              );
                            }
                          },
                          child: Icon(
                            Icons.add,
                            size: 28 + (_animation.value * 5),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : null,
      // bottomNavigationBar: CustomGNavBar(
      //   onTap: (value) {},
      //   selectedIndex: 0,
      // ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(builder: (context) {
        return CustomAppBar(
          tabName: 'Visit',
          showLeading: true,
          leadingIcon: FontAwesomeIcons.bars,
          onTapLeadingIcon: () {
            Scaffold.of(context).openDrawer();
          },
        );
      }),
    );
  }

  Widget _buildUI(context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: items.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (currentIndex == 1 && currentIndex != index) {
                            if (_newVisitFormKey.currentState!.validate()) {
                              currentIndex = index;
                            } else {
                              currentIndex = 1;
                              print(
                                  '_newVisitFormKey valid = ${_newVisitFormKey.currentState!.validate()}');
                            }
                          } else if (currentIndex == 4 &&
                              currentIndex != index) {
                            if (_followUpFormKey.currentState!.validate()) {
                              print('Form valid');
                              currentIndex = index;
                            } else {
                              print(
                                  '_newVisitFormKey = ${!_followUpFormKey.currentState!.validate()}');
                              currentIndex = 4;
                            }
                            print(
                                '_followUpFormKey valid = $isFollowUpFormValid');
                          } else {
                            currentIndex = index;
                            print('current index: $currentIndex');
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.all(4),
                        width: 120,
                        height: 40,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? CustomColors.primaryColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          // border: Border.all(
                          //     color: currentIndex == index
                          //         ? Colors.black
                          //         : Colors.transparent),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FaIcon(
                                icons[index],
                                size: 14,
                                color: currentIndex == index
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                              CustomText(
                                text: '${items[index]}',
                                fontWeight: FontWeight.w500,
                                color: currentIndex == index
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          currentIndex == 0
              ? _visitHistoryTab(context)
              : currentIndex == 1
                  ? _newVisitTab(context)
                  : currentIndex == 2
                      ? VisitOrderScreen()
                      : currentIndex == 3
                          ? _collectionTab(context)
                          : currentIndex == 4
                              ? _followUp(context)
                              : _summaryTab(context),
        ],
      ),
    );
  }

  // --------------------------- Visit History Tab --------------------------- //

  final searchClientHistoryController = TextEditingController();

  Expanded _visitHistoryTab(context) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          CustomContainer(
            verticalPad: 0,
            horizontalPad: 0,
            // width: double.infinity,
            color: Colors.transparent,
            child: Consumer<VisitScreenProvider>(
              builder: (context, provider, _) {
                return TextFromFieldWithPrefixSuffix(
                  controller: searchClientHistoryController,
                  onTap: () {},
                  validator: (value) {
                    return null;
                  },
                  onChange: (value) => provider
                      .runFilter(searchClientHistoryController.value.text),
                  labelText: 'Search Client',
                  fillColor: Colors.white,
                  applyPrefix: true,
                  prefixIcon: Icon(Icons.search),
                );
              },
            ),
          ),
          Expanded(
            child: Consumer<VisitScreenProvider>(
              builder: (context, provider, _) {
                provider.searchResult;
                return ListView.builder(
                  itemCount: provider.searchResult.length,
                  padding: EdgeInsets.only(
                      bottom: 8,
                      top: 8,
                      left: MediaQuery.of(context).size.width * 0),
                  itemBuilder: (context, index) {
                    String name = provider.searchResult[index]['client'];
                    double orderAmt = provider.searchResult[index]['orderAmt'];
                    double paidAmt = provider.searchResult[index]['paidAmt'];
                    String salesRepresentative =
                        provider.searchResult[index]['salesRepresentative'];
                    String dateTime = provider.searchResult[index]['dateTime'];
                    // double dueAmt = 0.0;
                    // if (orderAmt == 0.0 && paidAmt > orderAmt) {
                    //   dueAmt = 0.0;
                    // }
                    // Color cardColor = index.isEven ? Colors.white : CustomColors.primaryColor;
                    return ListTile(
                      contentPadding: EdgeInsets.all(0),
                      titleAlignment: ListTileTitleAlignment.center,
                      title: CustomContainer(
                        color: Colors.white,
                        width: double.infinity,
                        // applyShadow: true,
                        borderRadius: 8,
                        // elevation: 2,
                        // margin: EdgeInsets.all(0),
                        child: CustomContainer(
                          verticalPad: 0,
                          horizontalPad: 0,
                          width: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomText(
                                text: name,
                                fontWeight: FontWeight.w600,
                                size: 20,
                              ),
                              Divider(
                                thickness: 1,
                                // color: CustomColors.primaryBlack,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: 'Order amount: ',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    CustomText(
                                      text: orderAmt.toStringAsFixed(1),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: 'Paid amount: ',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    CustomText(
                                      text: paidAmt.toStringAsFixed(1),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                  // color: CustomColors.primaryBlack,
                                  ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: salesRepresentative,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    CustomText(
                                      text: dateTime.replaceFirst('T', ' '),
                                      fontWeight: FontWeight.w500,
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
              },
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------- New Visit Tab --------------------------- //

  final _newVisitFormKey = GlobalKey<FormState>();
  final clientNameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final panController = TextEditingController();
  final searchClientController = TextEditingController();
  bool isVisitFormValid = false;

  void clearNewVisitValues() {
    searchClientController.clear();
    clientNameController.clear();
    addressController.clear();
    phoneController.clear();
    emailController.clear();
    panController.clear();
  }

  Widget _newVisitTab(context) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          CustomContainer(
            verticalPad: 24.0,
            horizontalPad: 16.0,
            applyShadow: true,
            child: Form(
              key: _newVisitFormKey,
              child: Column(
                children: [
                  Builder(builder: (context) {
                    return TextFromFieldWithPrefixSuffix(
                      controller: clientNameController,
                      labelText: 'Select Client Name',
                      // hintText: 'Select Client Name',
                      readOnly: true,
                      onTap: () {
                        _newVisitshowBottomSheet(context);
                      },
                      validator: (value) {
                        // if (value!.isNotEmpty) {
                        //   isVisitFormValid = true;
                        //   return null;
                        // }
                        return value!.isEmpty ? 'Client Name Required' : null;
                      },
                      onChange: (value) {},
                    );
                  }),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFromFieldWithPrefixSuffix(
                    controller: addressController,
                    readOnly: true,
                    labelText: 'Address',
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                    onChange: (value) {},
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFromFieldWithPrefixSuffix(
                    controller: phoneController,
                    readOnly: true,
                    labelText: 'Phone',
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                    onChange: (value) {},
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFromFieldWithPrefixSuffix(
                    controller: emailController,
                    readOnly: true,
                    labelText: 'Email',
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                    onChange: (value) {},
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFromFieldWithPrefixSuffix(
                    controller: panController,
                    readOnly: true,
                    labelText: 'PAN',
                    onTap: () {},
                    validator: (value) {
                      return null;
                    },
                    onChange: (value) {},
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _newVisitshowBottomSheet(context) async {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: _newVisitbottomSheetAppBar(context),
            body: _newVisitbottomSheetBody(context),
          ),
        ),
      ),
    );
  }

  PreferredSize _newVisitbottomSheetAppBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        showLeading: true,
        leadingIcon: FontAwesomeIcons.arrowLeft,
        tabName: 'Search Client',
        onTapLeadingIcon: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _newVisitbottomSheetBody(context) {
    return Center(
      child: CustomContainer(
        verticalMargin: 16.0,
        child: Column(
          children: [
            Consumer<VisitScreenProvider>(
              builder: (context, provider, _) {
                return TextFromFieldWithPrefixSuffix(
                  controller: searchClientController,
                  labelText: 'Search Client',
                  applyPrefix: true,
                  prefixIcon: Icon(Icons.search),
                  validator: (value) {
                    return null;
                  },
                  onChange: (value) =>
                      provider.runFilter(searchClientController.value.text),
                  onTap: () {},
                );
              },
            ),
            Expanded(
              child: Consumer<VisitScreenProvider>(
                  builder: (context, provider, _) {
                return ListView.builder(
                  itemCount: provider.searchResult.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        print(provider.searchResult[index]);
                        provider.setClientName(
                            provider.searchResult[index]['client'].toString());
                        clientNameController.text =
                            provider.searchResult[index]['client'].toString();
                        addressController.text =
                            provider.searchResult[index]['address'].toString();
                        phoneController.text =
                            provider.searchResult[index]['phone'].toString();
                        emailController.text =
                            provider.searchResult[index]['email'].toString();
                        panController.text =
                            provider.searchResult[index]['pan'].toString();
                        Navigator.pop(context);
                      },
                      child: ListTile(
                        leading: CustomText(
                            text: provider.searchResult[index]['client']),
                      ),
                    );
                  },
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  borderColor: CustomColors.lightRed,
                  widget: CustomText(
                    text: 'Cancel',
                    color: CustomColors.lightRed,
                  ),
                ),
                CustomElevatedButton(
                  onPressed: () {},
                  borderColor: CustomColors.primaryColor,
                  widget: CustomText(
                    text: 'Create',
                    color: CustomColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------- Order Tab --------------------------- //

  final _orderFormKey = GlobalKey<FormState>();
  final searchProductController = TextEditingController();
  final productNameController = TextEditingController();
  final quantityController = TextEditingController();
  final mrpController = TextEditingController();
  final discountController = TextEditingController();
  final netPriceController = TextEditingController();
  final totalAmountController = TextEditingController();

  Future openCreateOrderDialog(context) => showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: CustomColors.primaryWhite,
            elevation: 10,
            // shape: ShapeBorder.lerp(
            //   Border.fromBorderSide(),)
            title: Center(
              child: CustomText(
                text: 'Select Product',
                fontWeight: FontWeight.bold,
                size: 22,
                color: CustomColors.primaryBlack,
              ),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: _orderFormKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TextFromFieldWithPrefixSuffix(
                      controller: productNameController,
                      labelText: 'Search Product',
                      validator: (value) {
                        return value!.isEmpty
                            ? 'Please select a product'
                            : null;
                      },
                      onChange: (value) {},
                      onTap: () {
                        print('tapped');
                        _showBottomSheet(context);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Consumer<OrderProvider>(builder: (context, provider, _) {
                      return TextFromFieldWithPrefixSuffix(
                        keyboardType: TextInputType.number,
                        controller: quantityController,
                        labelText: 'Quantity',
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Please enter quantity'
                              : null;
                        },
                        onChange: (value) {
                          if (value != null && value.isNotEmpty) {
                            int quantity = int.parse(value);
                            provider.setQuantity(quantity);
                            provider.totalPrice();
                            totalAmountController.text =
                                provider.total.toStringAsFixed(2);
                          }
                          if (value == null || value.isEmpty) {
                            print('Quantity = $value');
                            provider.setQuantity(0);
                            provider.setTotalPrice();
                            totalAmountController.text =
                                provider.total.toStringAsFixed(2);
                          }
                        },
                        onTap: () {},
                      );
                    }),
                    SizedBox(
                      height: 10,
                    ),
                    TextFromFieldWithPrefixSuffix(
                      controller: mrpController,
                      labelText: 'MRP',
                      readOnly: true,
                      validator: (value) {
                        return null;
                      },
                      onChange: (value) {
                        // return null;
                      },
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Consumer<OrderProvider>(builder: (context, provider, _) {
                      return TextFromFieldWithPrefixSuffix(
                        controller: discountController,
                        keyboardType: TextInputType.number,
                        labelText: 'Discount',
                        // readOnly: true,
                        validator: (value) {
                          return null;
                        },
                        onChange: (value) {
                          if (value != null && value.isNotEmpty) {
                            provider.setDiscountRate(double.parse(value));
                            provider.setDiscountedPrice();
                            provider.totalPrice();
                            netPriceController.text =
                                provider.discountedPrice.toStringAsFixed(2);
                            totalAmountController.text =
                                provider.total.toStringAsFixed(2);
                          }
                          if (value == null || value.isEmpty) {
                            provider.setDiscountRate(0.0);
                            provider.setDiscountedPrice();
                            provider.setTotalPrice();
                            netPriceController.text =
                                provider.discountedPrice.toStringAsFixed(2);
                            totalAmountController.text =
                                provider.total.toStringAsFixed(2);
                          }
                        },
                        onTap: () {},
                      );
                    }),
                    SizedBox(
                      height: 10,
                    ),
                    TextFromFieldWithPrefixSuffix(
                      controller: netPriceController,
                      labelText: 'Net Price',
                      readOnly: true,
                      validator: (value) {
                        return null;
                      },
                      onChange: (value) {
                        // return null;
                      },
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Consumer<OrderProvider>(
                      builder: (context, provider, _) {
                        totalAmountController.text =
                            provider.total.toStringAsFixed(2);
                        return TextFromFieldWithPrefixSuffix(
                          controller: totalAmountController,
                          labelText: 'Total Amount',
                          readOnly: true,
                          validator: (value) {
                            return null;
                          },
                          onChange: (value) {
                            // return
                          },
                          onTap: () {},
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<OrderProvider>(builder: (context, provider, _) {
                    return CustomElevatedButton(
                      onPressed: () {
                        clearOrderInputFieldValues();
                        provider.clearValues();
                        Navigator.pop(context, false); // passing false
                      },
                      backgroundColor: Colors.white,
                      widget: CustomText(
                        text: 'Cancel',
                        color: CustomColors.primaryBlack,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }),
                  Consumer<OrderProvider>(builder: (context, provider, _) {
                    return CustomElevatedButton(
                      onPressed: () {
                        // Orders(
                        //   productName: searchProductController.text,
                        //   quantity: provider.quantity,
                        //   price: provider.price,
                        //   discountRate: 5,
                        //   netAmount: provider.discountedPrice,
                        //   totalPrice: provider.total,
                        // );
                        if (_orderFormKey.currentState!.validate()) {
                          provider.addItem(Orders(
                            productName: productNameController.text,
                            quantity: provider.quantity,
                            price: provider.price,
                            discountRate: provider.discountRate,
                            netAmount: provider.discountedPrice,
                            totalPrice: provider.total,
                          ));
                          clearOrderInputFieldValues();
                          provider.clearValues();
                          Navigator.pop(context, false);
                        }
                        // SystemNavigator.pop();
                      }, // passing true
                      backgroundColor: CustomColors.primaryColor,
                      widget: CustomText(
                        text: 'Add',
                        color: CustomColors.primaryBlack,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }),
                ],
              ),
            ],
          );
        },
      );

  void clearOrderInputFieldValues() {
    searchProductController.clear();
    productNameController.clear();
    mrpController.clear();
    totalAmountController.clear();
    discountController.clear();
    quantityController.clear();
    netPriceController.clear();
  }

  Future<void> _showBottomSheet(context) async {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: _bottomSheetAppBar(context),
            body: _bottomSheetBody(context),
          ),
        ),
      ),
    );
  }

  PreferredSize _bottomSheetAppBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        showLeading: true,
        leadingIcon: FontAwesomeIcons.arrowLeft,
        tabName: 'Select Product',
        onTapLeadingIcon: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _bottomSheetBody(context) {
    return Center(
      child: CustomContainer(
        verticalMargin: 16.0,
        child: Column(
          children: [
            Consumer<VisitScreenProvider>(
              builder: (context, provider, _) {
                return TextFromFieldWithPrefixSuffix(
                  controller: searchProductController,
                  labelText: 'Search Product',
                  applyPrefix: true,
                  prefixIcon: Icon(Icons.search),
                  validator: (value) {
                    return null;
                  },
                  onChange: (value) =>
                      provider.runFilter(searchProductController.value.text),
                  onTap: () {},
                );
              },
            ),
            Expanded(
              child: Consumer<OrderProvider>(
                builder: (context, provider, _) {
                  return ListView.builder(
                    itemCount: PRODUCTS.length,
                    itemBuilder: (context, index) {
                      Product product = PRODUCTS[index];
                      return InkWell(
                        onTap: () {
                          print(product);
                          productNameController.text = product.name.toString();
                          mrpController.text = product.price.toString();
                          netPriceController.text = product.price.toString();
                          discountController.text = '0';
                          provider.setPrice(product.price);
                          Navigator.pop(context);
                        },
                        child: ListTile(
                          title: CustomText(
                            text: product.name,
                            textOverflow: TextOverflow.visible,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  borderColor: CustomColors.lightRed,
                  widget: CustomText(
                    text: 'Cancel',
                    color: CustomColors.lightRed,
                  ),
                ),
                CustomElevatedButton(
                  onPressed: () {},
                  borderColor: CustomColors.primaryColor,
                  widget: CustomText(
                    text: 'Create',
                    color: CustomColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------- Collection Up Tab --------------------------- //

  Expanded _collectionTab(context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.all(6),
        child: SingleChildScrollView(
          child: Center(
            child: CustomContainer(
              horizontalPad: 1,
              verticalPad: 3,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Center(
                      child: Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    color: CustomColors.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      child: CustomText(
                        text: 'Cash',
                        fontWeight: FontWeight.w600,
                        size: 18,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.060,
                    color: CustomColors.primaryWhite,
                    child: Center(
                      child: Text(
                        'Add Cash Here',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    color: CustomColors.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      child: CustomText(
                        text: 'Cheque',
                        fontWeight: FontWeight.w600,
                        size: 18,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.060,
                    color: CustomColors.primaryWhite,
                    child: Center(
                      child: Text(
                        'Add Cheque Here',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    color: CustomColors.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      child: CustomText(
                        text: 'Banks',
                        fontWeight: FontWeight.w600,
                        size: 18,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.060,
                    color: CustomColors.primaryWhite,
                    child: Center(
                      child: Text(
                        'Add Banks Here',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
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

  // --------------------------- Follow Up Tab --------------------------- //

  final _followUpFormKey = GlobalKey<FormState>();
  NepaliDateTime selectedDate = NepaliDateTime.now();
  final followUpNoteController = TextEditingController();
  final followUpDateController = TextEditingController();
  bool isFollowUpFormValid = false;

  Expanded _followUp(context) {
    return Expanded(
      child: Column(
        children: [
          CustomContainer(
            verticalMargin: 8,
            verticalPad: 24,
            child: Form(
              key: _followUpFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFromFieldWithPrefixSuffix(
                    controller: followUpNoteController,
                    autoFocus: true,
                    hintText: 'Visit note*',
                    labelText: 'Follow up note',
                    minLine: 4,
                    maxLines: 4,
                    validator: (value) {
                      // if (value!.isNotEmpty && value.length > 3) {
                      //   isFollowUpFormValid = true;
                      //   return null;
                      // } else {
                      //   return value.isEmpty
                      //       ? 'Visit note is required'
                      //       : 'Enter atleast 3 characters';
                      // }
                      return value!.isEmpty
                          ? 'Visit note is required'
                          : value.length < 3
                              ? 'Enter atleast 3 characters'
                              : null;
                    },
                    onChange: (value) {},
                    onTap: () {},
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFromFieldWithPrefixSuffix(
                    controller: followUpDateController,
                    readOnly: true,
                    onTap: () {
                      datePicker();
                    },
                    validator: (value) {
                      return null;
                    },
                    onChange: (value) {},
                    labelText: 'Follow Up Date',
                    applySuffixIcon: true,
                    suffixIcon: InkWell(
                      onTap: () {
                        // authProvider.toggleObscure();
                      },
                      child: Icon(
                        Icons.calendar_month,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> datePicker() async {
    String date = '';
    NepaliDateTime? _selectedDateTime = await picker.showMaterialDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: NepaliDateTime(2000),
      lastDate: NepaliDateTime(2090),
      initialDatePickerMode: DatePickerMode.day,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              surfaceContainerHighest: Colors.white,
              tertiary: CustomColors.primaryColor,
              onTertiary: Colors.white,
              primary: CustomColors.primaryColor, // circle color
              onPrimary: CustomColors.primaryBlack, // selected text color
              onSurface: CustomColors.primaryBlack, // default text color
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: CustomColors.primaryBlack,
                textStyle: TextStyle(
                  color: CustomColors.primaryColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  // fontFamily: 'Quicksand',
                ), // color of button's letters
                // backgroundColor: Colors.green, // Background color
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: CustomColors.primaryColor,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    // selectedDate = _selectedDateTime!;
    if (_selectedDateTime != null) {
      setState(() {
        selectedDate = _selectedDateTime;
        date = _selectedDateTime.toString().split(' ')[0];
        debugPrint(
            'followUpDateController.text = ${followUpDateController.text}');
        debugPrint('selectedDate = $date');
      });
      return date;
    }
    return date;
  }

// --------------------------- Summary Tab --------------------------- //

  Expanded _summaryTab(context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.all(6),
        child: VisitSummary(),
      ),
    );
  }
}
