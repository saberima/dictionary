import 'package:dictionary/core/setting/setting.dart';
import 'package:dictionary/domain/entities/flashcard.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class FlashcardModel extends Flashcard {
  FlashcardModel({
    @required String word,
    @required DateTime firstTimeSeen,
    @required DateTime timeToBeSeen,
    @required int bucketNumber,
  }) : super(
          wordTitle: word,
          firstTimeSeen: firstTimeSeen,
          timeToBeSeen: timeToBeSeen,
          bucketNumber: bucketNumber,
        );

  factory FlashcardModel.fromJson(Map<String, dynamic> json) {
    return FlashcardModel(
      word: json['word'],
      firstTimeSeen: DateTime.parse(json['firstTimeSeen']),
      timeToBeSeen: DateTime.parse(json['timeToBeSeen']),
      bucketNumber: json['bucketNumber'],
    );
  }

  factory FlashcardModel.newWord(String wordTitle) {
    return FlashcardModel(
      word: wordTitle,
      firstTimeSeen: DateTime.now(),
      timeToBeSeen:
          DateTime.parse(DateFormat("yyyyMMdd").format(DateTime.now()))
              .add(Duration(days: Settings.bucketSettings.getDelay(0))),
      bucketNumber: 0,
    );
  }

  static Map<String, dynamic> toJson(FlashcardModel flashcardModel) {
    return {
      'word': flashcardModel.wordTitle,
      'firstTimeSeen': flashcardModel.firstTimeSeen.toString(),
      'timeToBeSeen': flashcardModel.timeToBeSeen.toString(),
      'bucketNumber': flashcardModel.bucketNumber,
    };
  }
}
