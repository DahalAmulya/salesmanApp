import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar(
      {required this.tabName,
      this.titleColor,
      this.fontWeight,
      this.size,
      this.backgroundColor = Colors.white,
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
      super.key});

  final String tabName;
  final Color? titleColor;
  final Color backgroundColor;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
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
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: CustomText(
          text: tabName,
          fontWeight: fontWeight ?? FontWeight.bold,
          size: size ?? 28.0,
          color: titleColor ?? Colors.black,
        ),
        automaticallyImplyLeading: false,
        leading: showLeading
            ? isLeadingImage
                ? InkWell(
                    onTap: () {},
                    child: Image(
                      image: AssetImage(
                          imageName ?? 'assets/images/deskgooBlack.png'),
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
              ]
            : null,
      ),
    );
  }
}
