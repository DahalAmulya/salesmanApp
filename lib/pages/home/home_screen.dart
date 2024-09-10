import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  int index = 0;

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryBackgroundColor,
      appBar: _appBar(context),
      drawer: _drawer(context),
      // drawerDragStartBehavior: DragStartBehavior.start,
      bottomNavigationBar: _bottomNavBar(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Home',
        titleColor: CustomColors.primaryBackgroundColor,
        backgroundColor: CustomColors.primaryBlack,
        showLeading: true,
        leadingIcon: FontAwesomeIcons.bars,
        leadingIconColor: CustomColors.primaryBackgroundColor,
        onTapLeadingIcon: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    );
  }

  Drawer _drawer(context) {
    return Drawer(
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, child) {
            return ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              // onTap: () {
              //   Scaffold.of(context).closeDrawer();
              // },
            );
          }),
    );
  }

  CustomGNavBar _bottomNavBar(context) {
    return CustomGNavBar(
      selectedIndex: index,
      onTap: (value) {
        index = value;
        print(index);
      },
    );
  }
}
