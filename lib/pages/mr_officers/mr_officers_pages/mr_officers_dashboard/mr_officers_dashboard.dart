import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drawers/mr_officer_custom_drawer.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../../../../providers/login_provider/login_provider.dart';

class MrOfficersDashboardScreen extends StatefulWidget {
  const MrOfficersDashboardScreen({super.key});

  @override
  State<MrOfficersDashboardScreen> createState() =>
      _MrOfficersDashboardScreenState();
}

class _MrOfficersDashboardScreenState extends State<MrOfficersDashboardScreen> {
  List<String> colors = ['red', 'yellow', 'green'];
  String SelectedColors = '';
  int selectedIndex = 0;
  void result() async {
    final String jsonString =
        await rootBundle.loadString('assets/district.json');
    print(jsonString);
    // Decode the JSON
    // final List<dynamic> jsonData = jsonDecode(jsonString);
    // Print the parsed data
    // for (var district in jsonData) {
    //   print('District: ${district['district']}');
    //   print('Cities: ${district['cities']}');
    // }
  }

  Future<List<Map<String, dynamic>>> readDistrictJson() async {
    // Load the JSON file from the assets
    final String response = await rootBundle.loadString('assets/district.json');

    // Decode the JSON into a List of Maps
    final List<dynamic> data = json.decode(response);
    return List<Map<String, dynamic>>.from(data);
  }

  void loadData() async {
    final districts = await readDistrictJson();
    print(districts);
  }

