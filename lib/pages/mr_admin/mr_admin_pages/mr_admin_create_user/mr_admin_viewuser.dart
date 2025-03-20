import 'package:deskgoo/pages/mr_admin/mr_admin_providers/mr_admin_createuser_provider.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../routes/route_generator_constants.dart';
import '../../../../themes/custom_colors.dart';
import '../../../../widgets/app_bars/custom_app_bars.dart';

class MarketingAdminViewUser extends StatefulWidget {
  const MarketingAdminViewUser({super.key});

  @override
  State<MarketingAdminViewUser> createState() => _MarketingAdminViewUserState();
}

class _MarketingAdminViewUserState extends State<MarketingAdminViewUser> {
  @override
  void initState() {
    final createUserProvider = Provider.of<CreateUserProvider>(context,listen: false);
    createUserProvider.getUserDetails(context);
    // TODO: implement initState
    super.initState();
  }

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
      child: Builder(
        builder: (context) {
          return CustomAppBar(
            tabName: 'View User',
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

  Widget _buildUI(BuildContext context){
    return Scaffold(
      body: Consumer<CreateUserProvider>(
        builder: (context,createUserProvider,_) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: createUserProvider.userList.length, // replace with actual number of users.
                    itemBuilder: (context,index){
                      String userName = createUserProvider.userData['users'][index]['username'];
                      String userRole = createUserProvider.userData['users'][index]['role']['role'];
                      String userDepartment = createUserProvider.userData['users'][index]['department'];
                      String userDesignation = createUserProvider.userData['users'][index]['designation'];
                      String userEmail = createUserProvider.userData['users'][index]['email'];
                      String userAddress = createUserProvider.userData['users'][index]['address'];
                      String userDOB = createUserProvider.userData['users'][index]['dob'];
                      String userNumber = createUserProvider.userData['users'][index]['number'];
                      String userGender = createUserProvider.userData['users'][index]['gender'];
                      String userMaritalStatus = createUserProvider.userData['users'][index]['maritalStatus'];
                      String userDOJ = createUserProvider.userData['users'][index]['doj'];
                      String userNationality = createUserProvider.userData['users'][index]['nationality'];
                  return ListTile(
                    title:  CustomContainer(
                      applyShadow: true,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CustomText(
                                  text: 'Name :',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomText(
                                  text: userName,
                                  isContent: true,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: (){
                                  String name = createUserProvider.userData['users'][index]['username'];
                                  String role = createUserProvider.userData['users'][index]['role']['role'];
                                  String department = createUserProvider.userData['users'][index]['department'];
                                  String email = createUserProvider.userData['users'][index]['email'];
                                  String designation = createUserProvider.userData['users'][index]['designation'];
                                  String address = createUserProvider.userData['users'][index]['address'];
                                  String dob = createUserProvider.userData['users'][index]['dob'];
                                  String number = createUserProvider.userData['users'][index]['number'];
                                  String gender = createUserProvider.userData['users'][index]['gender'];
                                  String maritalStatus = createUserProvider.userData['users'][index]['maritalStatus'];
                                  String doj = createUserProvider.userData['users'][index]['doj'].split('T')[0];
                                  String nationality = createUserProvider.userData['users'][index]['nationality'];

                                  createUserProvider.setUserDetails(name, role, department, email, designation, address, dob, number, gender, maritalStatus, doj, nationality);
                                  Navigator.of(context)
                                      .pushNamed(MarketingManagerConstants.mrManagerCreateUserPage);
                                },
                                  child: FaIcon(FontAwesomeIcons.pen,size: 16,),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CustomText(
                                  text: 'Role :',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomText(
                                  text: userRole,
                                  isContent: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CustomText(
                                  text: 'Department :',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomText(
                                  text: userDepartment,
                                  isContent: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CustomText(
                                  text: 'Email :',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomText(
                                  text: userEmail,
                                  isContent: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CustomText(
                                  text: 'Designation :',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomText(
                                  text: userDesignation,
                                  isContent: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CustomText(
                                  text: 'Address :',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomText(
                                  text: userAddress,
                                  isContent: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CustomText(
                                  text: 'DOB :',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomText(
                                  text: userDOB,
                                  isContent: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CustomText(
                                  text: 'Number :',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomText(
                                  text: userNumber,
                                  isContent: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CustomText(
                                  text: 'Gender :',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomText(
                                  text: userGender,
                                  isContent: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CustomText(
                                  text: 'Marital Status :',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomText(
                                  text: userMaritalStatus,
                                  isContent: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CustomText(
                                  text: 'DOJ :',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomText(
                                  text: userDOJ.toString().split('T')[0],
                                  isContent: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CustomText(
                                  text: 'Nationality :',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomText(
                                  text: userNationality,
                                  isContent: true,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        }
      ),
    );
  }



}