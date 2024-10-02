import 'dart:async';
import 'dart:io';

import 'package:deskgoo/pages/visit/summary_Page.dart';
import 'package:deskgoo/pages/visit/visit_order_screen.dart';
import 'package:deskgoo/providers/camera_provider/camera_provider.dart';
import 'package:deskgoo/providers/marketing_provider/officersDescription_provider.dart';
import 'package:deskgoo/providers/visit_provider/order_items.dart';
import 'package:deskgoo/providers/visit_provider/order_provider.dart';
import 'package:deskgoo/providers/visit_provider/visit_screen_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:go_router/go_router.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:provider/provider.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'Summary_BottomSheet/colltectionSummary_bottomSheet.dart';

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
  VisitScreenProvider? _visitScreenProvider;

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
  // int currentIndex = 0;

  @override
  void initState() {
    _visitScreenProvider =
        Provider.of<VisitScreenProvider>(context, listen: false);
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
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        // GoRouter.of(context)
        //     .pushReplacementNamed(MyAppRouteConstants.homeNavBarRouteName);
        Navigator.of(context).pushNamed(RouteGeneratorConstants.homePage);
      }),
      child: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping outside TextFormFields
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          // backgroundColor: Colors.amberAccent,
          appBar: _appBar(context),
          drawer: CustomDrawer(
            isVisitActive: true,
          ),
          body: _buildUI(context),
          floatingActionButton:
              // currentIndex == 1 || currentIndex == 2 || currentIndex == 3
              _visitScreenProvider!.index == 1 ||
                      _visitScreenProvider!.index == 2 ||
                      _visitScreenProvider!.index == 3
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
                                if (_visitScreenProvider!.index == 1) {
                                  print(
                                      'Current index = ${_visitScreenProvider!.index} 1');
                                  _newVisitshowBottomSheet(context);
                                } else if (_visitScreenProvider!.index == 2) {
                                  print(
                                      'Current index = ${_visitScreenProvider!.index} 2');
                                  openCreateOrderDialog(context);
                                } else if (_visitScreenProvider!.index == 3) {
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
        ),
      ),
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
      child: Consumer<VisitScreenProvider>(
        builder: (context, visitScreenProvider, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: double.infinity,
                child: Consumer<VisitScreenProvider>(
                    builder: (context, visitScreenProvider, _) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: items.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              if (visitScreenProvider.clientName.isNotEmpty) {
                                clientNameController.text =
                                    visitScreenProvider.clientName;
                                addressController.text =
                                    visitScreenProvider.clientAddress;
                                phoneController.text =
                                    visitScreenProvider.clientPhone;
                                emailController.text =
                                    visitScreenProvider.clientEmail;
                                panController.text =
                                    visitScreenProvider.clientPan;
                              }
                              if (visitScreenProvider.index == 1 &&
                                  visitScreenProvider.index != index) {
                                if (_newVisitFormKey.currentState!.validate()) {
                                  visitScreenProvider.setIndex(index);
                                } else {
                                  visitScreenProvider.setIndex(1);
                                  print(
                                      '_newVisitFormKey valid = ${_newVisitFormKey.currentState!.validate()}');
                                }
                              } else if (visitScreenProvider.index == 4 &&
                                  visitScreenProvider.index != index) {
                                if (clientNameController
                                    .value.text.isNotEmpty) {}
                                if (_followUpFormKey.currentState!.validate()) {
                                  print('Form valid');
                                  if (visitScreenProvider
                                      .followUpNote.isEmpty) {
                                    visitScreenProvider.setFollowUpNote(
                                        followUpNoteController.value.text);
                                  }
                                  visitScreenProvider.setIndex(index);
                                } else {
                                  print(
                                      '_newVisitFormKey = ${!_followUpFormKey.currentState!.validate()}');
                                  visitScreenProvider.setIndex(4);
                                }
                                print(
                                    '_followUpFormKey valid = $isFollowUpFormValid');
                              } else {
                                visitScreenProvider.setIndex(index);
                                print(
                                    'current index: ${visitScreenProvider.index}');
                              }
                              // });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: EdgeInsets.all(4),
                              width: 120,
                              height: 40,
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: visitScreenProvider.index == index
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FaIcon(
                                      icons[index],
                                      size: 14,
                                      color: visitScreenProvider.index == index
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                    CustomText(
                                      text: '${items[index]}',
                                      fontWeight: FontWeight.w500,
                                      color: visitScreenProvider.index == index
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
                  );
                }),
              ),
              visitScreenProvider.index == 0
                  ? _visitHistoryTab(context)
                  : visitScreenProvider.index == 1
                      ? _newVisitTab(context)
                      : visitScreenProvider.index == 2
                          ? VisitOrderScreen()
                          : visitScreenProvider.index == 3
                              ? _collectionTab(context)
                              : visitScreenProvider.index == 4
                                  ? _followUp(context)
                                  : _summaryTab(context),
            ],
          );
        },
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
                  onChange: (value) => provider.runSearchClientHistoryFilter(
                      searchClientHistoryController.value.text),
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
    DetailsProvider detailsProvider =
        Provider.of<DetailsProvider>(context, listen: true);
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
                  onChange: (value) => provider
                      .runSearchClientFilter(searchClientController.value.text),
                  onTap: () {},
                );
              },
            ),
            Expanded(
              child: Consumer<VisitScreenProvider>(
                builder: (context, provider, _) {
                  return ListView.builder(
                    itemCount: provider.searchVistiCleintResults.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          print(provider.searchVistiCleintResults[index]);
                          provider.setClientName(
                            provider.searchVistiCleintResults[index]['client']
                                .toString(),
                            provider.searchVistiCleintResults[index]['address']
                                .toString(),
                            provider.searchVistiCleintResults[index]['phone']
                                .toString(),
                            '${DateTime.now().toString().split('.')[0]}',
                            provider.searchVistiCleintResults[index]['email'],
                            provider.searchVistiCleintResults[index]['pan'],
                          );
                          clientNameController.text = provider
                              .searchVistiCleintResults[index]['client']
                              .toString();
                          addressController.text = provider
                              .searchVistiCleintResults[index]['address']
                              .toString();
                          phoneController.text = provider
                              .searchVistiCleintResults[index]['phone']
                              .toString();
                          emailController.text = provider
                              .searchVistiCleintResults[index]['email']
                              .toString();
                          panController.text = provider
                              .searchVistiCleintResults[index]['pan']
                              .toString();
                          Navigator.pop(context);
                          provider.resetSearchClientFilter();
                        },
                        child: ListTile(
                          leading: CustomText(
                              text: provider.searchVistiCleintResults[index]
                                  ['client']),
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
                // CustomElevatedButton(
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                //   borderColor: CustomColors.primaryColor,
                //   widget: CustomText(
                //     text: 'Create',
                //     color: CustomColors.primaryColor,
                //   ),
                // ),
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
          child: GestureDetector(
            onTap: () {
              // Dismiss the keyboard when tapping outside TextFormFields
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                FocusScope.of(context).unfocus();
              }
            },
            child: Scaffold(
              backgroundColor: Colors.grey.shade200,
              appBar: _bottomSheetAppBar(context),
              body: _bottomSheetBody(context),
            ),
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
            Consumer<OrderProvider>(
              builder: (context, provider, _) {
                return TextFromFieldWithPrefixSuffix(
                  controller: searchProductController,
                  labelText: 'Search Product',
                  applyPrefix: true,
                  prefixIcon: Icon(Icons.search),
                  validator: (value) {
                    return null;
                  },
                  onChange: (value) => provider.runProductsSearchFilter(
                      searchProductController.value.text),
                  onTap: () {},
                );
              },
            ),
            Expanded(
              child: Consumer<OrderProvider>(
                builder: (context, provider, _) {
                  return ListView.builder(
                    itemCount: provider.productSearchResults.length,
                    itemBuilder: (context, index) {
                      Product product = PRODUCTS[index];
                      return InkWell(
                        onTap: () {
                          print(product);
                          productNameController.text = provider
                              .productSearchResults[index].name
                              .toString();
                          mrpController.text = provider
                              .productSearchResults[index].price
                              .toString();
                          netPriceController.text = provider
                              .productSearchResults[index].price
                              .toString();
                          discountController.text = '0';
                          provider.setPrice(
                              provider.productSearchResults[index].price);
                          Navigator.pop(context);
                          provider.resetProductSearchResults();
                        },
                        child: ListTile(
                          title: CustomText(
                            text: provider.productSearchResults[index].name
                                .toString(),
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
  final String name = '';
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
                      child: Consumer<VisitScreenProvider>(
                          builder: (context, provider, _) {
                        return CustomText(
                          text: provider.clientName,
                          size: 18,
                          fontWeight: FontWeight.w600,
                        );
                      }),
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
  String photo = '';
  bool isFollowUpFormValid = false;

  Expanded _followUp(context) {
    DetailsProvider detailsProvider = Provider.of<DetailsProvider>(context);
    VisitScreenProvider visitScreenProvider =
        Provider.of<VisitScreenProvider>(context);
    if (visitScreenProvider.followUpNote.isNotEmpty) {
      followUpNoteController.text = visitScreenProvider.followUpNote;
    }
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomContainer(
              verticalMargin: 8,
              verticalPad: 24,
              child: Form(
                key: _followUpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFromFieldWithPrefixSuffix(
                      controller: followUpNoteController,
                      autoFocus: false,
                      // hintText: 'Visit note*',
                      labelText: 'Follow up note',
                      minLine: 6,
                      maxLines: 6,
                      validator: (value) {
                        // print(visitScreenProvider.followUpNote);
                        return value!.isEmpty
                            ? 'Visit note is required'
                            : value.length < 3
                                ? 'Enter atleast 3 characters'
                                : null;
                      },
                      onChange: (value) {
                        // visitScreenProvider.setFollowUpNote(value!);
                      },
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
                          datePicker();
                          // authProvider.toggleObscure();
                        },
                        child: Icon(
                          Icons.calendar_month,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Consumer<CameraProvider>(
                      builder: (context, cameraProvider, _) {
                        if (cameraProvider.isNewVisit) {
                          photo = cameraProvider.newVisitSelectedPhoto;
                        }
                        if (cameraProvider.isFollowUp) {
                          photo = cameraProvider.followUpSelectedPhoto;
                        }
                        return GestureDetector(
                          onTap: () {
                            if (visitScreenProvider.followUpNote.isEmpty) {
                              visitScreenProvider.setFollowUpNote(
                                  followUpNoteController.value.text);
                            }
                            cameraProvider.setIsFollowUp();
                            Navigator.of(context)
                                .pushNamed(RouteGeneratorConstants.cameraPage);
                            print('Tapped on image contaier');
                          },
                          child: CustomContainer(
                            borderRadius: 8,
                            verticalPad: 12,
                            borderColor: CustomColors.primaryBlack,
                            color: CustomColors.primaryWhite,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // CustomText(
                                    //     text: 'Tap to select click an image'),
                                    Consumer<CameraProvider>(
                                      builder: (context, cameraProvider, _) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (visitScreenProvider
                                                .followUpNote.isEmpty) {
                                              visitScreenProvider
                                                  .setFollowUpNote(
                                                      followUpNoteController
                                                          .value.text);
                                            }
                                            cameraProvider.setIsFollowUp();
                                            Navigator.of(context).pushNamed(
                                                RouteGeneratorConstants
                                                    .cameraPage);
                                            print('image Icon Tapped');
                                          },
                                          child: SizedBox(
                                            height: 28,
                                            width: 24,
                                            child: Image.asset(
                                              'assets/images/camera.png',
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: photo.isNotEmpty ? 2 : 0,
                                ),
                                if (photo.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          RouteGeneratorConstants
                                              .previewSelectedPhotoPage);
                                      print('Image tapped');
                                    },
                                    child: SizedBox(
                                      height: 325,
                                      width: double.infinity,
                                      child: InteractiveViewer(
                                        panEnabled: true, // Set it to false
                                        panAxis: PanAxis.free,
                                        boundaryMargin: EdgeInsets.all(0),
                                        minScale: 1,
                                        maxScale: 2.5,
                                        child: Image.file(
                                          File(photo),
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Consumer<CameraProvider>(
                        builder: (context, cameraProvider, _) {
                      return CustomElevatedButton(
                        onPressed: () {
                          print(followUpNoteController.value.text);
                          detailsProvider.addFollowUpVisitDetails(
                            visitScreenProvider.clientName,
                            visitScreenProvider.clientAddress,
                            visitScreenProvider.clientPhone,
                            visitScreenProvider.clientVisitedDateTime,
                            followUpNoteController.value.text,
                            photo,
                          );
                          visitScreenProvider.setIndex(1);
                          cameraProvider.resetCameraStroredPhotos();
                          visitScreenProvider.resetClientDetailsValues();
                          clearNewVisitValues();
                          followUpNoteController.clear();
                        },
                        backgroundColor: CustomColors.primaryColor,
                        widget: CustomText(
                          text: 'Submit',
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
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
        date = _selectedDateTime.toString();
        followUpDateController.text = selectedDate.toString().split(' ')[0];
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
