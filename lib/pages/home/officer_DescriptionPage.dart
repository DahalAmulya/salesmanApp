import 'package:deskgoo/providers/settings_providers/profile_provider/officerName_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes/route_generator_constants.dart';
import '../../widgets/containers/custom_container.dart';
import 'ScreenWIdth.dart';

class OfficerDescriptionPage extends StatefulWidget {
  const OfficerDescriptionPage({super.key});

  @override
  State<OfficerDescriptionPage> createState() => _OfficerDescriptionPageState();
}

class _OfficerDescriptionPageState extends State<OfficerDescriptionPage> {

  double screenHeight = ScreenUtil.getScreenHeight();
  double screenWidth = ScreenUtil.getScreenWidth();
  double officerDescriptionContainerHeight = 0.0;
  MarketingProvider? _marketingProvider;

  @override
  void initState() {
    _marketingProvider = Provider.of<MarketingProvider>(context, listen: false);
    super.initState();
  }

  List<Map<String, dynamic>> officerDescription = [
    {
      "client Name": "John",
      "Address": "Biratnagar",
      "Phone Number": 9819022062,
      "Date Time": "2022-01-15 10:30:00",
    },
    {
      "client Name": "Jane",
      "Address": "Kathmandu",
      "Phone Number": 9845678901,
      "Date Time": "2022-01-16 11:45:00",
    },
    {
      "client Name": "David",
      "Address": "Lalitpur",
      "Phone Number": 9876543210,
      "Date Time": "2022-01-17 12:30:00",
    },
    {
      "client Name": "Michael",
      "Address": "Pokhara",
      "Phone Number": 9898989898,
      "Date Time": "2022-01-18 13:15:00",
    },
    {
      "client Name": "Emily",
      "Address": "Bharatpur",
      "Phone Number": 9874563210,
      "Date Time": "2022-01-19 14:00:00",
    },
    {
      "client Name": "Sarah",
      "Address": "Butwal",
      "Phone Number": 9854321098,
      "Date Time": "2022-01-20 14:45:00",
    }
  ];

  @override
  Widget build(BuildContext context) {
    print('width1 = $screenWidth');
    if (screenWidth < 375) {
      officerDescriptionContainerHeight = 0.88;
    }
    if (screenWidth >= 375 && screenWidth <= 393) {
      officerDescriptionContainerHeight = 0.78;
    }
    if (screenWidth >= 414) {
      officerDescriptionContainerHeight = 0.80;
    }
    if (screenWidth >= 430) {
      officerDescriptionContainerHeight = 0.18;
    }
    if (screenWidth > 430) {
      officerDescriptionContainerHeight = 0.24;
    }
    if(screenWidth > 500 && screenWidth>=500){
      officerDescriptionContainerHeight = 0.18;
    }

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop(RouteGeneratorConstants.homePage);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Consumer<MarketingProvider>(
            builder: (context,MarketingProvider,_) {
              return CustomText(text: MarketingProvider.name,size: 24,fontWeight: FontWeight.w600,);
            }
          ),
          SizedBox(height: 8,),
          Expanded(
            child: ListView.builder(
              itemCount: officerDescription.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * officerDescriptionContainerHeight,
                      width: MediaQuery.of(context).size.width * 0.90,
                      decoration: BoxDecoration(
                        color: CustomColors.primaryWhite,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                            child: Text(
                                '${officerDescription[index]['client Name']}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                            child: Text(
                                '${officerDescription[index]['Address']}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                            child: Text(
                                '${officerDescription[index]['Phone Number']}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                            child: Text(
                                '${officerDescription[index]['Date Time']}'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8,),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
