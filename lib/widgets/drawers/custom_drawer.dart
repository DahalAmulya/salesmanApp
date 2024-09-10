import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: CustomColors.primaryBackgroundColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Image.asset(
                        'assets/images/deskgooBlack.png',
                        // width: 120,
                        // height: 60,
                      ),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Farhan Ansari',
                          color: CustomColors.primaryBackgroundColor,
                          fontWeight: FontWeight.w600,
                        ),
                        CustomText(
                          text: 'Developer',
                          color: CustomColors.primaryBackgroundColor,
                          fontWeight: FontWeight.w400,
                          size: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, child) {
                    return ListTile(
                      leading: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      title: CustomText(
                        text: 'Home',
                        color: Colors.white,
                      ),
                      onTap: () {
                        print('Pressed on drawer');
                        // Scaffold.of(context).closeDrawer();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
