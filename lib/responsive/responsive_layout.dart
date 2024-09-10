import 'package:deskgoo/responsive/dimensions_consts.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.tabletBodyPotrait,
    this.tabletBodyLandscape,
    this.desktopBody,
  });
  final Widget mobileBody;
  final Widget tabletBodyPotrait;
  final Widget? tabletBodyLandscape;
  final Widget? desktopBody;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      if (constrains.maxWidth <= ScreenDimensionsConsts.mobileWidth) {
        return mobileBody;
      } else if (constrains.maxWidth <=
          ScreenDimensionsConsts.tabletWidthPotrait) {
        return tabletBodyPotrait;
      } else if (constrains.maxWidth <=
          ScreenDimensionsConsts.tabletWidthLandscape) {
        return tabletBodyLandscape!;
      } else {
        return desktopBody!;
      }
    });
  }
}
