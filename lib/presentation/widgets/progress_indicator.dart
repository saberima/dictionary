import 'package:flutter/material.dart';

class ShowProgressIndicator extends StatelessWidget {
  const ShowProgressIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
