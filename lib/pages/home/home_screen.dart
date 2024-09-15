import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  List<String> items = [
    'History',
    'New Visit',
    'Order',
    'Collection',
    'Follow Up',
  ];
  int currentIndex = 0;

  final noteController = TextEditingController();

  // @override
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      initialIndex: 2,
      child: Scaffold(
        backgroundColor: CustomColors.primaryWhite,
        appBar: _appBar(context),
        drawer: _drawer(context),
        // drawerDragStartBehavior: DragStartBehavior.start,
        body: _buildUI(context),
        bottomNavigationBar: _bottomNavBar(context),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) => CustomAppBar(
          tabName: 'Home',
          titleColor: CustomColors.primaryBlack,
          backgroundColor: CustomColors.primaryColor,
          showLeading: true,
          leadingIcon: FontAwesomeIcons.bars,
          leadingIconColor: CustomColors.primaryBlack,
          onTapLeadingIcon: () {
            // Use the context under the Scaffold
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
    );
  }

  // PreferredSize _appBar(context) {
  CustomDrawer _drawer(context) {
    return CustomDrawer(
      isHomeActive: true,
    );
  }

  Widget _buildUI(context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.all(6),
      child: Expanded(
        child: Column(
          children: [
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: items.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            currentIndex = index;
                            print('current index: $currentIndex');
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.all(4),
                          width: 100,
                          height: 40,
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: currentIndex == index
                                ? CustomColors.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: currentIndex == index
                                    ? Colors.black
                                    : Colors.transparent),
                          ),
                          child: Center(
                            child: CustomText(
                              text: '${items[index]}',
                              fontWeight: FontWeight.w500,
                              color: currentIndex == index
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      // Visibility(
                      //   child: Container(
                      //     width: 5,
                      //     height: 5,
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: CustomColors.primaryColor,
                      //     ),
                      //   ),
                      // ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
