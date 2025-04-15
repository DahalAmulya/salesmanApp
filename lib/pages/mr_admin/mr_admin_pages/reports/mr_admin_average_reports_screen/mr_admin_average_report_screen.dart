import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import '../../../../../routes/route_generator_constants.dart';
import '../../../../../themes/custom_colors.dart';
import '../../../../../widgets/app_bars/custom_app_bars.dart';

class MrAdminAverageReportScreen extends StatefulWidget {
  const MrAdminAverageReportScreen({super.key});

  @override
  State<MrAdminAverageReportScreen> createState() => _MrAdminAverageReportScreenState();
}

class _MrAdminAverageReportScreenState extends State<MrAdminAverageReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(context),
      body: _body(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Average Visit Report',
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
      children: [
        const SizedBox(height: 16,),
        CustomContainer(
            verticalPad: 12,
            horizontalPad: 0,
            color: Colors.white,
            applyShadow: true,
            child: Column(
          children: [
            CustomText(text: 'Name')
          ],
        ),
        ),
      ],
    );
  }

}
