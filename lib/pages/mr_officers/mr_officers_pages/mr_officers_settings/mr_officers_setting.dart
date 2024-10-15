import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:flutter/material.dart';

class MrOfficersSettingScreen extends StatelessWidget {
  const MrOfficersSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(tabName: 'MrOfficersSettingScreen'),
    );
  }
}
