import 'package:deskgoo/providers/marketing_provider/officerdetail_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        title: CustomText(
          text: 'Details',
          size: 30,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16,),
          CustomContainer(
            color: Colors.white,
            verticalMargin: 0,
            verticalPad: 12,
            horizontalMargin: 8,
            horizontalPad: 0,
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
                    SizedBox(width: 16,),
                    CustomText(text: 'Visit Details',fontWeight: FontWeight.w600,size: 20,)
                  ],
                ),
                Divider(
                  height: 8,
                  thickness: 1,
                  indent: 24,
                  color: Colors.grey,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                  child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<OfficerDetailProvider>(
                          builder: (context,OfficerDetailProvider,_) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: CustomText(
                                text: 'Name: ${OfficerDetailProvider.name}',
                              ),
                            );
                          }
                      ),
                      Consumer<OfficerDetailProvider>(
                          builder: (context,OfficerDetailProvider,_) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: CustomText(
                                text: 'Address: ${OfficerDetailProvider.address}',
                              ),
                            );
                          }
                      ),
                      Consumer<OfficerDetailProvider>(
                          builder: (context,OfficerDetailProvider,_) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: CustomText(
                                text: 'Phone Number: ${OfficerDetailProvider.phoneNumber}',
                              ),
                            );
                          }
                      ),
                      Consumer<OfficerDetailProvider>(
                          builder: (context,OfficerDetailProvider,_) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: CustomText(
                                text: 'Date and Time: ${OfficerDetailProvider.dateTime}',
                              ),
                            );
                          }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
