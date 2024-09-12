import 'dart:async';

import 'package:deskgoo/providers/visit_provider/visit_screen_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:provider/provider.dart';

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
  final searchController = TextEditingController();

  // List<Map<String, dynamic>> visitStats = [
  //   {
  //     'client': 'Anu Yadav',
  //     'orderAmt': 0.0,
  //     'paidAmt': 0.0,
  //     'dueAmt': 0.0,
  //     'salesRepresentative': 'John Cena',
  //     'dateTime': '2081-05-27T09:05:32'
  //   },
  //   {
  //     'client': 'Raj Patel',
  //     'orderAmt': 150.0,
  //     'paidAmt': 100.0,
  //     'dueAmt': 50.0,
  //     'salesRepresentative': 'John Cena',
  //     'dateTime': '2081-05-27T09:05:32'
  //   },
  //   {
  //     'client': 'Sita Rai',
  //     'orderAmt': 200.0,
  //     'paidAmt': 200.0,
  //     'dueAmt': 0.0,
  //     'salesRepresentative': 'John Cena',
  //     'dateTime': '2081-05-27T09:05:32'
  //   },
  //   {
  //     'client': 'Ram Sharma',
  //     'orderAmt': 300.0,
  //     'paidAmt': 150.0,
  //     'dueAmt': 150.0,
  //     'salesRepresentative': 'John Cena',
  //     'dateTime': '2081-05-27T09:05:32'
  //   },
  //   {
  //     'client': 'Gita Shrestha',
  //     'orderAmt': 400.0,
  //     'paidAmt': 300.0,
  //     'dueAmt': 100.0,
  //     'salesRepresentative': 'John Cena',
  //     'dateTime': '2081-05-27T09:05:32'
  //   },
  //   {
  //     'client': 'Hari Singh',
  //     'orderAmt': 100.0,
  //     'paidAmt': 100.0,
  //     'dueAmt': 0.0,
  //     'salesRepresentative': 'John Cena',
  //     'dateTime': '2081-05-27T09:05:32'
  //   },
  //   {
  //     'client': 'Kiran Thapa',
  //     'orderAmt': 250.0,
  //     'paidAmt': 200.0,
  //     'dueAmt': 50.0,
  //     'salesRepresentative': 'John Cena',
  //     'dateTime': '2081-05-27T09:05:32'
  //   },
  //   {
  //     'client': 'Meena Karki',
  //     'orderAmt': 500.0,
  //     'paidAmt': 400.0,
  //     'dueAmt': 100.0,
  //     'salesRepresentative': 'John Cena',
  //     'dateTime': '2081-05-27T09:05:32'
  //   },
  //   {
  //     'client': 'Sunil Joshi',
  //     'orderAmt': 600.0,
  //     'paidAmt': 300.0,
  //     'dueAmt': 300.0,
  //     'salesRepresentative': 'John Cena',
  //     'dateTime': '2081-05-27T09:05:32'
  //   },
  //   {
  //     'client': 'Nina Maharjan',
  //     'orderAmt': 350.0,
  //     'paidAmt': 350.0,
  //     'dueAmt': 0.0,
  //     'salesRepresentative': 'John Cena',
  //     'dateTime': '2081-05-27T09:05:32'
  //   },
  //   {
  //     'client': 'Manish kumar Rajbanshi',
  //     'orderAmt': 0.0,
  //     'paidAmt': 350.0,
  //     'dueAmt': 0.0,
  //     'salesRepresentative': 'John Cena',
  //     'dateTime': '2081-05-27T09:05:32'
  //   }
  // ];

  List<Map<String, dynamic>> searchResult = [];

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

  // void runFilter(String enteredKeyWord) {
  //   List<Map<String, dynamic>> resluts = [];
  //   if (enteredKeyWord.isEmpty) {
  //     resluts = visitStats;
  //   } else {
  //     resluts = visitStats
  //         .where((client) => client['client']
  //             .toString()
  //             .toLowerCase()
  //             .contains(enteredKeyWord.toLowerCase()))
  //         .toList();
  //   }
  //   setState(() {
  //     searchResult = resluts;
  //   });
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      // backgroundColor: Colors.amberAccent,
      appBar: _appBar(context),
      drawer: CustomDrawer(
        isVisitActive: true,
      ),
      body: _buildUI(context),
      floatingActionButton: AnimatedBuilder(
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
                  print('dateTime = $formatedDateTime');
                },
                child: Icon(
                  Icons.add,
                  size: 28 + (_animation.value * 5),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomGNavBar(onTap: (value) {}),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomContainer(
              verticalPad: 0,
              color: Colors.transparent,
              child: Consumer<VisitScreenProvider>(
                builder: (context, provider, _) {
                  return TextFromFieldWithPrefixSuffix(
                    controller: searchController,
                    validator: (value) {},
                    onChange: (value) =>
                        provider.runFilter(searchController.value.text),
                    labelText: 'Search',
                    fillColor: Colors.white,
                    applySuffixIcon: true,
                    suffixIcon: Icon(Icons.search),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child:
                Consumer<VisitScreenProvider>(builder: (context, provider, _) {
              provider.searchResult;
              return ListView.builder(
                itemCount: provider.searchResult.length,
                padding: EdgeInsets.only(
                    bottom: 48,
                    top: 8,
                    left: MediaQuery.of(context).size.width * 0.01),
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
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Card(
                      color: Colors.white,
                      elevation: 2,
                      margin: EdgeInsets.all(0),
                      child: CustomContainer(
                        verticalPad: 8,
                        horizontalPad: 0,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
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
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 8.0),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       CustomText(
                            //         text: 'Due amount: ',
                            //         fontWeight: FontWeight.w500,
                            //       ),
                            //       CustomText(
                            //         text: dueAmt.toStringAsFixed(1),
                            //         fontWeight: FontWeight.w500,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
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
            }),
          ),
        ],
      ),
    );
  }
}
