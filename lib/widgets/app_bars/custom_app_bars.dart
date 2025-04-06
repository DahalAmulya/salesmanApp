import 'package:deskgoo/providers/profile/profile_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../consts.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar(
      {required this.tabName,
      this.titleColor,
      this.fontWeight,
      this.size,
      this.backgroundColor,
      this.centerTitle = true,
      this.isShowCard = true,
      this.showTrailingIcons = false,
      this.showPopupMenu = false,
      this.showLeading = false,
      this.isLeadingImage = false,
      this.leadingIconColor = Colors.black,
      this.imageName,
      this.leadingIcon,
      this.onTapLeadingIcon,
      this.applyShadow = false,
      this.showThemeIcon = false,
      this.onPressedThemeIcon,
      this.automaticallyImplyLeading = false,
      this.trailingSearchIcon = false,
      this.onTapTrailingSearchIcon,
      this.showApproveButton = false,
      this.onTapTrailingApproveIcon,
        this.onTap,
      super.key});

  final String tabName;
  final Color? titleColor;
  final bool centerTitle;
  final Color? backgroundColor;
  final FontWeight? fontWeight;
  final double? size;
  final bool isShowCard;
  final bool showTrailingIcons;
  final bool showPopupMenu;
  final bool showLeading;
  final Color leadingIconColor;
  final bool isLeadingImage;
  final String? imageName;
  final IconData? leadingIcon;
  final Function()? onTapLeadingIcon;
  final bool applyShadow;
  final bool showThemeIcon;
  final Function()? onPressedThemeIcon;
  final bool automaticallyImplyLeading;
  final bool trailingSearchIcon;
  final Function()? onTapTrailingSearchIcon;
  bool showApproveButton;
  final Function()? onTapTrailingApproveIcon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? CustomColors.primaryColor,
        boxShadow: applyShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 1,
                  offset: const Offset(0, 0),
                ),
              ]
            : null,
      ),
      child: AppBar(
        centerTitle: centerTitle,
        backgroundColor: backgroundColor ?? CustomColors.primaryColor,
        title: CustomText(
          text: tabName,
          fontWeight: fontWeight ?? FontWeight.w600,
          size: size ?? 28.0,
          color: titleColor ?? Colors.black,
        ),
        // bottom: ButtonsTabBar(
        //   backgroundColor: CustomColors.primaryColor,
        //   splashColor: Colors.blueAccent,
        //   contentCenter: true,
        //   contentPadding: EdgeInsets.all(8),
        //   labelSpacing: 8,
        //   unselectedBackgroundColor: Colors.grey.shade300,
        //   unselectedLabelStyle: TextStyle(color: Colors.black),
        //   labelStyle:
        //       TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        //   tabs: [
        //     Tab(
        //       // icon: FaIcon(FontAwesomeIcons.youtube),
        //       text: 'Visit',
        //     ),
        //     Tab(
        //       // icon: FaIcon(FontAwesomeIcons.whatsapp),
        //       text: 'Order',
        //     ),
        //     Tab(
        //       // icon: FaIcon(FontAwesomeIcons.instagram),
        //       text: 'Collection',
        //     ),
        //     Tab(
        //       // icon: FaIcon(FontAwesomeIcons.linkedin),
        //       text: 'Follow up',
        //     ),
        //     Tab(
        //       // icon: FaIcon(FontAwesomeIcons.facebook),
        //       text: 'Facebook',
        //     ),
        //     Tab(
        //       // icon: FaIcon(FontAwesomeIcons.discord),
        //       text: 'Discord',
        //     ),
        //   ],
        // ),
        automaticallyImplyLeading: automaticallyImplyLeading,
        leading: showLeading
            ? isLeadingImage
                ? InkWell(
                    onTap: onTap,
                    child: Container(
                      // margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Consumer<ProfileProvider>(
                        builder: (context,profileProvider,_) {
                          return Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100), // Circular border
                              child: profileProvider.profilePic.isNotEmpty
                                  ? Image.network(
                                profileProvider.profilePic,
                                fit: BoxFit.fill,
                                width: 48,
                                height: 48,
                              )
                                  : Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: CustomColors.darkBlue,
                                ),
                                alignment: Alignment.center,
                                child: CustomText(
                                  text: '${userName.split(' ')[0][0]}${userName.split(' ')[1][0]}',
                                  size: 24,
                                  color: CustomColors.primaryBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: onTapLeadingIcon,
                    icon: Icon(
                      leadingIcon ?? null,
                      color: leadingIconColor,
                    ),
                  )
            : null,
        actions: showTrailingIcons
            ? [
                showPopupMenu
                    ? PopupMenuButton(
                        icon: const FaIcon(FontAwesomeIcons.bars),
                        // constraints: BoxConstraints.loose(Size(8.0, 8.0)),
                        position: PopupMenuPosition.under,
                        // iconSize: 24.0,
                        // iconColor: Colors.green,
                        color: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: CustomText(text: 'Change view'),
                              onTap: () {
                                // isShowCard
                                //     ? Get.off(const ShowBustime())
                                //     : Get.off(const DataTablePage());
                                debugPrint('tapped $isShowCard');
                              },
                            ),
                            // PopupMenuItem(
                            //   onTap: () {
                            //     debugPrint('tapped delete');
                            //   },
                            //   child: CustomText(text: 'Delete'),
                            // ),
                          ];
                        },
                      )
                    : Container(),
                showThemeIcon
                    ? IconButton(
                        onPressed: onPressedThemeIcon,
                        icon: Icon(Icons.dark_mode),
                      )
                    : Container(),
                trailingSearchIcon
                    ? IconButton(
                        onPressed: onTapTrailingSearchIcon,
                        icon: FaIcon(
                          FontAwesomeIcons.magnifyingGlass,
                          color: CustomColors.primaryBlack,
                        ),
                      )
                    : Container(),
                showApproveButton
                    ? InkWell(
                        onTap: onTapTrailingApproveIcon,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: SizedBox(
                            height: 36,
                            width: 36,
                            child: Image.asset(
                              'assets/images/check-mark.png',
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ]
            : null,
      ),
    );
  }
}
