import 'package:flutter/material.dart';

class DisplayMessage extends StatelessWidget {
  final String message;

  const DisplayMessage({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}