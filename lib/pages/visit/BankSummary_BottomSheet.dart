import 'package:flutter/material.dart';
import '../../themes/custom_colors.dart';
import '../../widgets/text_fields/text_from_field.dart';

class BankSummary_BottomSheet extends StatefulWidget {
  const BankSummary_BottomSheet({super.key});

  @override
  State<BankSummary_BottomSheet> createState() => _BankSummary_BottomSheetState();
}

class _BankSummary_BottomSheetState extends State<BankSummary_BottomSheet> {

  final _formState = GlobalKey<FormState>();
  final ChequeReceiptNoTextController = TextEditingController();
  final ChequeTypeTextController = TextEditingController();
  final ChequeAmountTextController = TextEditingController();
  final ChequeNoTextController = TextEditingController();
  final BankTextController = TextEditingController();
  final ChequeDateTextController = TextEditingController();
  String dropDownValue = 'one';


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
              child: TextFromFieldWithPrefixSuffix(
                applySuffixIcon: true,
                suffixIcon: IconButton(
                  onPressed: (){
                   DropdownButton(
                     items: [
                        DropdownMenuItem(child: Text('one'),value: 'one',),
                        DropdownMenuItem(child: Text('two'),value: 'two',),
                        DropdownMenuItem(child: Text('three'),value: 'three',),

                   ], onChanged: (value) {
                     setState(() {
                       dropDownValue = value!.toString();
                     });
                   },);
                  },
                    color: Colors.grey.shade800, icon: Icon(Icons.arrow_drop_down),),
                labelText: 'Cheque Type:',
                controller: ChequeTypeTextController,
                validator: (Value) {
                  return Value!.isEmpty
                      ? 'Please Enter Cheque Type'
                      : null;
                },
              ),
            ),
            SizedBox(height: 8,),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              child: TextFromFieldWithPrefixSuffix(
                labelText: 'Cheque Amount*:',
                controller: ChequeTypeTextController,
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
