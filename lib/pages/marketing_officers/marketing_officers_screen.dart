import 'package:deskgoo/providers/marketing_provider/officerName_provider.dart';
import 'package:deskgoo/providers/marketing_provider/officersDescription_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class MarketingOfficersScreen extends StatefulWidget {
  const MarketingOfficersScreen({super.key});

  @override
  State<MarketingOfficersScreen> createState() =>
      _MarketingOfficersScreenState();
}

class _MarketingOfficersScreenState extends State<MarketingOfficersScreen> {
  MarketingProvider? _marketingProvider;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _marketingProvider = Provider.of<MarketingProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        Navigator.of(context).pop(RouteGeneratorConstants.homePage);
      }),
      child: Scaffold(
        backgroundColor: CustomColors.primaryWhite,
        appBar: _appBar(context),
        body: _buildUI(context),
        // bottomNavigationBar: _bottomNavBar(context),
      ),
    );
  }

  CustomGNavBar _bottomNavBar(context) {
    return CustomGNavBar(
      selectedIndex: index,
      onTap: (value) {
        index = value;
        print(index);
      },
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) => CustomAppBar(
          tabName: 'Marketing Officers',
          titleColor: CustomColors.primaryBlack,
          backgroundColor: CustomColors.primaryColor,
          size: 24,
          showLeading: true,
          leadingIcon: FontAwesomeIcons.arrowLeft,
          leadingIconColor: CustomColors.primaryBlack,
          onTapLeadingIcon: () {
            Navigator.of(context).pop(RouteGeneratorConstants.homePage);
          },
        ),
      ),
    );
  }

  Widget _buildUI(context) {
    return Consumer<DetailsProvider>(
      builder: (context, detailsProvider, _) {
        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
          },
          color: CustomColors.primaryColor,
          backgroundColor: Colors.white,
          child: ListView(
            children: [
              SizedBox(
                height: 8,
              ),
              ListView.builder(
                itemCount: detailsProvider.marketingOfficersDetails.length,
                shrinkWrap:
                    true, // This allows it to take only the required height
                physics:
                    NeverScrollableScrollPhysics(), // Disables scrolling for outer ListView, so the inner ListViews can handle scrolling
                itemBuilder: (context, index) {
                  double indicatorValue = detailsProvider
                          .marketingOfficersDetails[index]['achieved'] /
                      detailsProvider.marketingOfficersDetails[index]['target'];
                  int target =
                      detailsProvider.marketingOfficersDetails[index]['target'];
                  int achived = detailsProvider.marketingOfficersDetails[index]
                      ['achieved'];
                  String name = detailsProvider.marketingOfficersDetails[index]
                      ['OfficerName'];
                  int battery = detailsProvider.marketingOfficersDetails[index]
                      ['batteryLevel'];
                  String connectivityType = detailsProvider
                      .marketingOfficersDetails[index]['connectivityType'];
                  int travelled = detailsProvider
                      .marketingOfficersDetails[index]['totalTravel'];
                  bool isApproved = detailsProvider
                      .marketingOfficersDetails[index]['isApproved'];
                  return InkWell(
                    onTap: () {
                      _marketingProvider!.setName(name);
                      detailsProvider.setSelectedOfficerVisitDetails(index);
                      print(detailsProvider.visitDetails);
                      Navigator.of(context).pushNamed(
                          RouteGeneratorConstants.officerDescriptionPage);
                    },
                    child: CustomContainer(
                      color: Colors.white,
                      verticalPad: 8,
                      horizontalPad: 8,
                      verticalMargin: 8,
                      horizontalMargin: 12,
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Consumer<DetailsProvider>(
                                  builder: (context, marketingProvider, _) {
                                    return CustomText(
                                      text: name,
                                      fontWeight: FontWeight.w600,
                                      color: CustomColors.primaryBlack,
                                      size: 18,
                                      // color: Colors.grey.shade600,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Transform.rotate(
                                          angle: 180 * math.pi / 90,
                                          child: FaIcon(
                                            battery > 85
                                                ? FontAwesomeIcons.batteryFull
                                                : battery > 65
                                                    ? FontAwesomeIcons
                                                        .batteryThreeQuarters
                                                    : battery > 40
                                                        ? FontAwesomeIcons
                                                            .batteryHalf
                                                        : battery > 15
                                                            ? FontAwesomeIcons
                                                                .batteryQuarter
                                                            : FontAwesomeIcons
                                                                .batteryEmpty,
                                            color: battery > 65
                                                ? Colors.green
                                                : battery > 40
                                                    ? Colors.lightGreen
                                                    : battery > 10
                                                        ? Colors.deepOrange
                                                        : battery < 10
                                                            ? Colors.red
                                                            : Colors.blue,
                                          ),
                                        ),
                                        CustomText(
                                          text: ' $battery %',
                                          fontWeight: FontWeight.w600,
                                          color: CustomColors.primaryBlack,
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      connectivityType == 'mobile'
                                          ? Icons.network_cell
                                          : Icons.wifi,
                                      color: Colors.green,
                                    ),
                                    CustomText(
                                      text: '$travelled km',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: LinearProgressIndicator(
                                        value: indicatorValue,
                                        backgroundColor: Colors.grey.shade300,
                                        color: CustomColors.primaryColor,
                                        minHeight: 6,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    CustomText(
                                      text:
                                          '${achived < 10 ? '0$achived' : achived}/$target',
                                      fontWeight: FontWeight.w600,
                                      color: CustomColors.primaryBlack,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            right: 8,
                            top: 0,
                            child: InkWell(
                              onTap: () {
                                print(index);
                                detailsProvider
                                    .setSelectedOfficerVisitDetails(index);
                                detailsProvider.setOfficerVisitApprovals(false);
                              },
                              child: SizedBox(
                                height: 22,
                                width: 22,
                                child: Image.asset(
                                  isApproved
                                      ? 'assets/images/badgeApproved.png'
                                      : 'assets/images/badgeUnapproved.png',
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
                height: 24,
              ),
            ],
          ),
        );
      },
    );
  }
}
