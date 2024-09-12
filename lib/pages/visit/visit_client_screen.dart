import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VisitClientScreen extends StatelessWidget {
  const VisitClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      drawer: _drawer(context),
      bottomNavigationBar: _bottomNavBar(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(56),
      child: Builder(
        builder: (context) {
          return CustomAppBar(
            tabName: 'Visit Client',
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

  CustomDrawer _drawer(context) {
    return CustomDrawer(
      isVisitActive: true,
    );
  }

  CustomGNavBar _bottomNavBar(context) {
    return CustomGNavBar(
      selectedIndex: 0,
      onTap: (value) {},
    );
  }
}
