import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VisitOrderScreen extends StatelessWidget {
  const VisitOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      drawer: _drawer(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
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
}
