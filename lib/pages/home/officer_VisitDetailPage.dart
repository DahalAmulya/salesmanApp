import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        title: CustomText(
          text: 'Details',
        ),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
