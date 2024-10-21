import 'package:flutter/material.dart';

class CustomExpansionTile extends StatefulWidget {

  // final String title;
  // final Icon icon;

  const CustomExpansionTile({
    super.key,
    // required this.title,
    // required this.icon,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}
     bool _customIcon = false;

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('expansion tile'),
      ),
      body: Column(
        children: <Widget>[
          ExpansionTile(
            title: Text('Family Details'),
            trailing: Icon(Icons.arrow_drop_down),
            children: [
              ListTile(
                title: Text('title 1'),
              ),
              ListTile(
                title: Text('title 2'),
              ),
              ListTile(
                title: Text('title 3'),
              ),
            ],
            onExpansionChanged: (bool value){
              setState(() => _customIcon = value);
            },
          )
        ],
      ),
    );
  }
}




