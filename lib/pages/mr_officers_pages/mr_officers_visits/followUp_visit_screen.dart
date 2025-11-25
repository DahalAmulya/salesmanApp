import 'package:deskgoo/pages/mr_officers_pages/mr_officers_visits/new_visit_screen.dart';
import 'package:deskgoo/providers/mr_officer_provider/mr_followup_provider.dart';
import 'package:deskgoo/providers/mr_officer_provider/mr_visit_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/utils/toast_message.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MrOfficerFollowUpVisitScreen extends StatelessWidget {
   MrOfficerFollowUpVisitScreen({super.key});

  TextEditingController fullNameController = TextEditingController();

  final _followUpFromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        Navigator.of(context).pop();
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
          backgroundColor: CustomColors.primaryWhite,
          appBar: _appBar(context),
          body: _buildUI(context),
        ),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Consumer<MrOfficerFollowUpProvider>(
        builder: (context, followUpProvider, _) {
          return CustomAppBar(
            tabName: 'Follow Up',
            centerTitle: true,
            automaticallyImplyLeading: true,
            onTapLeadingIcon: () {
              followUpProvider.clearValue();
              Navigator.of(context).pop();
            },
          );
        }
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Consumer<MrOfficerFollowUpProvider>(
      builder: (context, followUpProvider, _) {
        return SingleChildScrollView(
          child: Center(
            child: Stack(
              children: [
                CustomContainer(
                  verticalMargin: 24,
                  applyShadow: true,
                  child: Form(
                    key: _followUpFromKey,
                    child: Column(
                      children: [
                        CustomText(
                          text: 'POC Details',
                          isSubHeading: true,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFromFieldWithPrefixSuffix(
                          controller: followUpProvider.fullNameController,
                          labelText: 'Full Name *',
                          readOnly: true,
                          validator: (value) {
                            return value!.isEmpty ? 'Name is required' : null;
                          },
                          onTap: () {
                            // followUpProvider.GetPOCList(context);
                            showModalBottomSheet(
                                isScrollControlled: true,
                                useSafeArea: true,
                                context: context,
                                builder: (context) =>
                                    _pocModalBottomSheet(context));
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFromFieldWithPrefixSuffix(
                          controller: followUpProvider.categoryController,
                          labelText: 'Category',
                          readOnly: true,
                          validator: (newValue) {
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFromFieldWithPrefixSuffix(
                          controller: followUpProvider.specializationController,
                          labelText: 'Specialization',
                          maxLines: 2,
                          readOnly: true,
                          validator: (newValue) {
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        // TextFromFieldWithPrefixSuffix(
                        //   controller: followUpProvider.ageController,
                        //   labelText: 'Age',
                        //   readOnly: true,
                        //   validator: (newValue) {},
                        // ),
                        // const SizedBox(
                        //   height: 16,
                        // ),
                        TextFromFieldWithPrefixSuffix(
                          controller: followUpProvider.genderController,
                          labelText: 'Gender',
                          readOnly: true,
                          validator: (newValue) {
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFromFieldWithPrefixSuffix(
                          controller: followUpProvider.numberController,
                          keyboardType: TextInputType.number,
                          readOnly: true,
                          labelText: 'Number',
                          onTap: () {},
                          validator: (value) {
                            return null;
                          
                          },
                          onChange: (value) {},
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFromFieldWithPrefixSuffix(
                          controller: followUpProvider.ambulanceNumberController,
                          readOnly: true,
                          labelText: 'Ambulance Number',
                          maxLines: 2,
                          validator: (newValue) {
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFromFieldWithPrefixSuffix(
                          controller: followUpProvider.addressController,
                          readOnly: true,
                          labelText: 'Address',
                          maxLines: 2,
                          validator: (newValue) {
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFromFieldWithPrefixSuffix(
                          controller: followUpProvider.organizationController,
                          readOnly: true,
                          labelText: 'Organization',
                          maxLines: 2,
                          validator: (newValue) {
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFromFieldWithPrefixSuffix(
                          controller: followUpProvider.remarksController,
                          maxLines: 3,
                          labelText: 'Remarks *',
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Remarks is required'
                                : null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomElevatedButton(
                              onPressed: () async {
                                followUpProvider.clearValue();
                                Navigator.of(context).pop();
                              },
                              widget: CustomText(
                                text: 'Back',
                                isContent: true,
                              ),
                              backgroundColor: CustomColors.lightRed,
                            ),
                            CustomElevatedButton(
                              onPressed: () {
                                if (_followUpFromKey.currentState!.validate()) {
                                  followUpProvider.postFollowUp(context);
                                } else {
                                  ToastMessageUtils().showToastMessage(
                                      'Please fill the form',
                                      ToastGravity.TOP,
                                      CustomColors.lightRed);
                                }
                              },
                              widget: CustomText(
                                text: 'Submit',
                                isContent: true,
                              ),
                              backgroundColor: CustomColors.primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 28,
                  child: Consumer<MrOfficerVisitProvider>(
                    builder: (context, provider, _) {
                      return IconButton(
                        onPressed: () {
                          if(followUpProvider.fullNameController.value.text.isNotEmpty){
                            provider.setControllerValues(context, pocId: followUpProvider.pocId, isEdit: true);
                            followUpProvider.clearValue();
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MrOfficerNewVisitScreen()));
                          }else{
                            ToastMessageUtils().showToastMessage(
                                'Please select POC',
                                ToastGravity.TOP,
                                CustomColors.lightRed);
                          }
                        },
                        icon: const Icon(FontAwesomeIcons.penToSquare),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//---------------------------------------------------------------- bottomSheet-------------------------------------------------------------------//
  Widget _pocModalBottomSheet(context) {
    return Consumer<MrOfficerFollowUpProvider>(
      builder: (context, followUpProvider, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.90,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 16,
                    right: 12.0,
                    bottom: 12,
                  ),
                  decoration: BoxDecoration(
                    color: CustomColors.primaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(FontAwesomeIcons.arrowLeft)),
                      ),
                      // ),
                      Expanded(
                        flex: 7,
                        child: TextFromFieldWithPrefixSuffix(
                          controller: followUpProvider.searchByNameController,
                          labelText: 'Search POC name',
                          applySuffixIcon: true,
                          suffixIcon: const Icon(Icons.search),
                          validator: (value) {
                            return null;
                          },
                          onChange: (value) => followUpProvider.searchPocName(
                              followUpProvider
                                  .searchByNameController.value.text,
                              context),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: followUpProvider.pocSearchResult.length,
                    itemBuilder: (context, index) {
                      String id =
                          followUpProvider.pocSearchResult[index]['_id'];
                      String name =
                          followUpProvider.pocSearchResult[index]['pocName'];
                      String category =
                          followUpProvider.pocSearchResult[index]['category'];
                      String specialization = followUpProvider
                          .pocSearchResult[index]['specialization'];
                      // String age = followUpProvider.pocSearchResult[index]
                      //         ['age']
                      //     .toString();
                      String gender =
                          followUpProvider.pocSearchResult[index]['gender'];
                      String number =
                          followUpProvider.pocSearchResult[index]['number'];
                      String ambNumber =
                          followUpProvider.pocSearchResult[index]['ambNumber'] ?? '';
                      String address =
                          followUpProvider.pocSearchResult[index]['address'];
                      String organization = followUpProvider
                          .pocSearchResult[index]['organization'];
                      return ListTile(
                        onTap: () {
                          followUpProvider.getCurrentTimeAndLocation();
                          // print(followUpProvider.pocSearchResult[index]);

                          followUpProvider.setPOCDetails(
                              id,
                              name,
                              category,
                              specialization,
                              gender,
                              number,
                              ambNumber,
                              address,
                              organization);
                          Navigator.pop(context);
                        },
                        title: CustomContainer(
                          applyShadow: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CustomText(
                                      text: 'Name',
                                      isContent: true,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: name,
                                      isContent: true,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CustomText(
                                      text: 'Number',
                                      isContent: true,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: number,
                                      isContent: true,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CustomText(
                                      text: 'Address',
                                      isContent: true,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: address,
                                      isContent: true,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
