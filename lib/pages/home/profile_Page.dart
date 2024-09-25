import 'package:deskgoo/providers/settings_providers/profile_provider/profile_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            Navigator.of(context).pushReplacementNamed(RouteGeneratorConstants.settingPage);
          },
            child: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context,profileProvider,_) {
            profileProvider.setProfileValues(ProfileSetter());
            // profileProvider.setProfileValues(ProfileSetter(
            //     employee_name: employee_name, address: address, date_of_birth: date_of_birth, gender: gender, marital_status: marital_status, prefered_contact_email: prefered_contact_email, date_of_joining: date_of_joining, department: department, designation: designation, default_shift: default_shift, notice_number_of_days: notice_number_of_days, date_of_retirement: date_of_retirement));
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: CircleAvatar(

                    ),
                ),
                CustomContainer(
                    child:  CustomText(text: profileProvider.employee_name),
                ),
                SizedBox(height: 4,),
                CustomContainer(
                  child:  CustomText(text: profileProvider.address),
                ),
                SizedBox(height: 4,),
                CustomContainer(
                  child:  CustomText(text: profileProvider.date_of_birth),
                ),
                SizedBox(height: 4,),
                CustomContainer(
                  child:  CustomText(text: profileProvider.gender),
                ),
                SizedBox(height: 4,),
                CustomContainer(
                  child:  CustomText(text: profileProvider.marital_status),
                ),
                SizedBox(height: 4,),
                CustomContainer(
                  child:  CustomText(text: profileProvider.prefered_contact_email),
                ),
                SizedBox(height: 4,),
                CustomContainer(
                  child:  CustomText(text: profileProvider.date_of_joining),
                ),
                SizedBox(height: 4,),
                CustomContainer(
                  child:  CustomText(text: profileProvider.department),
                ),
                SizedBox(height: 4,),
                CustomContainer(
                  child:  CustomText(text: profileProvider.designation),
                ),
                SizedBox(height: 4,),
                CustomContainer(
                  child:  CustomText(text: profileProvider.default_shift),
                ),
                SizedBox(height: 8,),
                CustomContainer(
                  child:  CustomText(text: profileProvider.notice_number_of_days),
                ),
                SizedBox(height: 8,),
                CustomContainer(
                  child:  CustomText(text: profileProvider.date_of_retirement),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
