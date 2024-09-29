import 'package:deskgoo/providers/settings_providers/profile_provider/officerName_provider.dart';
import 'package:deskgoo/providers/settings_providers/profile_provider/officerdetail_provider.dart';
import 'package:deskgoo/providers/settings_providers/profile_provider/officersDescription_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes/route_generator_constants.dart';
import '../../utils/ScreenWIdth.dart';
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

  @override
  void initState() {
    _marketingProvider = Provider.of<MarketingProvider>(context, listen: false);
    _officerDetailProvider =
        Provider.of<OfficerDetailProvider>(context, listen: false);
    super.initState();
  }

  List<Map<String, dynamic>> officerDescription = [
    {
      "client Name": "John",
      "Address": "Biratnagar",
      "Phone Number": 9819022062,
      "Date Time": "2022-01-15 10:30:00",
    },
    {
      "client Name": "Jane",
      "Address": "Kathmandu",
      "Phone Number": 9845678901,
      "Date Time": "2022-01-16 11:45:00",
    },
    {
      "client Name": "David",
      "Address": "Lalitpur",
      "Phone Number": 9876543210,
      "Date Time": "2022-01-17 12:30:00",
    },
    {
      "client Name": "Michael",
      "Address": "Pokhara",
      "Phone Number": 9898989898,
      "Date Time": "2022-01-18 13:15:00",
    },
    {
      "client Name": "Emily",
      "Address": "Bharatpur",
      "Phone Number": 9874563210,
      "Date Time": "2022-01-19 14:00:00",
    },
    {
      "client Name": "Sarah",
      "Address": "Butwal",
      "Phone Number": 9854321098,
      "Date Time": "2022-01-20 14:45:00",
    }
  ];

  List<String> VisitStatus = [
    "Visited",
    "Visited Other",
    "Visit On Progress",
    "Not Visited",
  ];


  @override
  Widget build(BuildContext context) {
    print('width1 = $screenWidth');
    if (screenWidth < 375) {
      officerDescriptionContainerHeight = 0.88;
    }
    if (screenWidth >= 375 && screenWidth <= 393) {
      officerDescriptionContainerHeight = 0.78;
    }
    if (screenWidth >= 414) {
      officerDescriptionContainerHeight = 0.80;
    }
    if (screenWidth >= 430) {
      officerDescriptionContainerHeight = 0.24;
    }
    // if (screenWidth > 430) {
    //   officerDescriptionContainerHeight = 0.24;
    // }
    if (screenWidth > 500 && screenWidth >= 500) {
      officerDescriptionContainerHeight = 0.18;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        title: CustomText(
          text: 'Visit Summary',
          size: 24,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop(RouteGeneratorConstants.homePage);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Consumer<MarketingProvider>(builder: (context, MarketingProvider, _) {
            return CustomText(
              text: MarketingProvider.name,
              size: 18,
              fontWeight: FontWeight.w600,
            );
          }),
          SizedBox(
            height: 8,
          ),
          Consumer<DetailsProvider>(
            builder: (context,detailsProvider, _) {
              return Expanded(
                child: ListView.builder(
                  itemCount: officerDescription.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    Color containerColor;
                    if (detailsProvider.marketingOfficersDetails[index]['Visit Status'] == VisitStatus[index][0]) {
                      containerColor = CustomColors.lightGreen;
                    } else if (detailsProvider.marketingOfficersDetails[index]['Visit Status'] == VisitStatus[index][1]) {
                      containerColor = CustomColors.lightYellow;
                    } else if (detailsProvider.marketingOfficersDetails[index]['Visit Status'] == VisitStatus[index][2]) {
                      containerColor = CustomColors.lightGrey;
                    } else if (detailsProvider.marketingOfficersDetails[index]['Visit Status'] == VisitStatus[index][3]) {
                      containerColor = CustomColors.lightRed;
                    } else if (detailsProvider.marketingOfficersDetails[index]['Visit Status'] == VisitStatus[index][4]) {
                      containerColor =CustomColors.lightBlue;
                    } else{
                      containerColor = CustomColors.lightGreen;
                    }
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            if (_officerDetailProvider != null) {
                              _officerDetailProvider!.setName(
                                  officerDescription[index]['client Name']);
                              _officerDetailProvider!
                                  .setAddress(officerDescription[index]['Address']);
                              _officerDetailProvider!.setPhoneNumber(
                                  officerDescription[index]['Phone Number']
                                      .toString());
                              _officerDetailProvider!.setDateTime(
                                  officerDescription[index]['Date Time']);
                            }
                            print(officerDescription[index]['client Name']);
                            print(officerDescription[index]['Address']);
                            print(officerDescription[index]['Phone Number']);
                            print(officerDescription[index]['Date Time']);
                            Navigator.of(context).pushNamed(
                                RouteGeneratorConstants.officerVisitDetailPage);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height *
                                officerDescriptionContainerHeight,
                            width: MediaQuery.of(context).size.width * 0.90,
                            decoration: BoxDecoration(
                              color: containerColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: Container(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                            text:
                                                '${officerDescription[index]['client Name']}',
                                            fontWeight: FontWeight.w400),
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 8.0),
                                    child: CustomText(
                                        text:
                                            '${officerDescription[index]['Address']}',
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 8.0),
                                    child: CustomText(
                                        text:
                                            '${officerDescription[index]['Phone Number']}',
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 8.0),
                                    child: CustomText(
                                      text:
                                          '${officerDescription[index]['Date Time']}',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    );
                  },
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}
