import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/drawers/mr_officer_custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MrOfficersDashboardScreen extends StatelessWidget {
  const MrOfficersDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      drawer: MrOfficerCustomDrawer(
        isHomeActive: true,
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) {
          return CustomAppBar(
            tabName: 'Mr Officer Dashboard',
            showLeading: true,
            leadingIcon: FontAwesomeIcons.bars,
            onTapLeadingIcon: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    );
  }
}
