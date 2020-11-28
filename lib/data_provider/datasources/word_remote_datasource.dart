import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:dictionary/core/errors/exceptions.dart';
import 'package:dictionary/data_provider/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

abstract class WordRemoteDatasource {
  Future<WordModel> getWord(String word);
  Future<Uint8List> getPhonetic(String url);
}

class WordRemoteDatasourceImpl implements WordRemoteDatasource {
  final http.Client client;

  WordRemoteDatasourceImpl({@required this.client});

  Future<Uint8List> getPhonetic(String url) async {
    http.Client _client = new http.Client();
    var response = await _client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      return null;
    }
  }

  ///
  /// samples from https://dictionaryapi.dev/
  @override
  Future<WordModel> getWord(String word) async {
    final response = await client.get(
      'https://api.dictionaryapi.dev/api/v2/entries/en/$word',
    );
    switch (response.statusCode) {
      case 200:
        return WordModel.fromJson(json.decode(response.body)[0]);
      case 404:
        throw WordNotFoundException();
      default:
        throw ServiceException();
    }
  }
}

// [{"word":"book","phonetics":[{"text":"/bÊk/","audio":"https://lex-audio.useremarkable.com/mp3/book_us_1.mp3"}],"meanings":[{"partOfSpeech":"noun","definitions":[{"definition":"A written or printed work consisting of pages glued or sewn together along one side and bound in covers.","example":"a book of selected poems","synonyms":["volume","tome","work","printed work","publication","title","opus","treatise"]},{"definition":"A bound set of blank sheets for writing or keeping records in.","example":"an accounts book","synonyms":["notepad","notebook","pad","memo pad","exercise book","binder"]},{"definition":"A set of tickets, stamps, matches, checks, samples of cloth, etc., bound together.","example":"a pattern book"}]},{"partOfSpeech":"transitive verb","definitions":[{"definition":"Reserve (accommodations, a place, etc.); buy (a ticket) in advance.","example":"I have booked a table at the Swan","synonyms":["reserve","make a reservation for","arrange in advance","prearrange","arrange for","order"]},{"definition":"Make an official record of the name and other personal details of (a criminal suspect or offender)","example":"the cop booked me and took me down to the station"},{"definition":"Leave suddenly."}]}]}]
