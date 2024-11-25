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
        isHomeActive: true,
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
                tabName: 'Hi, ${userProvider.fullName.split(' ')[0]}',
                centerTitle: false,
                titleColor: CustomColors.primaryBlack,
                backgroundColor: CustomColors.primaryColor,
                showLeading: true,
                isLeadingImage: true,
                imageName: 'assets/images/userLocation.png',
                leadingIconColor: CustomColors.primaryBlack,
                onTapLeadingIcon: () {
                  // Use the context under the Scaffold
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
          CustomContainer(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 60,
                        width: 40,
                        color: CustomColors.primaryColor,
                      ),
                      CustomText(
                        isSubHeading: true,
                          text: 'Today\'s Plans'
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.black,
                  ),
                  CustomText(
                    isSubHeading: true,
                      text: '2024/11/24, Sunday',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: 'Activities'),
                      CustomText(text: 'Marketing Meeting')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: 'Area'),
                      CustomText(text: 'Brt to ')
                    ],
                  )
                ],
              )
          )
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
