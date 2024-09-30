import 'package:deskgoo/providers/settings_providers/profile_provider/officerName_provider.dart';
import 'package:deskgoo/providers/settings_providers/profile_provider/officerdetail_provider.dart';
import 'package:deskgoo/providers/settings_providers/profile_provider/officersDescription_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_providers/profile_provider/officerName_provider.dart';
import '../../providers/settings_providers/profile_provider/officerName_provider.dart';
import '../../routes/route_generator_constants.dart';
import '../../utils/ScreenWIdth.dart';
import '../../widgets/app_bars/custom_app_bars.dart';
import '../../widgets/containers/custom_container.dart';
import 'officer_VisitDetailPage.dart';

class OfficerDescriptionPage extends StatefulWidget {
  const OfficerDescriptionPage({super.key});

  @override
  State<OfficerDescriptionPage> createState() => _OfficerDescriptionPageState();
}

class _OfficerDescriptionPageState extends State<OfficerDescriptionPage> {
  double screenHeight = ScreenUtil.getScreenHeight();
  double screenWidth = ScreenUtil.getScreenWidth();
  double officerDescriptionContainerHeight = 0.0;
  MarketingProvider? _marketingProvider;
  bool isChecked = false;
  OfficerDetailProvider? _officerDetailProvider;
  int? selectedIndex = 0;
  FontWeight textFontWeight = FontWeight.w500;
  List<bool> isCheckedList = [];
  List<Map<String, dynamic>> officerDescription = [
    {
      "client Name": "Ram Shah",
      "Address": "Biratnagar, Airport-Road",
      "Phone Number": 9819022062,
      "Date Time": "2022-01-15 / 10:30 PM",
    },
    {
      "client Name": "Rajesh Biswakarma",
      "Address": "Kathmandu, New Baneshwor",
      "Phone Number": 9845678901,
      "Date Time": "2022-01-16 / 11:45 AM",
    },
    {
      "client Name": "Abhijeet Yadav ",
      "Address": "Lalitpur, Jhansi Road",
      "Phone Number": 9876543210,
      "Date Time": "2022-01-17 / 12:30 PM",
    },
    {
      "client Name": "Rohan Bhattrai",
      "Address": "Lakeside Rd, Pokhara",
      "Phone Number": 9898989898,
      "Date Time": "2022-01-18 / 1:15 PM",
    },
    {
      "client Name": "Milan Biswas",
      "Address": "NGO Rd, Bharatpur",
      "Phone Number": 9874563210,
      "Date Time": "2022-01-19 / 2:00 PM",
    },
    {
      "client Name": "Siman Malla",
      "Address": ": Milanchwok,Butwal",
      "Phone Number": 9854321098,
      "Date Time": "2022-01-20 / 2:45 PM",
    }
  ];
  List<String> VisitStatus = [
    "Visited",
    "Visited Other",
    "Visit On Progress",
    "Not Visited",
  ];


  @override
  void initState() {
    _marketingProvider = Provider.of<MarketingProvider>(context, listen: false);
    _officerDetailProvider =
        Provider.of<OfficerDetailProvider>(context, listen: false);
    isCheckedList = List<bool>.filled(officerDescription.length, false);
    super.initState();
  }

