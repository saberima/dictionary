import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dictionary/core/errors/exceptions.dart';
import 'package:dictionary/data_provider/models/models.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WordLocalDatasource {
  Future<WordModel> getWord(String word);
  Future<void> storeWord(WordModel word);
  Future<Uint8List> getPhonetic(String audioFile);
  Future<void> storePhonetic(Uint8List bytes, String url);
  Future<Set<String>> getWordTitleList();
  Future<void> addWordToCards(String word, int level);
  Future<List<String>> getWordsOfLevel(int level);
}

class WordLocalDatasourceImpl implements WordLocalDatasource {
  final SharedPreferences sharedPreferences;

  WordLocalDatasourceImpl({
    @required this.sharedPreferences,
  });

  @override
  Future<WordModel> getWord(String word) {
    final jsonString = sharedPreferences.get(word);
    sharedPreferences.remove(word);
    if (jsonString != null) {
      return Future.value(
        WordModel.fromJson(json.decode(jsonString)),
      );
    } else {
      throw StoreException();
    }
  }

  @override
  Future<void> storeWord(WordModel word) async {
    WordModel.toJson(word);
    sharedPreferences.setString(
      word.word,
      json.encode(
        WordModel.toJson(word),
      ),
    );
  }

  String _getFilenameFromURI(String url) => url.split('/').last;

  @override
  Future<Uint8List> getPhonetic(String url) async {
    var filename = _getFilenameFromURI(url);

    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    if (file.existsSync())
      return file.readAsBytes();
    else
      return null;
  }

  @override
  Future<void> storePhonetic(Uint8List bytes, String url) async {
    var filename = _getFilenameFromURI(url);

    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    file.writeAsBytes(bytes);
  }

  @override
  Future<Set<String>> getWordTitleList() async {
    return sharedPreferences.getKeys();
  }

  @override
  Future<void> addWordToCards(String word, int level) async {
    var list = await getWordsOfLevel(level);
    list.add(word);
    sharedPreferences.setStringList(
      "cardsOfLevel" + level.toString(),
      list,
    );
  }

  Future<List<String>> getWordsOfLevel(int level) async {
    return sharedPreferences.getStringList("cardsOfLevel" + level.toString());
  }
}
