import 'dart:convert';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drop_downs/custom_dropdown.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../routes/route_generator_constants.dart';
import '../../../../services/erp_services.dart';
import '../../../../themes/custom_colors.dart';
import '../../../../widgets/app_bars/custom_app_bars.dart';
import '../../../../widgets/text_fields/text_from_field.dart';
import '../../mr_admin_providers/mr_admin_createuser_provider.dart';

class MarketingAdminCreateUser extends StatefulWidget {
  const MarketingAdminCreateUser({super.key});

  @override
  State<MarketingAdminCreateUser> createState() =>
      _MarketingAdminCreateUserState();
}

class _MarketingAdminCreateUserState extends State<MarketingAdminCreateUser> {
  Map<String, dynamic> _data = {};
  List<dynamic> _roles = [];
  List<String> _role = [];
  String selectedDate = '';
  String selectedDateForDoj = '';
  final _formState = GlobalKey<FormState>();

  Future<void> selectDate() async {
    final visitLogProvider =
        Provider.of<CreateUserProvider>(context, listen: false);
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );
    if (picked == null) {
      return;
    } else {
      setState(() {
        selectedDate = "${picked.year}-${picked.month}-${picked.day}";
        print(selectedDate);
        visitLogProvider.userDobController.text =
            "${picked.year}-${picked.month}-${picked.day}";
      });
    }
    print(selectedDate);
  }

  Future<void> selectDateForDoj() async {
    final visitLogProvider =
        Provider.of<CreateUserProvider>(context, listen: false);
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );
    if (picked == null) {
      return;
    } else {
      setState(() {
        selectedDateForDoj = "${picked.year}-${picked.month}-${picked.day}";
        print(selectedDateForDoj);
        visitLogProvider.userDojTextController.text =
            "${picked.year}-${picked.month}-${picked.day}";
      });
    }
    print(selectedDateForDoj);
  }

  void updateSelectedDate(String newValue) {
    setState(() {
      selectedDate = newValue;
      selectedDate =
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
      // Open date picker for custom date selection
    });
    // selectDate();
  }

  void getRoleList() async {
    ERPResponse response = await ERPServices.getRequest('/users/roles');
    _data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _roles = _data['roles'];
        // print(_data);
        for (var role in _roles) {
          _role.add(role['role'].toString());
        }
      });

      print(_role);
    }
  }

  @override
  void initState() {
    super.initState();
    getRoleList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(context),
      body: _body(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) {
          return CustomAppBar(
            tabName: 'Create User',
            showLeading: true,
            leadingIcon: FontAwesomeIcons.arrowLeft,
            leadingIconColor: CustomColors.primaryBlack,
            onTapLeadingIcon: () {
              Navigator.of(context).pop(MarketingManagerConstants.settingPage);
            },
          );
        },
      ),
    );
  }

  Widget _body(context) {
    return Consumer<CreateUserProvider>(
      builder: (context, createUserProvider, _) {
        return SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formState,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomContainer(
                    verticalMargin: 24,
                    applyShadow: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomText(
                                text: 'Name',
                                isContent: true,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              flex: 2,
                              child: TextFromFieldWithPrefixSuffix(
                                controller:
                                    createUserProvider.userNameTextController,
                                validator: (value) {
                                  return value!.isEmpty
                                      ? 'Name is required'
                                      : value.length < 3
                                          ? 'Enter at least 3 characters'
                                          : null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomText(
                                text: 'Gender',
                                isContent: true,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              flex: 2,
                              child: CustomDropdown(
                                labelText: 'Gender',
                                items: createUserProvider.gender,
                                value: createUserProvider.genderDefaultValue,
                                onChanged: (newValue) {
                                  createUserProvider.setGender(newValue);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
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
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              flex: 2,
                              child: TextFromFieldWithPrefixSuffix(
                                controller:
                                    createUserProvider.userNumberTextController,
                                validator: (value) {
                                  return value!.isEmpty
                                      ? 'Number is required'
                                      : value.length < 10
                                          ? 'Enter at least 10 characters'
                                          : null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomText(
                                text: 'Email',
                                isContent: true,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              flex: 2,
                              child: TextFromFieldWithPrefixSuffix(
                                controller:
                                    createUserProvider.userEmailTextController,
                                validator: (value) {
                                  return value!.isEmpty
                                      ? 'Email is required'
                                      : value.length < 6
                                          ? 'Enter at least 6 characters'
                                          : null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomText(
                                text: 'Password',
                                isContent: true,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              flex: 2,
                              child: TextFromFieldWithPrefixSuffix(
                                controller: createUserProvider
                                    .userPasswordTextController,
                                validator: (value) {
                                  return value!.isEmpty
                                      ? 'Password is required'
                                      : value.length < 8
                                          ? 'Enter at least 8 characters'
                                          : null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomText(
                                text: 'Department',
                                isContent: true,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              flex: 2,
                              child: CustomDropdown(
                                labelText: 'Department',
                                items: createUserProvider.department,
                                value:
                                    createUserProvider.departmentDefaultValue,
                                onChanged: (newValue) {
                                  createUserProvider.setDepartment(newValue);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomText(
                                text: 'Role',
                                isContent: true,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            createUserProvider.selectedRole.isNotEmpty
                                ? Expanded(
                                    flex: 2,
                                    child: CustomDropdown(
                                      labelText: 'Role',
                                      items: createUserProvider.selectedRole,
                                      value:
                                          createUserProvider.roleDefaultValue,
                                      onChanged: (newValue) {
                                        createUserProvider.setRole(newValue);
                                      },
                                    ),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomText(
                                text: 'Designation',
                                isContent: true,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              flex: 2,
                              child: CustomDropdown(
                                labelText: 'Designation',
                                items: createUserProvider.designation,
                                value:
                                    createUserProvider.designationDefaultValue,
                                onChanged: (newValue) {
                                  createUserProvider.setDesignation(newValue);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
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
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              flex: 2,
                              child: TextFromFieldWithPrefixSuffix(
                                controller: createUserProvider
                                    .userAddressTextController,
                                validator: (value) {
                                  return value!.isEmpty
                                      ? 'Address is required'
                                      : value.length < 5
                                          ? 'Enter at least 5 characters'
                                          : null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomText(
                                text: 'DOB',
                                isContent: true,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              flex: 2,
                              child: TextFromFieldWithPrefixSuffix(
                                controller:
                                    createUserProvider.userDobController,
                                applySuffixIcon: true,
                                suffixIcon: Icon(Icons.calendar_month),
                                validator: (value) {
                                  return value!.isEmpty
                                      ? 'Address is required'
                                      : value.length < 5
                                          ? 'Enter at least 5 characters'
                                          : null;
                                },
                                onTap: () {
                                  selectDate();
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomText(
                                text: 'Marital Status',
                                isContent: true,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              flex: 2,
                              child: CustomDropdown(
                                labelText: 'Marital Status',
                                items: createUserProvider.maritalStatus,
                                value: createUserProvider
                                    .maritalStatusDefaultValue,
                                onChanged: (newValue) {
                                  createUserProvider.setMaritalStatus(newValue);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomText(
                                text: 'DOJ',
                                isContent: true,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              flex: 2,
                              child: TextFromFieldWithPrefixSuffix(
                                controller:
                                    createUserProvider.userDojTextController,
                                applySuffixIcon: true,
                                suffixIcon: Icon(Icons.calendar_month),
                                validator: (value) {},
                                onTap: () {
                                  selectDateForDoj();
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomText(
                                text: 'Nationality',
                                isContent: true,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              flex: 2,
                              child: CustomDropdown(
                                labelText: 'Marital Status',
                                items: createUserProvider.nationality,
                                value:
                                    createUserProvider.nationalityDefaultValue,
                                onChanged: (newValue) {
                                  createUserProvider.setNationality(newValue);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomElevatedButton(
                            onPressed: () {
                              // _formState.currentState!.validate();
                              createUserProvider.PostUserDetails(context);
                            },
                            widget: CustomText(text: 'Create'),
                            backgroundColor: CustomColors.primaryColor),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