  // @override
  // Widget _listView(BuildContext context){
  //   return Consumer<DetailsProvider>(builder: (context,detailsProvider, _)){
  //     return ListView()
  //
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _buildUI(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) => CustomAppBar(
          tabName: 'Visit Summary',
          titleColor: CustomColors.primaryBlack,
          backgroundColor: CustomColors.primaryColor,
          showLeading: true,
          leadingIcon: FontAwesomeIcons.arrowLeft,
          leadingIconColor: CustomColors.primaryBlack,
          onTapLeadingIcon: () {
            // Use the context under the Scaffold
            print('hello');
            Navigator.of(context).pop(RouteGeneratorConstants.homePage);
          },
        ),
      ),
    );
  }

  Widget _buildUI(context) {
    return Consumer(builder: (context, marketingProvider, _) {
      return ListView(
        children: [
          CustomContainer(
            color: Colors.white,
            verticalMargin: 0,
            verticalPad: 12,
            horizontalMargin: 8,
            horizontalPad: 0,
            child: Column(
              children: [
                CustomContainer(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person),
                                CustomText(text: 'hello'),
                                Spacer(),
                                Checkbox(
                                    activeColor: Colors.blue,
                                    value: isChecked,
                                    onChanged: (value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                    })
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      );
    });
  }

  // @override
  // Widget build2(BuildContext context) {
  //   Color containerColor;
  //   print('width1 = $screenWidth');
  //   if (screenWidth < 375) {
  //     officerDescriptionContainerHeight = 0.88;
  //   }
  //   if (screenWidth >= 375 && screenWidth <= 393) {
  //     officerDescriptionContainerHeight = 0.78;
  //   }
  //   if (screenWidth >= 414) {
  //     officerDescriptionContainerHeight = 0.80;
  //   }
  //   if (screenWidth >= 430) {
  //     officerDescriptionContainerHeight = 0.24;
  //   }
  //   if (screenWidth >= 500) {
  //     officerDescriptionContainerHeight = 0.28;
  //   }
  //   if (screenWidth > 500) {
  //     officerDescriptionContainerHeight = 0.18;
  //   }
  //
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: CustomColors.primaryColor,
  //       title: CustomText(
  //         text: 'Visit Summary',
  //         size: 24,
  //         fontWeight: FontWeight.w600,
  //       ),
  //       centerTitle: true,
  //       leading: InkWell(
  //         onTap: () {
  //           Navigator.of(context).pop(RouteGeneratorConstants.homePage);
  //         },
  //         child: Icon(Icons.arrow_back),
  //       ),
  //     ),
  //     body: Consumer<DetailsProvider>(builder: (context, MarketingProvider, _) {
  //       return ListView(
  //         children: [
  //           CustomContainer(
  //             child: Column(
  //               children: [
  //                 // Consumer<MarketingProvider>(builder: (context, marketingProvider, _) {
  //                 //   return CustomText(
  //                 //     text: marketingProvider!.name,
  //                 //     size: 18,
  //                 //     fontWeight:textFontWeight,
  //                 //   );
  //                 // }),
  //                 // SizedBox(
  //                 //   height: 16,
  //                 // ),
  //                 Consumer<DetailsProvider>(
  //                     builder: (context, detailsProvider, _) {
  //                   return Expanded(
  //                     child: ListView.builder(
  //                       itemCount: officerDescription.length,
  //                       scrollDirection: Axis.vertical,
  //                       itemBuilder: (context, index) {
  //                         Color containerColor;
  //                         String visitStatus = detailsProvider
  //                             .marketingOfficersDetails[index]['Visit Status'];
  //                         if (visitStatus == VisitStatus[0]) {
  //                           containerColor = CustomColors.lightGreen;
  //                         } else if (visitStatus == VisitStatus[1]) {
  //                           containerColor = CustomColors.lightYellow;
  //                         } else if (visitStatus == VisitStatus[2]) {
  //                           containerColor = CustomColors.lightGrey;
  //                         } else if (visitStatus == VisitStatus[3]) {
  //                           containerColor = CustomColors.lightRed;
  //                         } else {
  //                           containerColor = CustomColors.lightBlue;
  //                         }
  //                         ;
  //                         return Column(
  //                           children: [
  //                             InkWell(
  //                               onTap: () {
  //                                 if (_officerDetailProvider != null) {
  //                                   _officerDetailProvider!.setName(
  //                                       officerDescription[index]
  //                                           ['client Name']);
  //                                   _officerDetailProvider!.setAddress(
  //                                       officerDescription[index]['Address']);
  //                                   _officerDetailProvider!.setPhoneNumber(
  //                                       officerDescription[index]
  //                                               ['Phone Number']
  //                                           .toString());
  //                                   _officerDetailProvider!.setDateTime(
  //                                       officerDescription[index]['Date Time']);
  //                                 }
  //                                 Navigator.of(context).pushNamed(
  //                                     RouteGeneratorConstants
  //                                         .officerVisitDetailPage);
  //                               },
  //                               child: Container(
  //                                 height: MediaQuery.of(context).size.height *
  //                                     officerDescriptionContainerHeight,
  //                                 width:
  //                                     MediaQuery.of(context).size.width * 0.90,
  //                                 decoration: BoxDecoration(
  //                                   color: containerColor,
  //                                   borderRadius: BorderRadius.all(
  //                                     Radius.circular(10),
  //                                   ),
  //                                 ),
  //                                 child: Container(
  //                                   padding: EdgeInsets.symmetric(
  //                                       horizontal: 16, vertical: 8),
  //                                   child: Column(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.start,
  //                                     children: [
  //                                       Row(
  //                                         children: [
  //                                           Icon(
  //                                             Icons.person,
  //                                           ),
  //                                           Padding(
  //                                             padding:
  //                                                 const EdgeInsets.symmetric(
  //                                                     vertical: 8.0,
  //                                                     horizontal: 8.0),
  //                                             child: CustomText(
  //                                                 text:
  //                                                     '${officerDescription[index]['client Name']}', fontWeight: textFontWeight),
  //                                           ),
  //                                           Spacer(),
  //                                           Checkbox(
  //                                               activeColor: Colors.blue,
  //                                               value: isCheckedList[index],
  //                                               onChanged: (value) {
  //                                                 setState(() {
  //                                                   isCheckedList[index] =
  //                                                       value!;
  //                                                 });
  //                                               })
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         children: [
  //                                           Icon(
  //                                             FontAwesomeIcons.locationArrow,
  //                                             size: 20,
  //                                           ),
  //                                           Padding(
  //                                             padding:
  //                                                 const EdgeInsets.symmetric(
  //                                                     vertical: 8.0,
  //                                                     horizontal: 8.0),
  //                                             child: CustomText(
  //                                                 text:
  //                                                     '${officerDescription[index]['Address']}',
  //                                                 fontWeight: textFontWeight),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         children: [
  //                                           Icon(
  //                                             FontAwesomeIcons.phone,
  //                                             size: 20,
  //                                           ),
  //                                           Padding(
  //                                             padding:
  //                                                 const EdgeInsets.symmetric(
  //                                                     vertical: 8.0,
  //                                                     horizontal: 8.0),
  //                                             child: CustomText(
  //                                                 text:
  //                                                     '${officerDescription[index]['Phone Number']}',
  //                                                 fontWeight: textFontWeight),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         children: [
  //                                           Icon(FontAwesomeIcons.calendar,
  //                                               size: 20),
  //                                           Padding(
  //                                             padding:
  //                                                 const EdgeInsets.symmetric(
  //                                                     vertical: 8.0,
  //                                                     horizontal: 8.0),
  //                                             child: CustomText(
  //                                               text:
  //                                                   '${officerDescription[index]['Date Time']}',
  //                                               fontWeight: textFontWeight,
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                             SizedBox(
  //                               height: 8,
  //                             ),
  //                           ],
  //                         );
  //                       },
  //                     ),
  //                   );
  //                 }),
  //               ],
  //             ),
  //           ),
  //         ],
  //       );
  //     }),
  //   );
  // }
}
