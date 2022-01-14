import 'package:dictionary/domain/entities/word.dart';
import 'package:dictionary/domain/usecases/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardWordAndPhoneticsWidget extends StatelessWidget {
  final Word word;
  final int bucketNumber;
  final Color textColor;

  const FlashcardWordAndPhoneticsWidget({
    Key key,
    @required this.word,
    @required this.bucketNumber,
    @required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var wordAndPhonetics = List<Widget>.from([
      Text(
        word.word,
        style: TextStyle(fontSize: 30, color: textColor),
      ),
    ]);
    word.phonetics
        .map(
      (phoneticItem) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 7,
            ),
            Text(
              phoneticItem.text,
              style: TextStyle(color: textColor),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.volume_up,
                  color: textColor,
                ),
                onPressed: () => BlocProvider.of<SearchBloc>(context).add(
                  SearchEventPlayPhoneticRequested(phoneticItem.audioFile),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .forEach((element) {
      wordAndPhonetics.add(SizedBox(
        width: 10,
      ));
      wordAndPhonetics.add(element);
    });

    return Column(
      children: wordAndPhonetics,
    );
  }
}
