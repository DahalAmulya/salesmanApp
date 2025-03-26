import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:flutter/material.dart';

class MrAdminVisitLogListScreen extends StatefulWidget {
  const MrAdminVisitLogListScreen({super.key});

  @override
  State<MrAdminVisitLogListScreen> createState() =>
      _MrAdminVisitLogListScreenState();
}

class _MrAdminVisitLogListScreenState extends State<MrAdminVisitLogListScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        Navigator.of(context).pop(MarketingManagerConstants.homePage);
      }),
      child: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping outside TextFormFields
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: _appBar(context),
          body: _buildI(context),
        ),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Report',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTap: () {
          Navigator.of(context).pop(MarketingManagerConstants.homePage);
        },
      ),
    );
  }

  Widget _buildI(context) {
    return ListView(
      children: [
        const SizedBox(
          height: 16,
        ),
        ListView.builder(
          shrinkWrap: true, // This allows it to take only the required height
          physics:
              NeverScrollableScrollPhysics(), // Disables scrolling for outer ListView, so the inner ListViews can handle scrolling
          itemCount: 4,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                print('Tapped $index');
              },
              child: Center(
                child: Column(
                  children: [
                    CustomContainer(
                      applyShadow: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
