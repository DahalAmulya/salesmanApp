import 'package:deskgoo/routes/app_route_constants.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../providers/themes_provider/theme_changer_provider.dart';
import '../../themes/custom_colors.dart';
import '../../widgets/app_bars/custom_app_bars.dart';
import '../../widgets/text_fields/text_from_field.dart';
import '../../widgets/texts/custom_text.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:geolocator/geolocator.dart';


class RemoteAttendencePage extends StatefulWidget {

  const RemoteAttendencePage({super.key});

  @override
  State<RemoteAttendencePage> createState() => _RemoteAttendencePageState();
}

class _RemoteAttendencePageState extends State<RemoteAttendencePage> {
  double latitude = 0.0;
  double longitude = 0.0;
  bool isSwitched = false;
  final NepaliDateTime nepaliTime = NepaliDateTime.now();
  final _formState = GlobalKey<FormState>();
  final descriptionTextController = TextEditingController();
  final dateTimeController = TextEditingController();
  final gpsLocationController = TextEditingController();
  @override
  void initState() {
    super.initState();
    NepaliDateFormat formattedTime = NepaliDateFormat("yyyy-MM-dd HH:mm");
    getTime();
    gpsLocationController.text = 'Latitude: ${latitude.toString()}, Longitude: ${longitude.toString()}';
    getLocation();
  }

  Future<void>getTime()async{
    setState(() {
      var currentNepaliTime = NepaliDateTime.now();
      String formattedTime = NepaliDateFormat("yyyy-MM-dd HH:mm").format(currentNepaliTime); // Format the date and time
      setState(() {
        final nepaliTime = formattedTime; // Set it to the state variable.
      });
    });
  }

  Future<void> getLocation() async{


    try{
      await askPermission(); // This do not exists
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        gpsLocationController.text = 'Latitude: ${latitude.toString()}, Longitude: ${longitude.toString()}';
      });
      print('longitude: $latitude');
      print('longitude: $longitude');
    }catch(e){
      print(e);
    }
  }

Future<void>askPermission()async{
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return askPermission();
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryBackgroundColor,
      appBar: _appBar(context),
      body: _buildUI(context),
    );
  }

  PreferredSize _appBar(context) {
    print('appbar build');
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: Consumer<ThemeChangerProvider>(
        builder: (context, provider, _) {
          print('CustomAppBar build');
          return CustomAppBar(
            tabName: 'Remote Attendance',
            backgroundColor: Colors.grey.shade100,
            leadingIcon: Icons.arrow_back,
            onTapLeadingIcon: () {
              GoRouter.of(context)
                  .pushReplacementNamed(MyAppRouteConstants.homeNavBarRouteName);
            },
            showLeading: true,
            applyShadow: true,
            onPressedThemeIcon: () {
              provider.toogleIsChooseThemePopUp();
            },
          );
        },
      ),
    );
  }

  Widget _buildUI(context) {
    return SingleChildScrollView(
      // scrollDirection: Axis.vertical,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomContainer(
              width: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: isSwitched ? 'Check In' : 'Check Out',
                          color: Colors.black,
                          size: 16,
                        ),
                        Switch.adaptive(
                          activeColor: Colors.blue,
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Remarks here*',
                        labelStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                      maxLines: 5,
                      controller: descriptionTextController,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height * 0.25,
                  //     width: MediaQuery.of(context).size.width * 0.90,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(8),
                  //       color: Color(0xfffFFFFFF),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.grey.withOpacity(0.5),
                  //           spreadRadius: 2,
                  //           blurRadius: 5,
                  //         ),
                  //       ],
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 16.0),
                  //       child: CustomText(
                  //         text: 'Remark here*',
                  //         color: Colors.grey,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 16,),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomText(text: 'Date and Time'),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: TextFromFieldWithPrefixSuffix(
                        controller: dateTimeController,
                        applyPrefix: false,
                        readOnly: true,
                        // labelText: nepaliTime.isNotEmpty ? nepaliTime : 'Loading...',
                        validator: (String) {
                          return null;
                      },

                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomText(text: 'GPS Location'),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: TextFromFieldWithPrefixSuffix(
                        controller: gpsLocationController,
                        applyPrefix: false,
                        readOnly: true,
                        // labelText: nepaliTime.isNotEmpty ? nepaliTime : 'Loading...',
                        validator: (String) {
                          return null;
                        },

                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}