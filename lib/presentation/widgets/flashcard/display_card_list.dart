import 'package:dictionary/domain/entities/flashcard.dart';
import 'package:dictionary/domain/usecases/flashcard/flashcard.dart';
import 'package:dictionary/domain/usecases/flashcard/flashcard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class DisplayCardList extends StatelessWidget {
  final List<List<Flashcard>> cardList;

  const DisplayCardList({Key key, @required this.cardList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> cardString;
    List<int> bucketNumber;
    cardString = [];
    bucketNumber = [];
    cardList.forEach((flashcardList) {
      cardString
          .addAll(flashcardList.map((flashcard) => flashcard.wordTitle));
      bucketNumber
          .addAll(List.generate(flashcardList.length, (index) => flashcardList[index].bucketNumber));
    });
    if (bucketNumber.isEmpty)
      return Container(
        child: Center(
          child: Text("Good job. You've read all of your cards "),
        ),
      );
    else
      return ListView(
        children: [
          ShowBucketNumber(bucketNumber: bucketNumber[0]),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, position) {
              return Dismissible(
                key: Key(
                    bucketNumber[position].toString() + cardString[position]),
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    BlocProvider.of<FlashcardBloc>(context).add(
                        FlashcardEventDeleteCardRequested(
                            bucketNumber: bucketNumber[position],
                            wordTitle: cardString[position]));
                    bucketNumber.removeAt(position);
                    cardString.removeAt(position);
                  } else {
                    BlocProvider.of<FlashcardBloc>(context).add(
                        FlashcardEventShiftCardRequested(
                            currentBucket: bucketNumber[position],
                            wordTitle: cardString[position]));
                    bucketNumber.removeAt(position);
                    cardString.removeAt(position);
                  }
                },
                child: Card(
                  child: ListTile(
                    title: Center(child: Text(cardString[position])),
                  ),
                ),
                background: Row(
                  children: [
                    Container(
                      color: Colors.red,
                      width: 100,
                      child: Center(
                        child: Text(
                          "Delete from list",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      color: Colors.red,
                    ))
                  ],
                ),
                secondaryBackground: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.red,
                      ),
                    ),
                    Container(
                      color: Colors.red,
                      width: 100,
                      child: Center(
                        child: Text(
                          "Shift to next bucket",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, position) {
              if (bucketNumber[position + 1] != bucketNumber[position])
                return ShowBucketNumber(
                    bucketNumber: bucketNumber[position + 1]);
              else
                return Container();
            },
            itemCount: cardString.length,
          )
        ],
      );
  }
}

class ShowBucketNumber extends StatelessWidget {
  const ShowBucketNumber({
    Key key,
    @required this.bucketNumber,
  }) : super(key: key);

  final int bucketNumber;

  @override
  Widget build(BuildContext context) {
    String str;
    switch (bucketNumber) {
      case 0:
        str = "Recently seen";
        break;
      case 1:
        str = "Seen once";
        break;
      case 2:
        str = "Seen twice";
        break;
      default:
        str = "Seen $bucketNumber times";
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Center(
        child: Text(
          str,
          style: TextStyle(color: Colors.red, fontSize: 20),
        ),
      ),
    );
  }
}
