import 'package:dictionary/core/setting/setting.dart';
import 'package:dictionary/data_provider/datasources/datasources.dart';
import 'package:dictionary/data_provider/models/models.dart';
import 'package:dictionary/domain/entities/flashcard.dart';
import 'package:meta/meta.dart';

abstract class FlashcardRepository {
  Future<Flashcard> getCard(int bucketNumber, String wordTitle);
  List<List<FlashcardModel>> getList();
  void removeCard(int bucketNumber, String wordTitle);
  Future<void> moveCardToNextBucket(int bucketNumber, String wordTitle);
  Future<FlashcardModel> addCard(String wordTitle);
  int getBucketNumber(String word);
}

class FlashcardRepositoryImpl implements FlashcardRepository {
  final FlashcardDatasource flashcardDatasource;
  final WordLocalDatasource localDatasource;

  DateTime _lastUpdatedDate;

  List<List<FlashcardModel>> flashcardList;
  Map<String, int> flashcardLocation;
  List<DateTime> unreadDates;
  Map<DateTime, int> unreadWordCountForDates;

  FlashcardRepositoryImpl({
    @required this.flashcardDatasource,
    @required this.localDatasource,
  }) {
    _reload();
  }

  _reload() {
    unreadDates = flashcardDatasource.getUnreadDates();
    flashcardList = List.generate(
      Settings.bucketSettings.getBucketCount(),
      (index) => List<FlashcardModel>(),
    );
    flashcardLocation = Map<String, int>();
    unreadWordCountForDates = Map<DateTime, int>();

    for (var date in unreadDates) {
      var wordTitleList = flashcardDatasource.getWordListOfDate(date);
      unreadWordCountForDates[date] = wordTitleList.length;

      for (var wordTitle in wordTitleList) {
        var flashcard = flashcardDatasource.getFlashcard(wordTitle);
        flashcardList[flashcard.bucketNumber].add(flashcard);
        flashcardLocation[flashcard.wordTitle] =
            flashcardList[flashcard.bucketNumber].length - 1;
      }
    }

    _lastUpdatedDate = DateTime.now();
  }

  @override
  Future<FlashcardModel> addCard(String wordTitle) async {
    var flashcardModel = await flashcardDatasource.addNewWordToCards(wordTitle);
    if (!flashcardList[flashcardModel.bucketNumber].contains(flashcardModel)) {
      flashcardList[flashcardModel.bucketNumber].add(flashcardModel);
      flashcardLocation[wordTitle] =
          flashcardList[flashcardModel.bucketNumber].length - 1;
      if (unreadWordCountForDates.containsKey(flashcardModel.timeToBeSeen))
        unreadWordCountForDates[flashcardModel.timeToBeSeen]++;
      else {
        unreadWordCountForDates[flashcardModel.timeToBeSeen] = 1;
        unreadDates.add(flashcardModel.timeToBeSeen);
      }
    }
    return flashcardModel;
  }

  @override
  Future<FlashcardModel> getCard(int bucketNumber, String wordTitle) async {
    var flashcardModel = _getCard(bucketNumber, wordTitle);
    if (flashcardModel != null) {
      flashcardModel.word = await localDatasource.getWord(wordTitle);
      await flashcardDatasource.moveFlashcardToNextBucket(flashcardModel);
      return flashcardModel;
    } else
      return null;
  }

  FlashcardModel _getCard(int bucketNumber, String wordTitle) {
    if (bucketNumber < flashcardList.length &&
        flashcardLocation.containsKey(wordTitle))
      return flashcardList[bucketNumber][flashcardLocation[wordTitle]];
    else
      return null;
  }

  @override
  void removeCard(int bucketNumber, String wordTitle) {
    var flashcard = _getCard(bucketNumber, wordTitle);
    flashcardDatasource.removeCardFromDate(flashcard.timeToBeSeen, wordTitle);
    for (var i = flashcardLocation[wordTitle] + 1;
        i < flashcardList[bucketNumber].length;
        ++i) {
      flashcardLocation[flashcardList[bucketNumber][i].wordTitle]--;
    }
    var date =
        flashcardList[bucketNumber][flashcardLocation[wordTitle]].timeToBeSeen;
    unreadWordCountForDates[date]--;
    flashcardList[bucketNumber].removeAt(flashcardLocation[wordTitle]);
    flashcardLocation.remove(wordTitle);
    if (unreadWordCountForDates[date] == 0) {
      unreadWordCountForDates.remove(date);
      unreadDates.remove(date);
    }
  }

  @override
  List<List<FlashcardModel>> getList() {
    if (flashcardDatasource.lastUpdatedDate.compareTo(_lastUpdatedDate) > 0) {
      _reload();
    }
    return flashcardList;
  }

  @override
  Future<void> moveCardToNextBucket(int bucketNumber, String wordTitle) async =>
      await getCard(bucketNumber, wordTitle);

  @override
  int getBucketNumber(String wordTitle) {
    var i = flashcardList.length - 1;
    while (i >= 0) {
      if (flashcardList[i].contains(wordTitle)) return i;
      i--;
    }
    return i;
  }
}
