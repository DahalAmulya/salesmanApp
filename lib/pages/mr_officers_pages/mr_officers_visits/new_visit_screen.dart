import 'dart:convert';
import 'package:deskgoo/providers/mr_officer_provider/mr_visitLog_provider.dart';
import 'package:deskgoo/providers/mr_officer_provider/mr_visit_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drop_downs/custom_dropdown.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MrOfficerNewVisitScreen extends StatefulWidget {
  const MrOfficerNewVisitScreen({super.key});

  @override
  State<MrOfficerNewVisitScreen> createState() =>
      _MrOfficerNewVisitScreenState();
}

class _MrOfficerNewVisitScreenState extends State<MrOfficerNewVisitScreen> {
  TextEditingController fullNameController = TextEditingController();
  final _createVisitFormKey = GlobalKey<FormState>();
  List<String> country = ['Nepal', 'India'];
  String selectedCountry = '';
  final _formKey = GlobalKey<FormState>();

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
      child: Consumer<MrOfficerVisitProvider>(builder: (context, provider, _) {
        return CustomAppBar(
          tabName: provider.isEditPoc ? 'Edit POC' : 'New Visit',
          centerTitle: true,
          automaticallyImplyLeading: true,
          onTapLeadingIcon: () {
            provider.clearTextControllersValue();
            Navigator.of(context).pop();
          },
        );
      }),
    );
  }

  Widget _buildUI(BuildContext context) {
    selectedCountry = country[0];
    return Consumer<MrOfficerVisitProvider>(
      builder: (context, createVisitProvider, _) {
        return SingleChildScrollView(
          child: Center(
            child: CustomContainer(
              verticalMargin: 24,
              applyShadow: true,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomText(
                      text: 'Personal Details',
                      isSubHeading: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFromFieldWithPrefixSuffix(
                      controller: createVisitProvider.nameController,
                      labelText: 'Full Name *',
                      validator: (value) {
                        return value!.isEmpty ? 'Full Name Required' : null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // TextFromFieldWithPrefixSuffix(
                    //   controller: createVisitProvider.ageController,
                    //   keyboardType: TextInputType.number,
                    //   labelText: 'Age',
                    //   validator: (newValue) {},
                    // ),
                    // const SizedBox(
                    //   height: 16,
                    // ),
                    CustomDropdown(
                      labelText: 'Gender',
                      items: createVisitProvider.genderList,
                      value: createVisitProvider.selectedGender,
                      onChanged: (value) {
                        createVisitProvider.setSelectedGender(value!);
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 125,
                          child: CustomDropdown(
                            withPrefixIcon: true,
                            labelText: 'Country Code',
                            items: createVisitProvider.countryCode,
                            value: createVisitProvider.selectedCountryCode,
                            onChanged: (newValue) {
                              createVisitProvider.setCountryCode(newValue);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: TextFromFieldWithPrefixSuffix(
                            controller: createVisitProvider.phoneNoController,
                            keyboardType: TextInputType.number,
                            labelText: 'Number *',
                            onTap: () {},
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'Phone number Required'
                                  : value.length > 10
                                      ? 'Invalid Number'
                                      : null;
                            },
                            onChange: (value) {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomDropdown(
                      labelText: 'Country',
                      items: createVisitProvider.country,
                      value: createVisitProvider.selectedCountry,
                      applyCountryFlag: true,
                      onChanged: (newValue) {
                        createVisitProvider.setCountry(newValue);
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFromFieldWithPrefixSuffix(
                      controller: createVisitProvider.selectedCountry ==
                              createVisitProvider.country[0]
                          ? createVisitProvider.districtController
                          : createVisitProvider.stateController,
                      readOnly: true,
                      labelText: createVisitProvider.selectedCountry ==
                              createVisitProvider.country[0]
                          ? 'District *'
                          : 'State *',
                      validator: (value) {
                        return value!.isEmpty
                            ? createVisitProvider.selectedCountry ==
                                    createVisitProvider.country[0]
                                ? 'District Required'
                                : 'State Required'
                            : null;
                      },
                      onTap: () async {
                        String fileName = createVisitProvider.selectedCountry ==
                                createVisitProvider.country[0]
                            ? 'district'
                            : 'states';
                        final file = await rootBundle
                            .loadString('assets/$fileName.json');
                        final content = await jsonDecode(file);
                        showModalBottomSheet(
                            isScrollControlled: true,
                            useSafeArea: true,
                            context: context,
                            builder: (context) => districtBottomSheet(
                                context, fileName, content));
                        createVisitProvider.searchController.text = '';
                        createVisitProvider.searchAddressResult(
                            createVisitProvider.searchController.value.text,
                            content);
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFromFieldWithPrefixSuffix(
                      controller: createVisitProvider.cityController,
                      readOnly: true,
                      labelText: 'City *',
                      validator: (value) {
                        return value!.isEmpty ? 'City Required' : null;
                      },
                      onTap: () async {
                        createVisitProvider.searchController.text = '';
                        createVisitProvider.searchAddressResult(
                            createVisitProvider.searchController.value.text,
                            createVisitProvider.cities);
                        showModalBottomSheet(
                            isScrollControlled: true,
                            useSafeArea: true,
                            context: context,
                            builder: (context) => citiesBottomSheet(
                                context, createVisitProvider.cities));
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFromFieldWithPrefixSuffix(
                      controller: createVisitProvider.addressController,
                      labelText: 'Address *',
                      maxLines: 2,
                      validator: (value) {
                        return value!.isEmpty ? 'Address Required' : null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomText(
                      text: 'More Details',
                      isSubHeading: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomDropdown(
                        labelText: 'Category',
                        items: createVisitProvider.category,
                        value: createVisitProvider.selectedCategory,
                        onChanged: (newValue) {
                          createVisitProvider.setCategory(newValue);
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomDropdown(
                      labelText: 'Specialization',
                      items: createVisitProvider.specialization,
                      value: createVisitProvider.selectedSpecialization.isEmpty
                          ? createVisitProvider.specialization[0]
                          : createVisitProvider.selectedSpecialization,
                      onChanged: (newValue) {
                        createVisitProvider.setSpecialization(newValue);
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    createVisitProvider.selectedCategory == "Ambulance"
                        ? Column(
                            children: [
                              TextFromFieldWithPrefixSuffix(
                                controller: createVisitProvider
                                    .ambulanceNumberController,
                                labelText: 'Ambulance Number *',
                                maxLines: 2,
                                validator: (value) {
                                  return value!.isEmpty
                                      ? 'Ambulance Number Required'
                                      : null;
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          )
                        : Container(),
                    TextFromFieldWithPrefixSuffix(
                      controller: createVisitProvider.organizationController,
                      labelText: 'Organization',
                      maxLines: 2,
                      validator: (newValue) {
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if ((createVisitProvider.isEditPoc && createVisitProvider.isOffline) || (!createVisitProvider.isEditPoc && createVisitProvider.isOffline) || (!createVisitProvider.isEditPoc && !createVisitProvider.isOffline))
                      TextFromFieldWithPrefixSuffix(
                        controller: createVisitProvider.remarksController,
                        labelText: 'Remarks *',
                        maxLines: 2,
                        validator: (value) {
                          return value!.isEmpty ? 'Remarks Required' : null;
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
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate()) {
                              debugPrint('${createVisitProvider.isOffline}');
                              createVisitProvider.createPOC();
                              debugPrint('isOffline: ${createVisitProvider.isOffline}, isEditPoc: ${createVisitProvider.isEditPoc}');
                              if((createVisitProvider.isOffline == true && createVisitProvider.isEditPoc == true) || (createVisitProvider.isOffline == true && createVisitProvider.isEditPoc == false)){
                                debugPrint('Local isOffline: ${createVisitProvider.isOffline}, isEditPoc: ${createVisitProvider.isEditPoc}');
                                localPocDetails(context);
                                return;
                              }
                              if((createVisitProvider.isOffline == false && createVisitProvider.isEditPoc == false) || (createVisitProvider.isOffline == false && createVisitProvider.isEditPoc == true)){
                                debugPrint('Online: ${createVisitProvider.isOffline}, isEditPoc: ${createVisitProvider.isEditPoc}');
                                pocDetails(context);
                                return;
                              }

                            }
                          },
                          widget: CustomText(
                            text: createVisitProvider.isEditPoc
                                ? 'Update'
                                : 'Submit',
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
          ),
        );
      },
    );
  }

  Future pocDetails(context) => showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: CustomColors.primaryWhite,
            elevation: 10,
            title: Builder(builder: (context) {
              return Center(
                child: CustomText(
                  text: 'POC Details',
                  fontWeight: FontWeight.bold,
                  size: 22,
                  color: CustomColors.primaryBlack,
                ),
              );
            }),
            content: SingleChildScrollView(
              child: Consumer<MrOfficerVisitProvider>(
                  builder: (context, mrOfficerVisitProvider, _) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Full Name',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['pocName'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Gender',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['gender'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Number',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['number'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Country',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['country'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // flex: ,
                          child: CustomText(
                            text: mrOfficerVisitProvider.selectedCountry ==
                                    'Nepal'
                                ? 'District'
                                : 'State',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          // flex: 2,
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['region'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'City',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['city'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Address',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['address'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Category',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['category'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Ambulance No',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['ambNumber'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Specialization',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['specialization'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Organization',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['organization'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    mrOfficerVisitProvider.isEditPoc == false ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomText(
                              text: 'Remarks',
                              isContent: true,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              maxLines: 3,
                              text: mrOfficerVisitProvider.body.containsKey('remarks') ? mrOfficerVisitProvider.body['remarks'] : 'N/A',
                              isContent: true,
                            ),
                          ),
                        ],
                      ) : SizedBox.shrink(),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }),
            ),
            actions: [
              Consumer<MrOfficerVisitProvider>(
                builder: (context, mrOfficerVisitProvider, _) {
                  final bool isLoading = mrOfficerVisitProvider.isLoading;
                  final bool isOffline = mrOfficerVisitProvider.isOffline ?? false;
                  final bool isEdit = mrOfficerVisitProvider.isEditPoc ?? false;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Edit button (returns false to caller)
                      Expanded(
                        child: CustomElevatedButton(
                          // onPressed: isLoading ? null : () {
                          //   Navigator.pop(context, false); // <-- fixed: actually passing false
                          // },
                          onPressed: () {
                            debugPrint('Offline mode edit');
                            Navigator.pop(context); // <-- fixed: actually passing false
                          },
                          backgroundColor: CustomColors.lightRed,
                          widget: CustomText(
                            text: 'Edit',
                            color: CustomColors.primaryBlack,
                            isContent: true,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Action button / loader
                      Expanded(
                        child: isLoading
                            ? SizedBox(
                          height: 48,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: CustomColors.primaryColor,
                              strokeWidth: 2.5,
                            ),
                          ),
                        )
                            : CustomElevatedButton(
                          onPressed: () {
                            debugPrint('Online Mode, isOffline: $isOffline, isEdit: $isEdit');
                            if(mrOfficerVisitProvider.isEditPoc == false){
                              mrOfficerVisitProvider.postPOCDetails(context);
                            }
                            if(mrOfficerVisitProvider.isEditPoc == true){
                              Navigator.pop(context);
                              mrOfficerVisitProvider.updatePOC(context);
                            }
                          },
                          widget: CustomText(
                            text: isEdit ? 'Update' : 'Submit',
                            isContent: true,
                            maxLines: 2,
                          ),
                          backgroundColor: CustomColors.primaryColor,
                        )
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      );

  Future localPocDetails(context) => showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: CustomColors.primaryWhite,
            elevation: 10,
            title: Builder(builder: (context) {
              return Center(
                child: CustomText(
                  text: 'Offline POC Details',
                  fontWeight: FontWeight.bold,
                  size: 22,
                  color: CustomColors.primaryBlack,
                ),
              );
            }),
            content: SingleChildScrollView(
              child: Consumer<MrOfficerVisitProvider>(
                  builder: (context, mrOfficerVisitProvider, _) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Full Name',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['pocName'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Gender',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['gender'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Number',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['number'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Country',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['country'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // flex: ,
                          child: CustomText(
                            text: mrOfficerVisitProvider.selectedCountry ==
                                    'Nepal'
                                ? 'District'
                                : 'State',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          // flex: 2,
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['region'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'City',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['city'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Address',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['address'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Category',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['category'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Ambulance No',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['ambNumber'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Specialization',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['specialization'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: 'Organization',
                            isContent: true,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            maxLines: 3,
                            text: mrOfficerVisitProvider.body['organization'],
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if ((mrOfficerVisitProvider.isEditPoc && mrOfficerVisitProvider.isOffline) || (!mrOfficerVisitProvider.isEditPoc && mrOfficerVisitProvider.isOffline) || (!mrOfficerVisitProvider.isEditPoc && !mrOfficerVisitProvider.isOffline))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomText(
                              text: 'Remarks',
                              isContent: true,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              maxLines: 3,
                              text: mrOfficerVisitProvider.body['remarks'],
                              isContent: true,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }),
            ),
            actions: [
              Consumer2<MrOfficerVisitProvider, MrOfficeVisitLogProvider>(
                builder: (context, mrOfficerVisitProvider, visitLogProvider, _) {
                  final bool isLoading = mrOfficerVisitProvider.isLoading;
                  final bool isOffline = mrOfficerVisitProvider.isOffline ?? false;
                  final bool isEdit = mrOfficerVisitProvider.isEditPoc ?? false;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Edit button (returns false to caller)
                      Expanded(
                        child: CustomElevatedButton(
                          // onPressed: isLoading ? null : () {
                          //   Navigator.pop(context, false); // <-- fixed: actually passing false
                          // },
                          onPressed: () {
                            Navigator.pop(context); // <-- fixed: actually passing false
                          },
                          backgroundColor: CustomColors.lightRed,
                          widget: CustomText(
                            text: 'Edit',
                            color: CustomColors.primaryBlack,
                            isContent: true,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Action button / loader
                      Expanded(
                        child: isLoading
                            ? SizedBox(
                          height: 48,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: CustomColors.primaryColor,
                              strokeWidth: 2.5,
                            ),
                          ),
                        )
                            :  CustomElevatedButton(
                          onPressed: () async {
                            if(isEdit && isOffline){
                              debugPrint('*************************************************************');
                              debugPrint('\t\tUpdate Locally');
                              debugPrint('*************************************************************');
                              await mrOfficerVisitProvider.updateLocalPoc(context);
                              visitLogProvider.getOfflinePocList();
                              return;
                            }
                            if(isOffline){
                              // If trying to edit while offline, just update locally
                              debugPrint('*************************************************************');
                              debugPrint('\t\tSaving Locally');
                              debugPrint('*************************************************************');
                              mrOfficerVisitProvider.savePocLocally(context);
                              return;
                            }
                          },
                          widget: CustomText(
                            text: isEdit ? 'Update Offline' : 'Save Offline',
                            isContent: true,
                            maxLines: 2,
                          ),
                          backgroundColor: CustomColors.primaryColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      );

  Widget districtBottomSheet(context, String type, List<dynamic> content) {
    return Consumer<MrOfficerVisitProvider>(
      builder: (context, visitProvider, _) {
        return Container(
          color: CustomColors.primaryWhite,
          height: MediaQuery.of(context).size.height * 0.80,
          child: Column(
            children: [
              // SizedBox(
              //   height: 16,
              // ),
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
                        controller: visitProvider.searchController,
                        labelText: visitProvider.selectedCountry == 'Nepal'
                            ? 'Search District'
                            : 'Search State',
                        applySuffixIcon: true,
                        suffixIcon: const Icon(Icons.search),
                        validator: (value) {
                          return null;
                        },
                        onChange: (value) => visitProvider.searchAddressResult(
                            visitProvider.searchController.value.text, content),
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
                  itemCount: visitProvider.searchResult.length,
                  itemBuilder: (context, index) {
                    String name = visitProvider.searchResult[index]['$type'];
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        type == 'district'
                            ? visitProvider.setSelectedDistrict(name)
                            : visitProvider.setSelectedState(name);
                        visitProvider.getCities(
                            visitProvider.searchResult[index]['cities']);
                      },
                      title: CustomText(
                        text: name,
                        isContent: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget citiesBottomSheet(context, List<dynamic> content) {
    return Consumer<MrOfficerVisitProvider>(
      builder: (context, visitProvider, _) {
        return Container(
          color: CustomColors.primaryWhite,
          height: MediaQuery.of(context).size.height * 0.80,
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
                        controller: visitProvider.searchController,
                        labelText: 'Search City',
                        applySuffixIcon: true,
                        suffixIcon: const Icon(Icons.search),
                        validator: (value) {
                          return null;
                        },
                        onChange: (value) => visitProvider.searchAddressResult(
                            visitProvider.searchController.value.text, content),
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
                  itemCount: visitProvider.searchResult.length,
                  itemBuilder: (context, index) {
                    String cityName = visitProvider.searchResult[index];
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        visitProvider.setSelectedCity(cityName);
                        print(visitProvider.searchResult[index]);
                      },
                      title: CustomText(
                        text: cityName,
                        isContent: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
