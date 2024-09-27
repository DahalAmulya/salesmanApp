import 'package:deskgoo/providers/settings_providers/profile_provider/officerdetail_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/containers/custom_container.dart';
import 'ScreenWIdth.dart';

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
         CircleAvatar(
           backgroundImage: AssetImage('assets/images/johnCena.jpg'),
           backgroundColor: Colors.red,
           radius: 50,
         ),
          SizedBox(height: 16,),
          Center(
            child: CustomContainer(
              width: MediaQuery.of(context).size.width * 0.90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<OfficerDetailProvider>(
                    builder: (context,OfficerDetailProvider,_) {
                      return CustomText(
                          text: 'Name: ${OfficerDetailProvider.name}',
                      );
                    }
                  ),
                  Consumer<OfficerDetailProvider>(
                      builder: (context,OfficerDetailProvider,_) {
                        return CustomText(
                          text: 'Address: ${OfficerDetailProvider.address}',
                        );
                      }
                  ),
                  Consumer<OfficerDetailProvider>(
                      builder: (context,OfficerDetailProvider,_) {
                        return CustomText(
                          text: 'Phone Number: ${OfficerDetailProvider.phoneNumber}',
                        );
                      }
                  ),
                  Consumer<OfficerDetailProvider>(
                      builder: (context,OfficerDetailProvider,_) {
                        return CustomText(
                          text: 'Date and Time: ${OfficerDetailProvider.dateTime}',
                        );
                      }
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
