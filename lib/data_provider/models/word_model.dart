import 'package:dictionary/domain/entities/word.dart';
import 'package:meta/meta.dart';

class WordModel extends Word {
  WordModel({
    @required String word,
    @required List<PhoneticItem> phonetics,
    @required List<Meanings> meanings,
    cardLevel = 1,
  }) : super(
          word: word,
          phonetics: phonetics,
          meanings: meanings,
          cardLevel: cardLevel,
        );

  factory WordModel.fromJson(Map<String, dynamic> json) {
    Iterable phoneticList = json['phonetics'] ?? [];
    var phonetics =
        phoneticList.map((e) => PhoneticItemModel.fromJson(e)).toList();

    Iterable meaningList = json['meanings'] ?? [];
    var meanings = meaningList.map((e) => MeaningsModel.fromJson(e)).toList();

    return WordModel(
      word: json['word'],
      phonetics: phonetics,
      meanings: meanings,
      cardLevel: json['cardLevel'] ?? 1,
    );
  }

  static Map<String, dynamic> toJson(WordModel wordModel) {
    return {
      'word': wordModel.word,
      'cardLevel': wordModel.cardLevel,
      'phonetics': wordModel.phonetics.map((e) => PhoneticItemModel.toJson(e)).toList(),
      'meanings': wordModel.meanings.map((e) => MeaningsModel.toJson(e)).toList(),
    };
  }
}

class MeaningsModel extends Meanings {
  MeaningsModel({
    @required String partOfSpeech,
    @required List<DefinitionItem> definitions,
  }) : super(
          partOfSpeech: partOfSpeech,
          definitions: definitions,
        );

  factory MeaningsModel.fromJson(Map<String, dynamic> json) {
    Iterable definitionList = json['definitions'] ?? [];
    var definitions =
        definitionList.map((e) => DefinitionItemModel.fromJson(e)).toList();

    return MeaningsModel(
      partOfSpeech: json['partOfSpeech'] ?? "",
      definitions: definitions,
    );
  }

  static Map<String, dynamic> toJson(Meanings meanings) {
    return {
      'partOfSpeech': meanings.partOfSpeech,
      'definitions': meanings.definitions.map(
        (e) => DefinitionItemModel.toJson(e),
      ).toList()
    };
  }
}

class DefinitionItemModel extends DefinitionItem {
  DefinitionItemModel({
    @required String definition,
    @required String example,
    @required List<String> synonyms,
  }) : super(
          definition: definition,
          example: example,
          synonyms: synonyms,
        );

  factory DefinitionItemModel.fromJson(Map<String, dynamic> json) {
    Iterable synonymList = json['synonyms'] ?? [];
    var synonyms = synonymList.cast<String>().toList();

    return DefinitionItemModel(
        definition: json['definition'],
        example: json['example'] ?? "",
        synonyms: synonyms);
  }

  static Map<String, dynamic> toJson(DefinitionItem definitionItem) {
    return {
      'definition': definitionItem.definition,
      'example': definitionItem.example,
      'synonyms': definitionItem.synonyms,
    };
  }
}

class PhoneticItemModel extends PhoneticItem {
  PhoneticItemModel({
    @required String text,
    @required String audioFile,
  }) : super(
          text: text,
          audioFile: audioFile,
        );

  factory PhoneticItemModel.fromJson(Map<String, dynamic> json) {
    return PhoneticItemModel(
      text: json['text'] ?? "",
      audioFile: json['audioFile'] ?? "",
    );
  }

  static Map<String, dynamic> toJson(PhoneticItem phoneticItem) {
    return {
      'text': phoneticItem.text,
      'audioFile': phoneticItem.audioFile,
    };
  }
}
