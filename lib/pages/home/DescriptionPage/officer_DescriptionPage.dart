import 'package:deskgoo/providers/marketing_provider/officerName_provider.dart';
import 'package:deskgoo/providers/marketing_provider/officerdetail_provider.dart';
import 'package:deskgoo/providers/marketing_provider/officersDescription_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../providers/marketing_provider/officerName_provider.dart';
import '../../../providers/marketing_provider/officerName_provider.dart';
import '../../../routes/route_generator_constants.dart';
import '../../../utils/ScreenWIdth.dart';
import '../../../widgets/app_bars/custom_app_bars.dart';
import '../../../widgets/containers/custom_container.dart';
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
  FontWeight textFontWeight = FontWeight.w600;
  List<bool> isCheckedList = [];
  List<Color> containerColors = [];
  List<Color> initialContainerColors = [];
  List<Map<String, dynamic>> officerDescription = [
    {
      'clientName': 'Ram Shah',
      'address': 'Biratnagar, Airport-Road',
      'phoneNumber': 9819022062,
      'dateTime': '2022-01-15 / 10:30 PM',
      'visitStatus': 'visited',
      'notes':
          'I visited Mr Ram Shah in the morning and he was suffering from fever.',
    },
    {
      'clientName': 'Rajesh Biswakarma',
      'address': 'Kathmandu, New Baneshwor',
      'phoneNumber': 9845678901,
      'dateTime': '2022-01-16 / 11:45 AM',
      'visitStatus': 'visited',
      'notes':
          'I visited Mr Rajesh Biswakarma\'s house in the morning and he was not available',
    },
    {
      'clientName': 'Abhijeet Yadav ',
      'address': 'Lalitpur, Jhansi Road',
      'phoneNumber': 9876543210,
      'dateTime': '2022-01-17 / 12:30 PM',
      'visitStatus': 'visitedOthers',
      'notes':
          'I visited Mr Abhijeet Yadav house in the afternoon and he was not available in the house his wife said me to come back tomorrow',
    },
    {
      'clientName': 'Rohan Bhattrai',
      'address': 'Lakeside Rd, Pokhara',
      'phoneNumber': 9898989898,
      'dateTime': '2022-01-18 / 1:15 PM',
      'visitStatus': 'visitedOthers',
      'notes':
          'I visited Mr Abhijeet Yadav house in the afternoon and he was not available in the house his wife said me to come back tomorrow',
    },
    {
      'clientName': 'Milan Biswas',
      'address': 'NGO Rd, Bharatpur',
      'phoneNumber': 9874563210,
      'dateTime': '2022-01-19 / 2:00 PM',
      'visitStatus': 'visitOnProgress',
      'notes':
          'I visited Mr Milan Biswas house in the afternoon and he was available in the house he will be visiting hospital tomorrow',
    },
    {
      'clientName': 'Siman Malla',
      'address': 'Milanchwok,Butwal',
      'phoneNumber': 9854321098,
      'dateTime': '2022-01-20 / 2:45 PM',
      'visitStatus': 'notVisited',
      'notes':
          'I visited Mr Siman Malla house in the afternoon and he was not available in the house.',
    }
  ];
  List<String> VisitStatus = [
    'visited',
    'visitedOthers',
    'visitOnProgress',
    'notVisited',
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        Navigator.of(context).pop(RouteGeneratorConstants.marketingOfficers);
      }),
      child: Scaffold(
        appBar: _appBar(context),
        body: _buildUI(context),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Consumer<MarketingProvider>(
        builder: (context, marketingProvider, _) => CustomAppBar(
          tabName: '${marketingProvider.name}',
          titleColor: CustomColors.primaryBlack,
          size: 24,
          backgroundColor: CustomColors.primaryColor,
          showLeading: true,
          leadingIcon: FontAwesomeIcons.arrowLeft,
          leadingIconColor: CustomColors.primaryBlack,
          showTrailingIcons: true,
          showApproveButton: true,
          onTapTrailingApproveIcon: () {
            print(isCheckedList.length);
            Navigator.of(context)
                .pushNamed(RouteGeneratorConstants.marketingOfficers);
          },
          onTapLeadingIcon: () {
            // Use the context under the Scaffold
            Navigator.of(context).pop(RouteGeneratorConstants.homePage);
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    _marketingProvider = Provider.of<MarketingProvider>(context, listen: false);
    _officerDetailProvider =
        Provider.of<OfficerDetailProvider>(context, listen: false);
    isCheckedList = List<bool>.filled(officerDescription.length, false);
    initialContainerColors = officerDescription.map((officer) {
      String visitStatus = officer['visitStatus'];
      if (visitStatus == VisitStatus[0]) {
        return CustomColors.lightBlue;
      } else if (visitStatus == VisitStatus[1]) {
        return CustomColors.lightYellow;
      } else if (visitStatus == VisitStatus[2]) {
        return CustomColors.lightGrey;
      } else if (visitStatus == VisitStatus[3]) {
        return CustomColors.lightRed;
      } else {
        return CustomColors.lightBlue;
      }
    }).toList();
    containerColors = List.from(initialContainerColors);
    super.initState();
  }

  Widget _buildUI(context) {
    return Consumer<MarketingProvider>(
      builder: (context, marketingProvider, _) {
        return ListView(
          children: [
            SizedBox(
              height: 8,
            ),
            Consumer<DetailsProvider>(
              builder: (context, detailsProvider, _) {
                return ListView.builder(
                  // physics: const AlwaysScrollableScrollPhysics(),
                  // scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: officerDescription.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Color containerColor;
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            if (_officerDetailProvider != null) {
                              _officerDetailProvider!.setName(
                                  officerDescription[index]['clientName']);
                              _officerDetailProvider!.setAddress(
                                  officerDescription[index]['address']);
                              _officerDetailProvider!.setPhoneNumber(
                                  officerDescription[index]['phoneNumber']
                                      .toString());
                              _officerDetailProvider!.setDateTime(
                                  officerDescription[index]['dateTime']);
                              _officerDetailProvider!
                                  .setNotes(officerDescription[index]['notes']);
                            }
                            Navigator.of(context).pushNamed(
                                RouteGeneratorConstants.officerVisitDetailPage);
                          },
                          child: CustomContainer(
                            horizontalMargin: 16,
                            verticalMargin: 4,
                            color: containerColors[
                                index], // Assigned based on status
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(Icons.person),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0, horizontal: 8.0),
                                          child: CustomText(
                                            text:
                                                '${officerDescription[index]['clientName']}',
                                            fontWeight: FontWeight.w600,
                                            size: 18,
                                          ),
                                        ),
                                        // Spacer(),
                                        // Checkbox(
                                        //   activeColor: Colors.blue,
                                        //   value: isCheckedList[index],
                                        //   onChanged: (value) {
                                        //     setState(
                                        //       () {
                                        //         isCheckedList[index] = value!;
                                        //         if (isCheckedList[index]) {
                                        //           containerColors[index] =
                                        //               CustomColors.lightGreen;
                                        //         } else {
                                        //           containerColors[index] =
                                        //               initialContainerColors[
                                        //                   index];
                                        //         }
                                        //       },
                                        //     );
                                        //   },
                                        // )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.locationArrow,
                                          size: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0, horizontal: 8.0),
                                          child: CustomText(
                                              text:
                                                  '${officerDescription[index]['address']}',
                                              fontWeight: textFontWeight),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.phone,
                                          size: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0, horizontal: 8.0),
                                          child: CustomText(
                                              text:
                                                  '${officerDescription[index]['phoneNumber']}',
                                              fontWeight: textFontWeight),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(FontAwesomeIcons.calendarAlt,
                                            size: 20),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0, horizontal: 8.0),
                                          child: CustomText(
                                            text:
                                                '${officerDescription[index]['dateTime']}',
                                            fontWeight: textFontWeight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Checkbox(
                                    activeColor: Colors.blue,
                                    value: isCheckedList[index],
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          isCheckedList[index] = value!;
                                          if (isCheckedList[index]) {
                                            containerColors[index] =
                                                CustomColors.lightGreen;
                                          } else {
                                            containerColors[index] =
                                                initialContainerColors[index];
                                          }
                                        },
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
