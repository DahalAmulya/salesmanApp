import 'package:deskgoo/providers/marketing_provider/officerdetail_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../routes/route_generator_constants.dart';
import '../../../widgets/app_bars/custom_app_bars.dart';
import '../../../widgets/containers/custom_container.dart';
import '../../../utils/ScreenWIdth.dart';

class OfficerVisitDetailPage extends StatefulWidget {
  const OfficerVisitDetailPage({super.key});

  @override
  State<OfficerVisitDetailPage> createState() => _OfficerVisitDetailPageState();
}

class _OfficerVisitDetailPageState extends State<OfficerVisitDetailPage> {
  double screenHeight = ScreenUtil.getScreenHeight();
  double screenWidth = ScreenUtil.getScreenWidth();
  double officerVisitDetailContainerHeight = 0.0;
  OfficerDetailProvider? _officerDetailProvider;
  FontWeight textFontWeight = FontWeight.w600;
  double textSize = 18;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(context),
      body: _buildUI(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) => CustomAppBar(
          tabName: 'Details',
          titleColor: CustomColors.primaryBlack,
          backgroundColor: CustomColors.primaryColor,
          showLeading: true,
          leadingIcon: FontAwesomeIcons.arrowLeft,
          leadingIconColor: CustomColors.primaryBlack,
          onTapLeadingIcon: () {
            // Use the context under the Scaffold
            Navigator.of(context)
                .pop(RouteGeneratorConstants.officerDescriptionPage);
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
    );
  }

  Widget _buildUI(context) {
    return ListView(
      children: [
        SizedBox(
          height: 16,
        ),
        CustomContainer(
          color: Colors.white,
          verticalMargin: 0,
          verticalPad: 12,
          horizontalMargin: 12,
          horizontalPad: 0,
          // width: 0.90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 24,
                    width: 5,
                    decoration: BoxDecoration(
                      color: CustomColors.primaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  CustomText(
                    text: 'Visit Details',
                    fontWeight: FontWeight.w600,
                    size: 22,
                  )
                ],
              ),
              Divider(
                height: 8,
                thickness: 1,
                indent: 24,
                color: Colors.grey,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8,),
                    Consumer<OfficerDetailProvider>(
                        builder: (context, OfficerDetailProvider, _) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 12,),
                            CustomText(
                              text: '${OfficerDetailProvider.name}',
                              fontWeight: textFontWeight,
                              size: textSize,
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 8,),
                    Consumer<OfficerDetailProvider>(
                        builder: (context, OfficerDetailProvider, _) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                              Icon(Icons.location_on),
                            SizedBox(width: 12,),
                            CustomText(
                              text: '${OfficerDetailProvider.address}',
                              fontWeight: textFontWeight,
                              size: textSize,
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 8,),
                    Consumer<OfficerDetailProvider>(
                        builder: (context, OfficerDetailProvider, _) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.phone),
                            SizedBox(width: 12,),
                            CustomText(
                              text:
                                  '${OfficerDetailProvider.phoneNumber}',
                              fontWeight: textFontWeight,
                              size: textSize,
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 8,),
                    Consumer<OfficerDetailProvider>(
                        builder: (context, OfficerDetailProvider, _) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.calendarAlt),
                            SizedBox(width: 12,),
                            CustomText(
                              text:
                                  '${OfficerDetailProvider.dateTime}',
                              fontWeight: textFontWeight,
                              size: textSize,
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 8,),
                    Consumer<OfficerDetailProvider>(
                        builder: (context, OfficerDetailProvider, _) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Icon(Icons.note),
                            SizedBox(width: 12,),
                            Expanded(
                              child: CustomText(
                                textOverflow: TextOverflow.visible,
                                text: '${OfficerDetailProvider.notes}',
                                fontWeight: textFontWeight,
                                size: textSize,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
