import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:flutter/material.dart';

class MrOfficerReferralScreen extends StatefulWidget {
  const MrOfficerReferralScreen({super.key});

  @override
  State<MrOfficerReferralScreen> createState() =>
      _MrOfficerReferralScreenState();
}

class _MrOfficerReferralScreenState extends State<MrOfficerReferralScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _buildUI(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Referral',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTapLeadingIcon: () {
          Navigator.of(context)
              .pop(MarketingOfficerConstants.mrStaffDashboardConst);
        },
      ),
    );
  }

  Widget _buildUI(context) {
    return Container();
  }
}
