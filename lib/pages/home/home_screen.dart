import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  int index = 0;
  final noteController = TextEditingController();

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(context),
      drawer: _drawer(context),
      // drawerDragStartBehavior: DragStartBehavior.start,
      body: _buildUI(context),
      bottomNavigationBar: _bottomNavBar(context),
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

  CustomDrawer _drawer(context) {
    return CustomDrawer(
      isHomeActive: true,
    );
  }

  Widget _buildUI(context) {
    return Center(
      child: CustomContainer(
        child: Column(
          children: [
            TextFromFieldWithPrefixSuffix(
              controller: noteController,
              hintText: 'Write a note...',
              // maxLines: ,
              minLine: 4,
              maxLines: 8,
              keyboardType: TextInputType.multiline,
              validator: (value) {
                return null;
              },
              onChange: (value) {},
            ),
            CustomElevatedButton(
              onPressed: () {
                print('note value = ${noteController.value.text}');
              },
              widget: CustomText(text: 'Submit'),
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
