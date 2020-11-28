import 'package:flutter/material.dart';

class FlashcardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard'),
        centerTitle: true,
      ),
      body: buildBody(context),
    );
  }

  buildBody(BuildContext context) {
    return Text("data");
  }
}
