import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../routes/route_generator_constants.dart';
import '../../../../../themes/custom_colors.dart';
import '../../../../../widgets/app_bars/custom_app_bars.dart';
import '../../../../../widgets/buttons/elevated_button.dart';
import '../../../../../widgets/containers/custom_container.dart';
import '../../../../../widgets/drop_downs/custom_dropdown.dart';
import '../../../../../widgets/expansion_tile/custom_expansiontile.dart';
import '../../../../../widgets/text_fields/text_from_field.dart';
import '../../../../../widgets/texts/custom_text.dart';
import '../../../mr_admin_providers/mr_admin_referral log_provider.dart';

class ReferralLogScreen extends StatefulWidget {
  const ReferralLogScreen({super.key});

  @override
  State<ReferralLogScreen> createState() => _ReferralLogScreenState();
}

class _ReferralLogScreenState extends State<ReferralLogScreen> {
  @override
  void initState() {
    super.initState();
    MrAdminReferralLogProvider mrAdminReferralLogProvider =
        Provider.of<MrAdminReferralLogProvider>(context, listen: false);
    mrAdminReferralLogProvider.getVisitLogsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Referral Log Report',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTap: () {
          Navigator.of(context).pop(MarketingManagerConstants.homePage);
        },
      ),
    );
  }

  Widget _body(context) {
    return Consumer<MrAdminReferralLogProvider>(
        builder: (context, mrAdminReferralLogProvider, _) {
      return ListView(
        children: [
          SizedBox(
            height: 16,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomContainer(
                horizontalPad: 0,
                verticalPad: 0,
                color: Colors.transparent,
                child: CustomExpansionTile(
                  initiallyExpanded: true,
                  applyAllBorderRadius: true,
                  title: 'Select User',
                  size: 20,
                  fontWeight: FontWeight.w600,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        CustomDropdown(
                          labelText: 'Select User',
                          items:
                              mrAdminReferralLogProvider.referralLogsUsersList,
                          value: mrAdminReferralLogProvider.selectedUser,
                          onChanged: (value) {
                            mrAdminReferralLogProvider.setSelectedUser(value);
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomDropdown(
                          labelText: 'Select Date',
                          items:
                              mrAdminReferralLogProvider.referralDateTypeList,
                          value:
                              mrAdminReferralLogProvider.selectedReferralType,
                          onChanged: (value) {
                            mrAdminReferralLogProvider
                                .setSelectedVisitType(value);
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        if (mrAdminReferralLogProvider.selectedReferralType ==
                            'Custom')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFromFieldWithPrefixSuffix(
                                  labelText: 'From',
                                  readOnly: true,
                                  controller: mrAdminReferralLogProvider
                                      .fromTextEditingController,
                                  onTap: () {
                                    mrAdminReferralLogProvider
                                        .selectDateFrom(context);
                                  },
                                  validator: (value) {},
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                flex: 1,
                                child: TextFromFieldWithPrefixSuffix(
                                  labelText: 'To',
                                  readOnly: true,
                                  controller: mrAdminReferralLogProvider
                                      .toTextEditingController,
                                  onTap: () {
                                    mrAdminReferralLogProvider
                                        .selectDateTo(context);
                                  },
                                  validator: (value) {},
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomElevatedButton(
                          onPressed: () {
                            mrAdminReferralLogProvider.getReferralLogsById();
                          },
                          width: 0.90,
                          height: 50,
                          backgroundColor: CustomColors.primaryColor,
                          widget: CustomText(
                            text: 'Submit',
                            fontWeight: FontWeight.w600,
                            color: CustomColors.primaryBlack,
                            size: 20.0,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              mrAdminReferralLogProvider.foundReferral.length != 0 ?
             ListView.builder(
                 shrinkWrap: true, // Shrink-wrap the ListView
                 physics: NeverScrollableScrollPhysics(),
               itemCount: mrAdminReferralLogProvider.foundReferral.length,
                 itemBuilder: (context,index){
                 String patientName = mrAdminReferralLogProvider.foundReferral[index]['patientName'];
                 String createdById = mrAdminReferralLogProvider.foundReferral[index]['createdById'];
                 String createdByName = mrAdminReferralLogProvider.foundReferral[index]['createdByName'];
                 String pocId = mrAdminReferralLogProvider.foundReferral[index]['pocId'];
                 String pocName = mrAdminReferralLogProvider.foundReferral[index]['pocName'];
                 String pocNumber = mrAdminReferralLogProvider.foundReferral[index]['pocNumber'];
                 String ambId = mrAdminReferralLogProvider.foundReferral[index]['ambId'];
                 String ambDriverName = mrAdminReferralLogProvider.foundReferral[index]['ambDriverName'];
               return Column(
                 children: [
                   CustomContainer(
                     applyShadow: true,
                       child: Column(
                         children: [
                           Row(
                             children: [
                               Expanded(
                                 flex: 1,
                                   child: CustomText(text: 'patientName'),
                               ),
                               Expanded(
                                   flex:2,
                                   child: CustomText(text: patientName),
                               ),
                             ],
                           ),
                           Row(
                             children: [
                               Expanded(
                                 flex: 1,
                                   child: CustomText(text: 'Mr Officer ID'),
                               ),
                               Expanded(
                                   flex:2,
                                   child: CustomText(text: createdById),
                               ),
                             ],
                           ),
                           Row(
                             children: [
                               Expanded(
                                 flex: 1,
                                   child: CustomText(text: 'Mr Officer Name'),
                               ),
                               Expanded(
                                   flex:2,
                                   child: CustomText(text: createdByName),
                               ),
                             ],
                           ),
                           Row(
                             children: [
                               Expanded(
                                 flex: 1,
                                   child: CustomText(text: 'pocId'),
                               ),
                               Expanded(
                                   flex:2,
                                   child: CustomText(text: pocId),
                               ),
                             ],
                           ),
                           Row(
                             children: [
                               Expanded(
                                 flex: 1,
                                   child: CustomText(text: 'pocName'),
                               ),
                               Expanded(
                                   flex:2,
                                   child: CustomText(text: pocName),
                               ),
                             ],
                           ),
                           Row(
                             children: [
                               Expanded(
                                 flex: 1,
                                   child: CustomText(text: 'pocNumber'),
                               ),
                               Expanded(
                                   flex:2,
                                   child: CustomText(text: pocNumber),
                               ),
                             ],
                           ),
                           Row(
                             children: [
                               Expanded(
                                 flex: 1,
                                   child: CustomText(text: 'ambId'),
                               ),
                               Expanded(
                                   flex:2,
                                   child: CustomText(text: ambId),
                               ),
                             ],
                           ),
                         ],
                       ),
                   ),
                   SizedBox(
                     height: 16,
                   ),
                 ],
               );
             }) : Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 64.0),
                  child: CustomText(
                    text: 'No Referral log found',
                    isSubHeading: true,
                  ),
                ),
              ),

            ],
          ),
        ],
      );
    });
  }
}
