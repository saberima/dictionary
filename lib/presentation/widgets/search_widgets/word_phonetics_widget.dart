import 'package:dictionary/domain/entities/word.dart';
import 'package:dictionary/domain/usecases/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WordAndPhoneticsWidget extends StatelessWidget {
  final Word word;

  const WordAndPhoneticsWidget({Key key, this.word}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var wordAndPhonetics = List<Widget>.from([
      Center(
        child: SizedBox(
          width: 150,
          height: 70,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                word.word,
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
        ),
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
              style: TextStyle(color: Colors.white),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.volume_up,
                  color: Colors.white,
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

    return Row(
      children: wordAndPhonetics,
    );
  }
}
