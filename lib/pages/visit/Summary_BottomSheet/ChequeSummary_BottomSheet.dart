import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:nepali_utils/nepali_utils.dart';
import '../../../themes/custom_colors.dart';
import '../../../widgets/text_fields/text_from_field.dart';
import '../../../widgets/texts/custom_text.dart';

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
  final followUpDateController = TextEditingController();
  NepaliDateTime nepaliDateTime = NepaliDateTime.now();
  NepaliDateFormat nepaliDateFormatter = NepaliDateFormat('yyyy-MM-ddThh:mm');
  String formatedDateTime = '';
  String selectedChequeType = '';
  NepaliDateTime selectedDate = NepaliDateTime.now();
  String dropDownValue = 'AC Payee';
  String bankDropDownValue = 'Bank 1';
  @override
  void initState() {
    super.initState();
    formatedDateTime = nepaliDateFormatter.format(nepaliDateTime);
  }

  Future<String?> datePicker() async {
    String date = '';
    NepaliDateTime? _selectedDateTime = await picker.showMaterialDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: NepaliDateTime(2000),
      lastDate: NepaliDateTime(2090),
      initialDatePickerMode: DatePickerMode.day,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              surfaceContainerHighest: Colors.white,
              tertiary: CustomColors.primaryColor,
              onTertiary: Colors.white,
              primary: CustomColors.primaryColor, // circle color
              onPrimary: CustomColors.primaryBlack, // selected text color
              onSurface: CustomColors.primaryBlack, // default text color
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: CustomColors.primaryBlack,
                textStyle: TextStyle(
                  color: CustomColors.primaryColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  // fontFamily: 'Quicksand',
                ), // color of button's letters
                // backgroundColor: Colors.green, // Background color
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: CustomColors.primaryColor,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    // selectedDate = _selectedDateTime!;
    if (_selectedDateTime != null) {
      setState(() {
        selectedDate = _selectedDateTime;
        date = _selectedDateTime.toString();
        followUpDateController.text = selectedDate.toString().split(' ')[0];
        debugPrint(
            'followUpDateController.text = ${followUpDateController.text}');
        debugPrint('selectedDate = $date');
      });
      return date;
    }
    return date;
  }

  Container chequeType(){
    String selectedChequeType = '';
    return Container(
      child: Padding(
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
              child: Text('Bearer'),
              value: 'Bearer',
              onTap: (){},
            ),
          ],
          onChanged: (newValue) {
            setState(() {
              if (newValue != null) {
                dropDownValue = newValue;
                ChequeTypeTextController.text = dropDownValue;
              }
            },
            );
          },
        ),
      ),
    );
  }
  Container bankType() {
    String selectedBankType = '';
    print('dropdown');
    return Container(
      child: DropdownButton<String>(// Remove the default underline
        style: const TextStyle(color: Colors.black),
        value: bankDropDownValue, // Ensure value matches dropdown items
        icon: Icon(Icons.arrow_drop_down),
        items: [
          DropdownMenuItem<String>(
            child: Text('Bank 1'),
            value: 'Bank 1', // Corrected value to match bankDropDownValue
            onTap: () {},
          ),
          DropdownMenuItem<String>(
            child: Text('Bank 2'),
            value: 'Bank 2', // Corrected value to match bankDropDownValue
            onTap: () {},
          ),
        ],
        onChanged: (newValue) {
          setState(() {
            if (newValue != null) {
              bankDropDownValue = newValue!; // Ensure this value is updated with a valid one
              newValue = selectedBankType;
              BankTextController.text = bankDropDownValue;
            }
          });
        },
      ),
    );
  }



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
                suffixIcon: chequeType(),
                labelText: 'Cheque Type:',
                controller: ChequeTypeTextController,
                readOnly: true,
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
                applySuffixIcon: true,
                readOnly: true,
                onTap: (){
                  bankType();
                },
                suffixIcon: InkWell(
                  onTap: (){
                    print('bank');
                    setState(() {
                      bankType();
                    });

                  },
                  child: Icon(Icons.arrow_drop_down),
                ),
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
                controller: followUpDateController,
                readOnly: true,
                onTap: () {
                  datePicker();
                },
                validator: (value) {
                  return null;
                },
                onChange: (value) {},
                labelText: 'Follow Up Date',
                applySuffixIcon: true,
                suffixIcon: InkWell(
                  onTap: () {
                    // authProvider.toggleObscure();
                    datePicker();
                  },
                  child: Icon(
                    Icons.calendar_month,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Bearer
