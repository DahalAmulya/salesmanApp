import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../routes/route_generator_constants.dart';
import '../../../../../widgets/app_bars/custom_app_bars.dart';

class MrAdminAmbulanceReportScreen extends StatefulWidget {
  const MrAdminAmbulanceReportScreen({super.key});

  @override
  State<MrAdminAmbulanceReportScreen> createState() => _AmbulanceReportScreenState();
}

class _AmbulanceReportScreenState extends State<MrAdminAmbulanceReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Ambulance Report',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTap: () {
          Navigator.of(context).pop(MarketingManagerConstants.homePage);
        },
      ),
    );
  }

  Widget _body(context){
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(text: 'coming soon',isContent: true,),
      ],
    );
  }

}
