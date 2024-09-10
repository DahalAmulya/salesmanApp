import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';

class TabletBodyPotrait extends StatelessWidget {
  const TabletBodyPotrait({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        centerTitle: true,
        title: CustomText(
          text: 'Tablet',
          color: Colors.white,
          size: 24,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: Colors.green[400],
                      ),
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 120,
                          color: Colors.green[300],
                        ),
                      );
                    },
                  ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 200,
                color: Colors.green[300],
              ),
            )
          ],
        ),
      ),
    );
  }
}
