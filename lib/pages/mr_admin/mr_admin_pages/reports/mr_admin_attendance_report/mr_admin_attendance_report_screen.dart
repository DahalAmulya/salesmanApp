import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/expansion_tile/custom_expansiontile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../routes/route_generator_constants.dart';
import '../../../../../themes/custom_colors.dart';
import '../../../../../widgets/app_bars/custom_app_bars.dart';
import '../../../../../widgets/buttons/elevated_button.dart';
import '../../../../../widgets/drop_downs/custom_dropdown.dart';
import '../../../../../widgets/text_fields/text_from_field.dart';
import '../../../../../widgets/texts/custom_text.dart';
import '../../../mr_admin_providers/mr_admin_attendancereport_provider.dart';

class MrAdminAttendanceReportScreen extends StatefulWidget {
  const MrAdminAttendanceReportScreen({super.key});

  @override
  State<MrAdminAttendanceReportScreen> createState() => _MrAdminAttendanceReportScreenState();
}

class _MrAdminAttendanceReportScreenState extends State<MrAdminAttendanceReportScreen> {

  @override
  void initState() {
    super.initState();
    MrAdminAttendanceProvider mrAdminAttendanceProvider = Provider.of<MrAdminAttendanceProvider>(context,listen: false);
    mrAdminAttendanceProvider.getVisitLogsList();
  }

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
          appBar: _appBar(context),
          body: _body(context),
        ),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Attendance Report',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTap: () {
          Navigator.of(context).pop(MarketingManagerConstants.homePage);
        },
      ),
    );
  }

  Widget _body(context){
    return Consumer<MrAdminAttendanceProvider>(
      builder: (context,mrAdminAttendanceProvider,_) {
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
                              items: mrAdminAttendanceProvider.attendanceLogsUsersList,
                              value: mrAdminAttendanceProvider.selectedUser,
                              onChanged: (value) {
                                mrAdminAttendanceProvider.setSelectedUser(value);
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            CustomDropdown(
                              labelText: 'Select Date',
                              items: mrAdminAttendanceProvider.visitDateTypeList,
                              value: mrAdminAttendanceProvider.selectedVisitType,
                              onChanged: (value) {
                                mrAdminAttendanceProvider
                                    .setSelectedVisitType(value);
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            if (mrAdminAttendanceProvider.selectedVisitType == 'Custom')
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: TextFromFieldWithPrefixSuffix(
                                      labelText: 'From',
                                      readOnly: true,
                                      controller: mrAdminAttendanceProvider
                                          .fromTextEditingController,
                                      onTap: () {
                                        mrAdminAttendanceProvider
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
                                      controller: mrAdminAttendanceProvider
                                          .toTextEditingController,
                                      onTap: () {
                                        mrAdminAttendanceProvider
                                            .selectDateTo(context);
                                      },
                                      validator: (value) {},
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: mrAdminAttendanceProvider.selectedVisitType == mrAdminAttendanceProvider.visitDateTypeList[2] ? 16 : 0,
                            ),
                            CustomElevatedButton(
                              onPressed: () {
                                mrAdminAttendanceProvider.getAttendanceReport();
                                // adminVisitLogsProvider.getVisitLogsById();
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
              )
            ],
          )
          ],
        );
      }
    );

  }

}