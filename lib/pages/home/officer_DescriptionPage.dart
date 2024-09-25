import 'package:flutter/material.dart';

import '../../routes/route_generator_constants.dart';
import '../../widgets/containers/custom_container.dart';

class OfficerDescriptionPage extends StatefulWidget {
  const OfficerDescriptionPage({super.key});

  @override
  State<OfficerDescriptionPage> createState() => _OfficerDescriptionPageState();
}

class _OfficerDescriptionPageState extends State<OfficerDescriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(RouteGeneratorConstants.homePage);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [],
            ),
          )
        ],
      ),
    );
  }
}
