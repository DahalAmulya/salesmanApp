import 'package:deskgoo/providers/settings_providers/profile_provider/profile_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes/route_generator_constants.dart';
import '../../widgets/containers/custom_container.dart';

class Profile_page extends StatefulWidget {
  const Profile_page({super.key});

  @override
  State<Profile_page> createState() => _Profile_pageState();
}

class _Profile_pageState extends State<Profile_page> {

  double textFontSize = 16.0;
  FontWeight fontWeight = FontWeight.w600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        title: CustomText(text: 'Details',size: 30,fontWeight: FontWeight.w600,),
        leading: InkWell(
          onTap: (){
            Navigator.of(context).pushReplacementNamed(RouteGeneratorConstants.settingPage);
          },
            child: Icon(Icons.arrow_back,size: 30,),
        ),
      ),
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context,profileProvider,_) {
            profileProvider.setProfileValues(ProfileSetter());
            // profileProvider.setProfileValues(ProfileSetter(
            //     employee_name: employee_name, address: address, date_of_birth: date_of_birth, gender: gender, marital_status: marital_status, prefered_contact_email: prefered_contact_email, date_of_joining: date_of_joining, department: department, designation: designation, default_shift: default_shift, notice_number_of_days: notice_number_of_days, date_of_retirement: date_of_retirement));
            return SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/images/johnCena.jpg'),
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    CustomContainer(
                      width: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: 'Personal Info',
                                size: 18,
                                fontWeight: fontWeight,),
                            ],
                          ),
                        ),
                        SizedBox(height: 8,),
                        CustomText(text: "Name: ${profileProvider.employee_name}",size: textFontSize, fontWeight: fontWeight,),
                        CustomText(text: "DOB: ${profileProvider.date_of_birth}",size: textFontSize, fontWeight: fontWeight,),
                        CustomText(text: "Gender: ${profileProvider.gender}",size: textFontSize, fontWeight: fontWeight,),
                        CustomText(text: "Address: ${profileProvider.address}",size: textFontSize, fontWeight: fontWeight,),
                        CustomText(text: "Marital Status: ${profileProvider.marital_status}",size: textFontSize, fontWeight: fontWeight,),
                        CustomText(text: "Email: ${profileProvider.prefered_contact_email}",size: textFontSize, fontWeight: fontWeight,),
                      ],
                    )),
                    SizedBox(height: 8,),
                    CustomContainer(
                      width: 1,
                        child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: 'Work Info',
                                    size: 18,
                                    fontWeight: fontWeight,),
                                ],
                              ),
                            ),
                            SizedBox(height: 8,),
                            CustomText(text: "DOJ: ${profileProvider.date_of_joining}",size: textFontSize, fontWeight: fontWeight,),
                            CustomText(text: "Department: ${profileProvider.department}",size: textFontSize, fontWeight: fontWeight,),
                            CustomText(text: "Designation: ${profileProvider.designation}",size: textFontSize, fontWeight: fontWeight,),
                            CustomText(text: "Shift: ${profileProvider.default_shift}",size: textFontSize, fontWeight: fontWeight,),
                            CustomText(text: "Notice Period: ${profileProvider.notice_number_of_days}",size: textFontSize, fontWeight: fontWeight,),
                            CustomText(text: "DOR: ${profileProvider.date_of_retirement}",size: textFontSize, fontWeight: fontWeight,),
                          ],
                        ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
