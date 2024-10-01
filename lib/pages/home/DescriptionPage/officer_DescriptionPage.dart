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
  FontWeight textFontWeight = FontWeight.w500;
  List<bool> isCheckedList = [];
  List<Color> containerColors = [];
  List<Map<String, dynamic>> officerDescription = [
    {
      'clientName': 'Ram Shah',
      'address': 'Biratnagar, Airport-Road',
      'phoneNumber': 9819022062,
      'dateTime': '2022-01-15 / 10:30 PM',
      'visitStatus': 'visited',
    },
    {
      'clientName': 'Rajesh Biswakarma',
      'address': 'Kathmandu, New Baneshwor',
      'phoneNumber': 9845678901,
      'dateTime': '2022-01-16 / 11:45 AM',
      'visitStatus': 'visited',
    },
    {
      'clientName': 'Abhijeet Yadav ',
      'address': 'Lalitpur, Jhansi Road',
      'phoneNumber': 9876543210,
      'dateTime': '2022-01-17 / 12:30 PM',
      'visitStatus': 'visitedOthers',
    },
    {
      'clientName': 'Rohan Bhattrai',
      'address': 'Lakeside Rd, Pokhara',
      'phoneNumber': 9898989898,
      'dateTime': '2022-01-18 / 1:15 PM',
      'visitStatus': 'visitedOthers',
    },
    {
      'clientName': 'Milan Biswas',
      'address': 'NGO Rd, Bharatpur',
      'phoneNumber': 9874563210,
      'dateTime': '2022-01-19 / 2:00 PM',
      'visitStatus': 'visitOnProgress',
    },
    {
      'clientName': 'Siman Malla',
      'address': 'Milanchwok,Butwal',
      'phoneNumber': 9854321098,
      'dateTime': '2022-01-20 / 2:45 PM',
      'visitStatus': 'notVisited',
    }
  ];
  List<String> VisitStatus = [
    'visited',
    'visitedOthers',
    'visitOnProgress',
    'notVisited',
  ];
  bool? isCheck = false;

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
          size: 24,
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

  @override
  void initState() {
    _marketingProvider = Provider.of<MarketingProvider>(context, listen: false);
    _officerDetailProvider =
        Provider.of<OfficerDetailProvider>(context, listen: false);
    isCheckedList = List<bool>.filled(officerDescription.length, false);
    containerColors =
        List<Color>.filled(officerDescription.length, CustomColors.lightBlue);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: marketingProvider.name,
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
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
                    String visitStatus =
                        officerDescription[index]['visitStatus'];
                    Color containerColor = visitStatus == 'visited'
                        ? CustomColors.lightBlue
                        : visitStatus == 'visitedOthers'
                            ? CustomColors.lightYellow
                            : visitStatus == 'visitOnProgress'
                                ? CustomColors.lightGrey
                                : CustomColors.lightRed;
                    if (visitStatus == VisitStatus[0]) {
                      containerColor = CustomColors.lightBlue;
                    } else if (visitStatus == VisitStatus[1]) {
                      containerColor = CustomColors.lightYellow;
                    } else if (visitStatus == VisitStatus[2]) {
                      containerColor = CustomColors.lightGrey;
                    } else if (visitStatus == VisitStatus[3]) {
                      containerColor = CustomColors.lightRed;
                    } else {
                      containerColor = CustomColors.lightBlue;
                    }
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
                            }
                            Navigator.of(context).pushNamed(
                                RouteGeneratorConstants.officerVisitDetailPage);
                          },
                          child: CustomContainer(
                            horizontalMargin: 16,
                            verticalMargin: 4,
                            color: containerColors[index],
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 8.0),
                                      child: CustomText(
                                          text:
                                              '${officerDescription[index]['clientName']}',
                                          fontWeight: textFontWeight),
                                    ),
                                    Spacer(),
                                    Checkbox(
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
                                                  containerColor;
                                            }
                                          },
                                        );
                                      },
                                    )
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
                                          vertical: 8.0, horizontal: 8.0),
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
                                          vertical: 8.0, horizontal: 8.0),
                                      child: CustomText(
                                          text:
                                              '${officerDescription[index]['phoneNumber']}',
                                          fontWeight: textFontWeight),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(FontAwesomeIcons.calendar, size: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 8.0),
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
                          ),
                        ),
                        // SizedBox(height: 8), // Adds gap between containers
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
