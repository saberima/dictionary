import 'dart:convert';
import 'package:dictionary/core/errors/exceptions.dart';
import 'package:dictionary/data_provider/models/flashcard_model.dart';
import 'package:dictionary/data_provider/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

abstract class FlashcardDatasource {
  List<DateTime> getUnreadDates();
  List<String> getWordListOfDate(DateTime date);
  Future<void> removeCardFromDate(DateTime date, String word);
  FlashcardModel getFlashcard(String wordTitle);
  Future<FlashcardModel> addNewWordToCards(String wordTitle);
  Future<void> moveFlashcardToNextBucket(FlashcardModel flashcardModel);
  DateTime get lastUpdatedDate;
}

class FlashcardLocalDatasourceImpl implements FlashcardDatasource {
  final SharedPreferences sharedPreferences;

  DateTime _lastUpdatedDate;

  DateTime get lastUpdatedDate => _lastUpdatedDate;

  FlashcardLocalDatasourceImpl({@required this.sharedPreferences}) {
    String key = "flashcard_datesource_last_update";
    if (sharedPreferences.containsKey(key))
      _lastUpdatedDate = DateTime.parse(sharedPreferences.getString(key));
    else
      _lastUpdatedDate = DateTime.now().subtract(Duration(days: 365));
  }

  @override
  List<DateTime> getUnreadDates() {
    // ????????????????
    try {
      String key = "flashcard_unread_dates";
      if (sharedPreferences.containsKey(key))
        return sharedPreferences
            .getStringList(key)
            .map((e) => DateTime.parse(e))
            .toList();
    } on Exception {}
    return [];
  }

  @override
  List<String> getWordListOfDate(DateTime date) {
    try {
      String key = "flashcard_words_date_" + _getDateToString(date);
      if (sharedPreferences.containsKey(key))
        return sharedPreferences.getStringList(key);
    } on Exception {}
    return [];
  }

  @override
  FlashcardModel getFlashcard(String wordTitle) {
    String key = "flashcard_word_" + wordTitle;
    var jsonString;
    if (sharedPreferences.containsKey(key))
      jsonString = sharedPreferences.get(key);
    if (jsonString != null) {
      return FlashcardModel.fromJson(json.decode(jsonString));
    } else {
      throw StoreException();
    }
  }

  @override
  Future<void> removeCardFromDate(DateTime date, String word) async {
    try {
      String dateAsString = _getDateToString(date);
      String key = "flashcard_words_date_" + dateAsString;
      var wordList;
      if (sharedPreferences.containsKey(key)) {
        wordList = sharedPreferences.getStringList(key);
        wordList.remove(word);
        if (wordList.length > 0)
          await sharedPreferences.setStringList(key, wordList);
        else {
          await sharedPreferences.remove(key);

          key = "flashcard_unread_dates";
          var dateList = sharedPreferences.getStringList(key);
          dateList.remove(dateAsString);
          sharedPreferences.setStringList(key, dateList);
        }
        _lastUpdatedDate = DateTime.now();
      }
    } on Exception {}
  }

  @override
  Future<FlashcardModel> addNewWordToCards(String wordTitle) async {
    var flashcardModel = FlashcardModel.newWord(wordTitle);
    await _storeCard(flashcardModel);
    _lastUpdatedDate = DateTime.now();
    return flashcardModel;
  }

  Future<void> _storeCard(FlashcardModel flashcardModel) async {
    await sharedPreferences.setString(
      "flashcard_word_" + flashcardModel.wordTitle,
      json.encode(FlashcardModel.toJson(
        flashcardModel,
      )),
    );
    await _addCardToDate(flashcardModel.timeToBeSeen, flashcardModel.wordTitle);
  }

  @override
  Future<void> moveFlashcardToNextBucket(FlashcardModel flashcardModel) async {
    await removeCardFromDate(
        flashcardModel.timeToBeSeen, flashcardModel.wordTitle);
    flashcardModel.sendToNextBucket();
    if (flashcardModel.timeToBeSeen != null) {
      await _storeCard(flashcardModel);
    }
    _lastUpdatedDate = DateTime.now();
  }

  String _getDateToString(DateTime date) {
    return DateFormat("yyyyMMdd").format(date);
  }

  Future<void> _addCardToDate(DateTime date, String wordTitle) async {
    try {
      String dateAsString = _getDateToString(date);
      String key = "flashcard_words_date_" + dateAsString;
      List<String> wordList = [];
      try {
        if (sharedPreferences.containsKey(key))
          wordList = sharedPreferences.getStringList(key);
      } on Exception {}
      if (!wordList.contains(wordTitle)) {
        wordList.add(wordTitle);
        await sharedPreferences.setStringList(key, wordList);
      }

      key = "flashcard_unread_dates";
      List<String> dateList = [];
      try {
        if (sharedPreferences.containsKey(key))
          dateList = sharedPreferences.getStringList(key);
      } on Exception {}
      if (!dateList.contains(dateAsString)) dateList.add(dateAsString);
      await sharedPreferences.setStringList(key, dateList);
    } on Exception {}
  }
}
