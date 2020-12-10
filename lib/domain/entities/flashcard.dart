import 'package:dictionary/core/setting/setting.dart';
import 'package:dictionary/domain/entities/word.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class Flashcard {
  final String wordTitle;
  Word word;
  final DateTime firstTimeSeen;
  DateTime _timeToBeSeen;
  int _bucketNumber;

  Flashcard({
    @required this.wordTitle,
    @required this.firstTimeSeen,
    @required DateTime timeToBeSeen,
    @required int bucketNumber,
  })  : _timeToBeSeen = timeToBeSeen,
        _bucketNumber = bucketNumber;

  int sendToNextBucket() => changeBucketNumber(_bucketNumber + 1);

  int changeBucketNumber(int number) {
    var delay = Settings.bucketSettings.getDelay(number);
    if (delay >= 0) {
      _bucketNumber = number;
      _timeToBeSeen =
          DateTime.parse(DateFormat("yyyyMMdd").format(DateTime.now()))
              .add(Duration(days: delay));
    } else {
      _bucketNumber = -1;
      _timeToBeSeen = null;
    }
    return _bucketNumber;
  }

  DateTime get timeToBeSeen => _timeToBeSeen;
  int get bucketNumber => _bucketNumber;
}
