import 'package:flutter/material.dart';

class CollectionsummaryBottomsheet extends StatelessWidget {
  const CollectionsummaryBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(

      child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 1,
          child: Text('collection type'),
      ),
    );
  }
}
