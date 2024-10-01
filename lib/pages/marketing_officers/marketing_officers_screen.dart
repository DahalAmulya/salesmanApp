import 'package:deskgoo/providers/settings_providers/profile_provider/officerName_provider.dart';
import 'package:deskgoo/providers/settings_providers/profile_provider/officersDescription_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(context),
      body: _buildUI(context),
      bottomNavigationBar: _bottomNavBar(context),
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
    return Consumer<DetailsProvider>(builder: (context, marketingProvider, _) {
      return ListView(
        children: [
          SizedBox(
            height: 16,
          ),
          ListView.builder(
            itemCount: marketingProvider.marketingOfficersDetails.length,
            shrinkWrap: true, // This allows it to take only the required height
            physics:
                NeverScrollableScrollPhysics(), // Disables scrolling for outer ListView, so the inner ListViews can handle scrolling
            itemBuilder: (context, index) {
              double indicatorValue = marketingProvider
                      .marketingOfficersDetails[index]['achieved'] /
                  marketingProvider.marketingOfficersDetails[index]['target'];
              return InkWell(
                onTap: () {
                  _marketingProvider!.setName(marketingProvider
                      .marketingOfficersDetails[index]['OfficerName']);
                  // print(marketingOfficersName[index]['OfficerName']);
                  Navigator.of(context).pushNamed(
                      RouteGeneratorConstants.officerDescriptionPage);
                },
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 4),
                        child: Consumer<DetailsProvider>(
                            builder: (context, marketingProvider, _) {
                          return CustomText(
                            text: marketingProvider
                                .marketingOfficersDetails[index]['OfficerName'],
                            fontWeight: FontWeight.bold,
                            color: CustomColors.primaryBlack,
                            // color: Colors.grey.shade600,
                          );
                        }),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: LinearProgressIndicator(
                                value: indicatorValue,
                                backgroundColor: Colors.white,
                                color: CustomColors.primaryColor,
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Text(
                              '${marketingProvider.marketingOfficersDetails[index]['achieved']}/${marketingProvider.marketingOfficersDetails[index]['target']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      );
    });
  }
}
