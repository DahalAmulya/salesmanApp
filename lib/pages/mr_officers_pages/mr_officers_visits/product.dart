import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../routes/marketing_officer_consts.dart';
import '../../../widgets/app_bars/custom_app_bars.dart';
import '../../../widgets/text_fields/text_from_field.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  TextEditingController searchProduct = TextEditingController();
  TextEditingController productQuantityController = TextEditingController();
  TextEditingController productDiscountController = TextEditingController();
  List<Map<String, dynamic>> foundMedicine = [];
  String foundMed = '';
  List<Map<String, dynamic>> medList = [
    {
      "name": "Paracetamol",
      "price": 40,
      "pack": 320,
    },
    {
      "name": "Nemuslide",
      "price": 50,
      "pack": 440,
    },
    {
      "name": "Pentaprazole",
      "price": 80,
      "pack": 640,
    },
    {
      "name": "Losita-H",
      "price": 95,
      "pack": 1140,
    },
    {
      "name": "Triptans",
      "price": 50,
      "pack": 400,
    },
    {
      "name": "Aspirin",
      "price": 20,
      "pack": 160,
    },
    {
      "name": "Almotriptan",
      "price": 90,
      "pack": 720,
    },
    {
      "name": "Naproxen",
      "price": 40,
      "pack": 320,
    },
    {
      "name": "Ibuprofen",
      "price": 60,
      "pack": 480,
    },
    {
      "name": "Acetaminophen",
      "price": 100,
      "pack": 800,
    },
    {
      "name": "Anticholinergic",
      "price": 80,
      "pack": 320,
    },
    {
      "name": "Ativan",
      "price": 70,
      "pack": 560,
    },
    {
      "name": "Benzodiazepines",
      "price": 60,
      "pack": 480,
    },
  ];

  List<Map<String, dynamic>> selectedProduct = [
    {
      "productName": "",
      "productPrice": "",
      "productQuantity": "",
      "productDiscountedPrice": "",
      "productTotalPrice": "",
    }
  ];

  void runMedFilter(String enteredKeyword) {
    List<Map<String, dynamic>> medResult = [];
    if (enteredKeyword.isEmpty) {
      setState(() {
        medResult = medList;
      });
    } else {
      medResult = medList
          .where((medList) => medList['name']
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      foundMedicine = medResult;
    });
  }

  @override
  void initState() {
    foundMedicine = medList;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(context),
      body: _body(context),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: CustomColors.primaryColor,
        onPressed: (){
          _bottomSheetForProduct(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Product Page',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTapLeadingIcon: () {
          Navigator.of(context)
              .pop(MarketingOfficerConstants.mrStaffDashboardConst);
        },
      ),
    );
  }

  Widget _body(context) {
    return ListView.separated(
      itemBuilder: (Content,index){
        return CustomContainer(
          horizontalMargin: 16,
          verticalMargin: 8,
          child: Column(
            children: [
              Row(
                children: [
                  CustomText(text: 'Product Name :'),
                ],
              ),
              Row(
                children: [
                  CustomText(text: 'Product Price :'),
                ],
              ),
              Row(
                children: [
                  CustomText(text: 'Product Quantity :'),
                ],
              ),
              Row(
                children: [
                  CustomText(text: 'Product Discount :'),
                ],
              ),
              Divider(
                color: Colors.black,
                thickness: 1,
              ),
              Row(
                children: [
                  CustomText(text: 'Total Price :'),
                ],
              ),
            ],
          ),
        );
      // return ListView(
      //   children: [
      //
      //     Center(
      //       child: CustomElevatedButton(
      //         backgroundColor: Colors.white,
      //         onPressed: () {
      //           _bottomSheetForProduct(context);
      //         },
      //         widget: CustomText(
      //           text: 'Orders',
      //           size: 24,
      //           fontWeight: FontWeight.w600,
      //         ),
      //       ),
      //     ),
      //
      //   ],
      // );
      },
      separatorBuilder: (context, index) {
        return SizedBox.shrink();
      },
      itemCount: 2,
    );
  }

  //----------------------------------------------------------------Bottom Sheet----------------------------------------------------------------//

  Future<void> _bottomSheetForProduct(context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take up more space
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: _productBottomSheetAppBar(context),
            body: _bottomaheetBody(context),
          ),
        ),
      ),
    );
  }

  PreferredSize _productBottomSheetAppBar(context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          showLeading: true,
          leadingIcon: FontAwesomeIcons.arrowLeft,
          backgroundColor: CustomColors.primaryColor,
          tabName: 'Select Product',
          onTapLeadingIcon: () {
            Navigator.pop(context);
          },
        ));
  }

  Widget _bottomaheetBody(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: TextFromFieldWithPrefixSuffix(
              applyPrefix: true,
              prefixIcon: Icon(Icons.search),
              controller: searchProduct,
              hintText: 'Search',
              validator: (Value) {},
              onChange: (value) => runMedFilter(value!),
              onTap: () {},
            ),
          ),
          ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: foundMedicine.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      openAlertDialog();
                      foundMed = foundMedicine[index]['price'].toString();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.070,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: "Name: ${foundMedicine[index]['name']}"),
                          CustomText(
                              text:
                                  "Price: ${foundMedicine[index]['price'].toString()}"),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  //-----------------------------------------Alert Dialog--------------------------------------------------------//
  void openAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: CustomText(
              text: 'Product',
              fontWeight: FontWeight.w600,
              size: 24,
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomText(
                            text: 'Quantity : ',
                            size: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFromFieldWithPrefixSuffix(
                              controller: productQuantityController,
                              validator: (value){},
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {},
                        //   child: CircleAvatar(
                        //     radius: 10,
                        //     child: Icon(
                        //       Icons.add,
                        //       size: 16,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   width: 16,
                        // ),
                        // InkWell(
                        //   onTap: () {},
                        //   child: CircleAvatar(
                        //     radius: 10,
                        //     child: FaIcon(
                        //       FontAwesomeIcons.minus,
                        //       size: 16,
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomText(
                            text: 'Price : ',
                            size: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: CustomColors.primaryWhite,
                              border: Border.all(color: Colors.black,width: 0.6)
                            ),
                            child: Center(
                              child: CustomText(
                                text: foundMed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomText(
                            text: 'Discount : ',
                            size: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFromFieldWithPrefixSuffix(
                            controller: productDiscountController,
                            validator: (value){},
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomText(
                            text: 'Total Price : ',
                            size: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: CustomColors.primaryWhite,
                                border: Border.all(color: Colors.black,width: 0.6)
                            ),
                            child: Center(
                              child: CustomText(
                                text: 'foundMed',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Add'),
              ),
            ],
          );
        });
  }
}

// 'Paracetamol','Nemuslide','Pentaprazole','Losita-H','Triptans','Aspirin','Almotriptan','Naproxen','Ibuprofen','Acetaminophen','Anticholinergic','Phenergan','Benzodiazepines','Ativan'
// ListTile(
// title: CustomText(
// text: medList[index]['name']
// ),
// subtitle: CustomText(text: medList[index]['price']),
// onTap:(){
// searchProduct.text = foundMedicine[index];
// },
// );
