import 'package:dictionary/domain/entities/word.dart';
import 'package:dictionary/presentation/widgets/search_widgets/search_widgets.dart';
import 'package:flutter/material.dart';

class DisplayWord extends StatelessWidget {
  final Word word;
  final int bucketNumber;

  const DisplayWord({
    Key key,
    this.word,
    this.bucketNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.brown),
        ),
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.indigo[500],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.7),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(0, 2)),
              ],
            ),
            child: WordAndPhoneticsWidget(
              word: word,
              bucketNumber: bucketNumber,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: MeaningWidget(
                word: word,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
