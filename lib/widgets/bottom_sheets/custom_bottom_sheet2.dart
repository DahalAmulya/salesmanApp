import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:flutter/material.dart';

import '../text_fields/text_from_field.dart';

class CustomBottomSheet2 extends StatefulWidget {
  const CustomBottomSheet2({super.key});

  @override
  State<CustomBottomSheet2> createState() => _CustomBottomSheet2State();
}

class _CustomBottomSheet2State extends State<CustomBottomSheet2> {
  List<String> foundStates = [];
  List<String> states = ['Achham', 'Arghakhanchi', 'Baitadi', 'Bajhang','Odisha','Bihar','Karnataka','Kerala','Madhya Pradesh','Maharashtra','Meghalaya',
  ];
  bool isVisibleForStateList = false;

  final stateTextEditingController = TextEditingController();

  void _stateFilter(String enteredKeyword) {
    setState(() {
      isVisibleForStateList = true;
    });
    List<String> result = [];
    if (enteredKeyword.isEmpty) {
      result = states;
    } else {

      result = states
          .where((state) => state
          .toString()
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      foundStates = result;
    });
  }


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.primaryColor,
          title: Text('Select State'),
        ),
        body: CustomContainer(
          verticalMargin: 16.0,
          child: Column(
            children: [
              Center(
                  child: TextFromFieldWithPrefixSuffix(
                    applyPrefix: true,
                    prefixIcon: Icon(Icons.search),
                    applySuffixIcon: true,
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    controller: stateTextEditingController,
                    labelText: 'Select State',
                    onTap: () {
                      setState(() {
                        isVisibleForStateList = !isVisibleForStateList;
                      });
                    },
                    onChange: (value) => _stateFilter(value!),
                    validator: (Value) {
                      return null;
                    },
                  ),
              ),
              SizedBox(height: 12,),
              Visibility(
                visible: isVisibleForStateList,
                child: ColoredBox(
                  color: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: foundStates.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          setState(() {
                            stateTextEditingController.text =
                            foundStates[index];
                            if( stateTextEditingController.text ==
                                foundStates[index]){
                              isVisibleForStateList = !isVisibleForStateList;
                            }
                          });
                          print('${foundStates[index]}');
                        },
                        title: Text('${foundStates[index]}'),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// SizedBox(height: 8,),
// Visibility(
//   visible: isVisibleForStateList,
//   child: ColoredBox(
//     color: Colors.white,
//     child: ListView.builder(
//       shrinkWrap: true,
//       itemCount: foundStates.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           onTap: () {
//             setState(() {
//               stateTextEditingController.text =
//               foundStates[index];
//               if( stateTextEditingController.text ==
//                   foundStates[index]){
//                 isVisibleForStateList = !isVisibleForStateList;
//               }
//             });
//             print('${foundStates[index]}');
//           },
//           title: Text('${foundStates[index]}'),
//         );
//       },
//     ),
//   ),
// ),