  @override
  void initState() {
    // result();
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(context),
      body: _body(context),
      drawer: MrOfficerCustomDrawer(
        isWeeklyPlanActive: true,
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) =>
            Consumer<UserProvider>(builder: (context, userProvider, _) {
              return CustomAppBar(
                tabName: 'Hi, Ronak ${userProvider.fullName.split(' ')[0]}',
                centerTitle: false,
                titleColor: CustomColors.primaryBlack,
                backgroundColor: CustomColors.primaryColor,
                showLeading: true,
                isLeadingImage: true,
                imageName: 'assets/images/userLocation.png',
                leadingIconColor: CustomColors.primaryBlack,
                onTap: () {
                  // Use the context under the Scaffold
                  print('hello');
                  Scaffold.of(context).openDrawer();
                },
              );
            }),
      ),
    );
  }

  Widget _body(context) {
    return SafeArea(
      child: Column(
        children: [
          // CarouselSlider.builder(
          //   options: CarouselOptions(
          //     height: 200,
          //     enlargeCenterPage: true,
          //     enlargeStrategy: CenterPageEnlargeStrategy.height,
          //     onPageChanged: (index, reason) => setState(() {
          //       selectedIndex = index;
          //     }),
          //   ),
          //   itemCount: colors.length,
          //   itemBuilder: (BuildContext context, index, int realIndex) {
          //     SelectedColors = colors[index];
          //     return Container(
          //       width: MediaQuery.of(context).size.width * 0.75,
          //       decoration: BoxDecoration(
          //           color: CustomColors.primaryColor,
          //           borderRadius: BorderRadius.circular(16)),
          //       child: Center(child: CustomText(text: colors[index])),
          //     );
          //   },
          // ),
          // buildIndicator(),
          // CustomContainer(
          //   horizontalPad: 8,
          //   child: Column(
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Expanded(
          //             flex: 1,
          //             child: CustomText(
          //               text: 'Area',
          //               isContent: true,
          //             ),
          //           ),
          //           Expanded(
          //             flex: 1,
          //             child: CustomText(
          //               text:
          //                   'Brt To Ghuski, Harinagra, Bhutha, Debangunj, Chimdi',
          //               isContent: true,
          //               textOverflow: TextOverflow.ellipsis,
          //               maxLines: 3,
          //             ),
          //           )
          //         ],
          //       ),
          //       SizedBox(
          //         height: 8,
          //       ),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Expanded(
          //             flex: 1,
          //             child: CustomText(
          //               text: 'Remarks',
          //               isContent: true,
          //             ),
          //           ),
          //           Expanded(
          //             flex: 1,
          //             child: CustomText(
          //               text:
          //                   'Hospital, Pharmacy, Police, Ref. Person, Ambulance',
          //               isContent: true,
          //               textOverflow: TextOverflow.ellipsis,
          //               maxLines: 3,
          //             ),
          //           )
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(height: 16,),
          CustomContainer(
              horizontalPad: 0,
              horizontalMargin: 16,
              applyShadow: true,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 36,
                        width: 10,
                        decoration: BoxDecoration(
                          color: CustomColors.primaryColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      SizedBox(width: 8,),
                      CustomText(
                        isSubHeading: true,
                          text: 'Today\'s Plans'
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.black,
                  ),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomText(
                          isSubHeading: true,
                            text: '2024/11/24, Sunday',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: CustomText(text: 'Activities',size: 18,fontWeight: FontWeight.w600,)),
                            Expanded(child: CustomText(text: 'Marketing Meeting',size: 18,fontWeight: FontWeight.w600,))
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: CustomText(text: 'Area',size: 18,fontWeight: FontWeight.w600,)),
                            Expanded(
                              child: CustomText(
                                  maxLines: 3,
                                  textOverflow: TextOverflow.visible,
                                  text: 'Brt to Ghuski, Harinagar, Bhutha,abcd',size: 18,fontWeight: FontWeight.w600,),
                            )
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: CustomText(text: 'Remarks',size: 18,fontWeight: FontWeight.w600,)),
                            Expanded(
                              child: CustomText(
                                  maxLines: 4,
                                  textOverflow: TextOverflow.visible,
                                  text: 'All Marketing Officer & Hospital CEO',size: 18,fontWeight: FontWeight.w600,),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
          ),
          SizedBox(height: 16,),
          CustomContainer(
              horizontalPad: 0,
              horizontalMargin: 16,
              applyShadow: true,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 36,
                        width: 10,
                        decoration: BoxDecoration(
                          color: CustomColors.primaryColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      SizedBox(width: 8,),
                      CustomText(
                          isSubHeading: true,
                          text: 'Attendance',
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.black,
                  ),
                  SizedBox(height: 8,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: CustomText(text: 'Status',size: 18,fontWeight: FontWeight.w600,)),
                            Expanded(child: CustomText(text: 'Checked-in',size: 18,fontWeight: FontWeight.w600,))
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: CustomText(text: 'Check-in Time',size: 18,fontWeight: FontWeight.w600,)),
                            Expanded(
                              child: CustomText(
                                text: '09:05 24/11/2024',size: 18,fontWeight: FontWeight.w600,),
                            )
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: CustomText(text: 'Total Time',size: 18,fontWeight: FontWeight.w600,)),
                            Expanded(
                              child: CustomText(
                                text: '04:25 hours',size: 18,fontWeight: FontWeight.w600,),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
          ),
          SizedBox(height: 16,),
          CustomContainer(
              horizontalPad: 0,
              horizontalMargin: 16,
              applyShadow: true,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 36,
                        width: 10,
                        decoration: BoxDecoration(
                          color: CustomColors.primaryColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      SizedBox(width: 8,),
                      CustomText(
                        isSubHeading: true,
                        text: 'Visit Today',
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.black,
                  ),
                  SizedBox(height: 8,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(text: 'Today\'s Total Visit',size: 18,fontWeight: FontWeight.w600,),
                            CustomText(
                              maxLines: 3,
                              textOverflow: TextOverflow.clip,
                              text: '08',size: 18,fontWeight: FontWeight.w600,)
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(text: 'Average Visit',size: 18,fontWeight: FontWeight.w600,),
                            CustomText(
                              maxLines: 4,
                              textOverflow: TextOverflow.clip,
                              text: '09',size: 18,fontWeight: FontWeight.w600,)
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }

//   Widget buildIndicator() => AnimatedSmoothIndicator(
//         activeIndex: selectedIndex,
//         count: colors.length,
//         effect: WormEffect(
//           activeDotColor: CustomColors.primaryColor,
//           dotColor: Colors.grey,
//         ),
//       );
}
