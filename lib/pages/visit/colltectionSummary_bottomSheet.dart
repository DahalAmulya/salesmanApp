import 'package:deskgoo/themes/custom_colors.dart';
import 'package:flutter/material.dart';
import 'CashSummary_BottomSheet.dart';
import 'ChequeSummary_BottomSheet.dart';

class CollectionsummaryBottomsheet extends StatelessWidget {
  const CollectionsummaryBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.20,
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
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              color: CustomColors.primaryColor,
            ),
            child: Center(
              child: Text(
                'Select Collection Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(context: context, builder: (builder) => CashSummary_BottomSheet());
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.050,
              color: CustomColors.primaryWhite,
              child: Center(
                child: Text(
                  'Cash',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(context: context, builder: (builder) => ChequeSummary_BottomSheet());
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.050,
              color: CustomColors.primaryWhite,
              child: Center(
                child: Text(
                  'Cheque',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.050,
              color: CustomColors.primaryWhite,
              child: Center(
                child: Text(
                  'Bank',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
