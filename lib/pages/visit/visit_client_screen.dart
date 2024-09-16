import 'package:deskgoo/providers/visit_provider/visit_screen_provider.dart';
import 'package:deskgoo/routes/app_route_constants.dart';
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
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class VisitClientScreen extends StatefulWidget {
  const VisitClientScreen({super.key});

  @override
  State<VisitClientScreen> createState() => _VisitClientScreenState();
}

class _VisitClientScreenState extends State<VisitClientScreen> {
  final clientNameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final panController = TextEditingController();
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _buidlUI(context);
    //     Scaffold(
    //   backgroundColor: CustomColors.primaryWhite,
    //   appBar: _appBar(context),
    //   drawer: _drawer(context),
    //   body: _buidlUI(context),
    //   bottomNavigationBar: _bottomNavBar(context),
    // );
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

  Widget _buidlUI(context) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          CustomContainer(
            verticalPad: 24.0,
            horizontalPad: 16.0,
            applyShadow: true,
            child: Column(
              children: [
                Builder(builder: (context) {
                  return TextFromFieldWithPrefixSuffix(
                    controller: clientNameController,
                    labelText: 'Select Client Name',
                    // hintText: 'Select Client Name',
                    readOnly: true,
                    onTap: () {
                      _showBottomSheet(context);
                    },
                    validator: (value) {
                      return null;
                    },
                    onChange: (value) {},
                  );
                }),
                SizedBox(
                  height: 10.0,
                ),
                TextFromFieldWithPrefixSuffix(
                  controller: addressController,
                  readOnly: true,
                  labelText: 'Address',
                  onTap: () {},
                  validator: (value) {
                    return null;
                  },
                  onChange: (value) {},
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFromFieldWithPrefixSuffix(
                  controller: phoneController,
                  readOnly: true,
                  labelText: 'Phone',
                  onTap: () {},
                  validator: (value) {
                    return null;
                  },
                  onChange: (value) {},
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFromFieldWithPrefixSuffix(
                  controller: emailController,
                  readOnly: true,
                  labelText: 'Email',
                  onTap: () {},
                  validator: (value) {
                    return null;
                  },
                  onChange: (value) {},
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFromFieldWithPrefixSuffix(
                  controller: panController,
                  readOnly: true,
                  labelText: 'PAN',
                  onTap: () {},
                  validator: (value) {
                    return null;
                  },
                  onChange: (value) {},
                ),
                SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CustomGNavBar _bottomNavBar(context) {
    return CustomGNavBar(
      selectedIndex: 0,
      onTap: (value) {},
    );
  }

  Future<void> _showBottomSheet(context) async {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: _bottomSheetAppBar(context),
            body: _bottomSheetBody(context),
          ),
        ),
      ),
    );
  }

  PreferredSize _bottomSheetAppBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        showLeading: true,
        leadingIcon: FontAwesomeIcons.arrowLeft,
        tabName: 'Search Client',
        onTapLeadingIcon: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _bottomSheetBody(context) {
    return Center(
      child: CustomContainer(
        verticalMargin: 16.0,
        child: Column(
          children: [
            Consumer<VisitScreenProvider>(
              builder: (context, provider, _) {
                return TextFromFieldWithPrefixSuffix(
                  controller: searchController,
                  labelText: 'Search Client',
                  applyPrefix: true,
                  prefixIcon: Icon(Icons.search),
                  validator: (value) {
                    return null;
                  },
                  onChange: (value) =>
                      provider.runFilter(searchController.value.text),
                  onTap: () {},
                );
              },
            ),
            Expanded(
              child: Consumer<VisitScreenProvider>(
                  builder: (context, provider, _) {
                return ListView.builder(
                  itemCount: provider.searchResult.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        print(provider.searchResult[index]);
                        clientNameController.text =
                            provider.searchResult[index]['client'].toString();
                        addressController.text =
                            provider.searchResult[index]['address'].toString();
                        phoneController.text =
                            provider.searchResult[index]['phone'].toString();
                        emailController.text =
                            provider.searchResult[index]['email'].toString();
                        panController.text =
                            provider.searchResult[index]['pan'].toString();
                        Navigator.pop(context);
                      },
                      child: ListTile(
                        leading: CustomText(
                            text: provider.searchResult[index]['client']),
                      ),
                    );
                  },
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  borderColor: CustomColors.lightRed,
                  widget: CustomText(
                    text: 'Cancel',
                    color: CustomColors.lightRed,
                  ),
                ),
                CustomElevatedButton(
                  onPressed: () {},
                  borderColor: CustomColors.primaryColor,
                  widget: CustomText(
                    text: 'Create',
                    color: CustomColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
