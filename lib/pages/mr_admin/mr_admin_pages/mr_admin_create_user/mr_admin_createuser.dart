import 'dart:convert';
import 'package:deskgoo/utils/toast_message.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drop_downs/custom_dropdown.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  CreateUserProvider? createUserProvider;

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2099),
    );
    if (picked == null) {
      return;
    } else {
      setState(() {
        selectedDate = "${picked.year}-${picked.month}-${picked.day}";
        print(selectedDate);
        createUserProvider!.userDobController.text =
            "${picked.year}-${picked.month}-${picked.day}";
      });
    }
    print(selectedDate);
  }

  Future<void> selectDateForDoj() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2099),
    );
    if (picked == null) {
      return;
    } else {
      setState(() {
        selectedDateForDoj = "${picked.year}-${picked.month}-${picked.day}";
        print(selectedDateForDoj);
        createUserProvider!.userDojTextController.text =
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
    createUserProvider =
        Provider.of<CreateUserProvider>(context, listen: false);
    getRoleList();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        Navigator.of(context)
            .pushReplacementNamed(MarketingManagerConstants.homePage);
        createUserProvider!.resetForm();
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
          body: _body(context),
        ),
      ),
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
              Navigator.of(context).pop(MarketingManagerConstants.homePage);
              createUserProvider!.resetForm();
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
                        CustomText(
                          text: 'Personal Details',
                          isSubHeading: true,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFromFieldWithPrefixSuffix(
                          controller: createUserProvider.userNameTextController,
                          labelText: 'Full Name *',
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Name is required'
                                : value.length < 3
                                    ? 'Enter at least 3 characters'
                                    : null;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomDropdown(
                          labelText: 'Gender *',
                          items: createUserProvider.gender,
                          value: createUserProvider.genderDefaultValue,
                          onChanged: (newValue) {
                            createUserProvider.setGender(newValue);
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomDropdown(
                          labelText: 'Nationality *',
                          items: createUserProvider.country,
                          value: createUserProvider.selectedCountry,
                          applyCountryFlag: true,
                          onChanged: (newValue) {
                            createUserProvider.setNationality(newValue);
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFromFieldWithPrefixSuffix(
                          controller:
                              createUserProvider.userAddressTextController,
                          labelText: 'Address *',
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Address is required'
                                : value.length < 5
                                    ? 'Enter at least 5 characters'
                                    : null;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 125,
                              child: CustomDropdown(
                                withPrefixIcon: true,
                                labelText: 'Country Code *',
                                items: createUserProvider.countryCode,
                                value: createUserProvider.selectedCountryCode,
                                onChanged: (newValue) {
                                  createUserProvider.setCountryCode(newValue);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: TextFromFieldWithPrefixSuffix(
                                controller:
                                    createUserProvider.phoneNoController,
                                keyboardType: TextInputType.number,
                                labelText: 'Number *',
                                onTap: () {},
                                validator: (value) {
                                  return value!.isEmpty
                                      ? 'Number is required'
                                      : value.length < 10
                                          ? 'Enter at least 10 characters'
                                          : null;
                                },
                                onChange: (value) {},
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomDropdown(
                          labelText: 'Marital Status *',
                          items: createUserProvider.maritalStatus,
                          value: createUserProvider.maritalStatusDefaultValue,
                          onChanged: (newValue) {
                            createUserProvider.setMaritalStatus(newValue);
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFromFieldWithPrefixSuffix(
                          controller: createUserProvider.userDobController,
                          labelText: 'Date of Birth *',
                          applySuffixIcon: true,
                          suffixIcon: Icon(Icons.calendar_month),
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Date of birth is required'
                                : value.length < 5
                                    ? 'Enter at least 5 characters'
                                    : null;
                          },
                          onTap: () {
                            selectDate();
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFromFieldWithPrefixSuffix(
                          controller:
                              createUserProvider.userEmailTextController,
                          labelText: 'Email *',
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Email is required'
                                : value.length < 6
                                    ? 'Enter at least 6 characters'
                                    : null;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFromFieldWithPrefixSuffix(
                          controller:
                              createUserProvider.userPasswordTextController,
                          labelText: 'Password *',
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Password is required'
                                : value.length < 8
                                    ? 'Enter at least 8 characters'
                                    : null;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomText(
                          text: 'Professional Details',
                          isSubHeading: true,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomDropdown(
                          labelText: 'Department *',
                          items: createUserProvider.department,
                          value: createUserProvider.departmentDefaultValue,
                          onChanged: (newValue) {
                            createUserProvider.setDepartment(newValue);
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        createUserProvider.roleDefaultValue.isNotEmpty
                            ? CustomDropdown(
                                labelText: 'Role *',
                                items: createUserProvider.selectedRole,
                                value: createUserProvider.roleDefaultValue,
                                onChanged: (newValue) {
                                  createUserProvider.setRole(newValue);
                                },
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomDropdown(
                          labelText: 'Designation *',
                          items: createUserProvider.designation,
                          value: createUserProvider.designationDefaultValue,
                          onChanged: (newValue) {
                            createUserProvider.setDesignation(newValue);
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFromFieldWithPrefixSuffix(
                          controller: createUserProvider.userDojTextController,
                          labelText: 'Date of Joining *',
                          applySuffixIcon: true,
                          suffixIcon: Icon(Icons.calendar_month),
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Date of joining is required'
                                : null;
                          },
                          onTap: () {
                            selectDateForDoj();
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomElevatedButton(
                              onPressed: () {
                                // _formState.currentState!.validate();
                                // createUserProvider.PostUserDetails(context);
                                createUserProvider.resetForm();
                                Navigator.of(context).pushReplacementNamed(
                                    MarketingManagerConstants.homePage);
                              },
                              widget: CustomText(
                                text: 'Back',
                                isContent: true,
                              ),
                              backgroundColor: CustomColors.lightRed,
                            ),
                            CustomElevatedButton(
                              onPressed: () {
                                // _formState.currentState!.validate();
                                if (_formState.currentState!.validate()) {
                                  createUserProvider.PostUserDetails(context);
                                } else {
                                  ToastMessageUtils().showToastMessage(
                                      'Please fill all the required fields',
                                      ToastGravity.TOP,
                                      CustomColors.lightRed);
                                }
                              },
                              widget: CustomText(
                                text: 'Create',
                                isContent: true,
                              ),
                              backgroundColor: CustomColors.primaryColor,
                            ),
                          ],
                        ),
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
