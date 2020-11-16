import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Word extends Equatable {
  final String word;
  final List<PhoneticItem> phonetics;
  final List<WordDefinitions> meanings;

  Word({
    @required this.word,
    @required this.phonetics,
    @required this.meanings,
  });

  @override
  List<Object> get props => [
        word,
      ];
}

class WordDefinitions {
  final String partOfSpeech;
  final List<WordDefinitionItem> definitions;

  WordDefinitions({
    @required this.partOfSpeech,
    @required this.definitions,
  });
}

class WordDefinitionItem {
  final String definition;
  final String example;
  final List<String> synonyms;

  WordDefinitionItem({
    @required this.definition,
    @required this.example,
    @required this.synonyms,
  });
}

class PhoneticItem {
  final String text;
  final String audioFile;

  PhoneticItem({
    @required this.text,
    @required this.audioFile,
  });
}
