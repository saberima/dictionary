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
  Future<Set<String>> getWordTitleSet();
}

class WordLocalDatasourceImpl implements WordLocalDatasource {
  final SharedPreferences sharedPreferences;
  final String _key = "word_";

  WordLocalDatasourceImpl({
    @required this.sharedPreferences,
  });

  @override
  Future<WordModel> getWord(String word) async {
    var jsonString;
    if (sharedPreferences.containsKey(_key + word))
      jsonString = sharedPreferences.get(_key + word);
    if (jsonString != null) {
      return WordModel.fromJson(json.decode(jsonString));
    } else {
      throw StoreException();
    }
  }

  @override
  Future<void> storeWord(WordModel word) async {
    var wordTitleSet = await getWordTitleSet();
    wordTitleSet.add(word.word);
    _setWordTitleSet(wordTitleSet);
        sharedPreferences.setString(
          _key + word.word,
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
      Future<Set<String>> getWordTitleSet() async {
          if (sharedPreferences.containsKey("list_of_words"))
      return sharedPreferences.getStringList("list_of_words").toSet();
      else return Set();
      }
    
      void _setWordTitleSet(Set<String> wordTitleSet) {
        sharedPreferences.setStringList("list_of_words", wordTitleSet.toList());
      }
}
