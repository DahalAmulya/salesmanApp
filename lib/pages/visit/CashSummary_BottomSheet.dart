import 'package:flutter/material.dart';

import '../../themes/custom_colors.dart';
import '../../widgets/text_fields/text_from_field.dart';

class CashSummary_BottomSheet extends StatefulWidget {
  final String CashReceiptNo;
  final String CashAmount;
  CashSummary_BottomSheet({
    super.key,
    this.CashReceiptNo = '',
    this.CashAmount = '',
  });

  @override
  State<CashSummary_BottomSheet> createState() =>
      _CashSummary_BottomSheetState();
}

class _CashSummary_BottomSheetState extends State<CashSummary_BottomSheet> {
  final _formState = GlobalKey<FormState>();
  final CashReceiptTextController = TextEditingController();
  final CashAmountTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.32,
      width: MediaQuery.of(context).size.width * 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Form(
        key: _formState,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1,
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
                        'Cash',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: TextFromFieldWithPrefixSuffix(
                      labelText: 'Cash Receipt No*:',
                      controller: CashReceiptTextController,
                      validator: (Value) {
                        return Value!.isEmpty
                            ? 'Please Enter Cash Receipt No'
                            : null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: TextFromFieldWithPrefixSuffix(
                      labelText: 'Cash Amount*:',
                      controller: CashAmountTextController,
                      validator: (Value) {
                        return Value!.isEmpty
                            ? 'Please Enter Cash Amount'
                            : null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          if (_formState.currentState!.validate()) {
                            debugPrint(
                                '_formState.currentState!.validate() = ${_formState.currentState!.validate()}');
                          } else {
                            debugPrint(
                                '_formState.currentState!.validate() = ${_formState.currentState!.validate()}');
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: CustomColors.primaryColor,
                            ),
                            child: Center(
                              child: Text(
                                  'Next',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
