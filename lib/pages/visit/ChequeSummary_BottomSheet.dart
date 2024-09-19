import 'package:flutter/material.dart';
import '../../themes/custom_colors.dart';
import '../../widgets/text_fields/text_from_field.dart';
import '../../widgets/texts/custom_text.dart';

class ChequeSummary_BottomSheet extends StatefulWidget {
  const ChequeSummary_BottomSheet({super.key});

  @override
  State<ChequeSummary_BottomSheet> createState() => _BankSummary_BottomSheetState();
}

class _BankSummary_BottomSheetState extends State<ChequeSummary_BottomSheet> {

  final _formState = GlobalKey<FormState>();
  final ChequeReceiptNoTextController = TextEditingController();
  final ChequeTypeTextController = TextEditingController();
  final ChequeAmountTextController = TextEditingController();
  final ChequeNoTextController = TextEditingController();
  final BankTextController = TextEditingController();
  final ChequeDateTextController = TextEditingController();
  String dropDownValue = 'AC Payee';


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formState,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.80,
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.040,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)),
                color: CustomColors.primaryColor,
              ),
              child: Center(
                child: Text(
                  'Cheque',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16,),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              child: TextFromFieldWithPrefixSuffix(
                labelText: 'Cheque Receipt No:',
                controller: ChequeReceiptNoTextController,
                validator: (Value) {
                  return Value!.isEmpty
                      ? 'Please Enter Cheque Receipt No'
                      : null;
                },
              ),
            ),
            SizedBox(height: 8,),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              height: MediaQuery.of(context).size.height * 0.060,
              decoration: BoxDecoration(
                color: CustomColors.primaryWhite,
                border:Border.all(color: Colors.grey.shade800,width: 1),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Row(
                children: [
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                   child: CustomText(
                     text: dropDownValue.isEmpty ? 'Cheque Type' : dropDownValue,
                     size: 16,
                     color: Colors.grey.shade800,
                   ),
                 ),
                  Spacer(),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 2.0),
                  //   child: CustomText(
                  //     text:'AC Payee',
                  //     size: 16,
                  //     color: Colors.grey.shade800,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton<String>(
                      underline: Container(
                        height: 0,
                      ),
                      style: const TextStyle(color: Colors.black),
                      value: dropDownValue,
                      // icon: Icon(Icons.arrow_drop_down),
                      items: [
                        DropdownMenuItem<String>(
                          child: Text('AC Payee'),
                          value: 'AC Payee',
                        ),
                        DropdownMenuItem<String>(
                          child: Text('hello'),
                          value: 'hello',
                          onTap: (){},
                        ),
                        DropdownMenuItem<String>(
                          child: Text('three'),
                            value: 'three',
                            onTap: (){

                            },
                        ),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          if (newValue != null) {
                            dropDownValue = newValue;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8,),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              child: TextFromFieldWithPrefixSuffix(
                labelText: 'Cheque Amount*:',
                controller: ChequeAmountTextController,
                validator: (Value) {
                  return Value!.isEmpty
                      ? 'Please Enter Cheque Amount'
                      : null;
                },
              ),
            ),
            SizedBox(height: 8,),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              child: TextFromFieldWithPrefixSuffix(
                labelText: 'Cheque No:',
                controller: ChequeNoTextController,
                validator: (Value) {
                  return Value!.isEmpty
                      ? 'Please Enter Cheque No'
                      : null;
                },
              ),
            ),
            SizedBox(height: 8,),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              child: TextFromFieldWithPrefixSuffix(
                labelText: 'Bank*:',
                controller: BankTextController,
                validator: (Value) {
                  return Value!.isEmpty
                      ? 'Please Enter your Bank'
                      : null;
                },
              ),
            ),
            SizedBox(height: 8,),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              child: TextFromFieldWithPrefixSuffix(
                labelText: 'Cheque Date*:',
                controller: BankTextController,
                validator: (Value) {
                  return Value!.isEmpty
                      ? 'Please Enter your Bank'
                      : null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


