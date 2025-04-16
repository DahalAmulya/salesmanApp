import 'package:deskgoo/providers/visit_provider/order_items.dart';
import 'package:deskgoo/providers/visit_provider/order_provider.dart';
import 'package:deskgoo/providers/visit_provider/visit_screen_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../routes/marketing_officer_consts.dart';
import '../../../widgets/app_bars/custom_app_bars.dart';
import '../../../widgets/text_fields/text_from_field.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _orderFormKey = GlobalKey<FormState>();
  final searchProductController = TextEditingController();
  final productNameController = TextEditingController();
  final quantityController = TextEditingController();
  final mrpController = TextEditingController();
  final discountController = TextEditingController();
  final netPriceController = TextEditingController();
  final totalAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(context),
      body: _buildUI(context),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: CustomColors.primaryColor,
        onPressed: () {
          openCreateOrderDialog(context);
          // _bottomSheetForProduct(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Orders',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTapLeadingIcon: () {
          Navigator.of(context)
              .pop(MarketingOfficerConstants.mrStaffDashboardConst);
        },
      ),
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
              Expanded(
                child: Consumer<OrderProvider>(
                  builder: (context, provider, _) {
                    print(provider.items.length);
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 48, top: 8),
                      itemCount: provider.items.length,
                      itemBuilder: (context, index) {
                        Orders orders = provider.items[index];
                        Color cardColor = Colors.white;
                        return ListTile(
                          onTap: () {
                            print(
                                '${orders.productName}, ${orders.quantity}, ${orders.price}, ${orders.discountRate}, ${orders.netAmount}, ${orders.totalPrice}');
                            // provider.remove(orders);
                          },
                          minVerticalPadding: 5,
                          contentPadding: const EdgeInsets.all(0),
                          onLongPress: () {
                            cardColor = Colors.red;
                            openDeleteItemDialog(
                                context, orders.productName, orders);
                            // provider.remove(orders);
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
                            margin: const EdgeInsets.all(0),
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
                                              Expanded(
                                                child: CustomText(
                                                  text: orders.productName,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                                'Rs. ${orders.netAmount.toStringAsFixed(2)}',
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
                                                'Rs. ${(orders.totalPrice).toStringAsFixed(2)}',
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
                                                      onPressed: () {
                                                        provider
                                                            .removeOneQuantity(
                                                                index);
                                                        print(
                                                            '${orders.quantity}');
                                                      },
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      icon: const Icon(
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
                                                      onPressed: () {
                                                        provider.addOneQuantity(
                                                            index);
                                                        print(
                                                            '${orders.quantity}');
                                                      },
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      icon: const Icon(
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
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future openDeleteItemDialog(context, productName, item) => showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: CustomColors.primaryWhite,
            elevation: 10,
            title: CustomText(
              text: 'Delete Item',
              fontWeight: FontWeight.bold,
              size: 22,
              color: CustomColors.lightRed,
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  // CustomText(text: 'Are you sure you want to delete?'),
                  CustomText(
                    text: productName,
                    textOverflow: TextOverflow.visible,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomElevatedButton(
                    borderColor: CustomColors.primaryColor,
                    onPressed: () =>
                        Navigator.pop(context, false), // passing false
                    widget: CustomText(
                      text: 'No',
                      color: CustomColors.primaryBlack,
                    ),
                  ),
                  Consumer<OrderProvider>(builder: (context, provider, _) {
                    return CustomElevatedButton(
                      borderColor: CustomColors.lightRed,
                      onPressed: () {
                        provider.remove(item);
                        Navigator.pop(context, false);
                        // SystemNavigator.pop();
                      }, // passing true
                      widget: CustomText(
                        text: 'Yes',
                        color: CustomColors.lightRed,
                      ),
                    );
                  }),
                ],
              ),
            ],
          );
        },
      );

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
                    const SizedBox(
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
                    const SizedBox(
                      height: 10,
                    ),
                    Consumer<OrderProvider>(
                      builder: (context, provider, _) {
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
                      },
                    ),
                    const SizedBox(
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
                    const SizedBox(
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
                    const SizedBox(
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
                    const SizedBox(
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
                      backgroundColor: CustomColors.lightRed,
                      widget: CustomText(
                        text: 'Cancel',
                        color: CustomColors.primaryBlack,
                        isContent: true,
                      ),
                    );
                  }),
                  Consumer<OrderProvider>(builder: (context, provider, _) {
                    return CustomElevatedButton(
                      onPressed: () {
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
                        isContent: true,
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
      preferredSize: const Size.fromHeight(kToolbarHeight),
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
                  prefixIcon: const Icon(Icons.search),
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
}
