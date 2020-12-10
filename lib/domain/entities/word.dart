import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Word extends Equatable {
  final String word;
  final List<PhoneticItem> phonetics;
  final List<Meanings> meanings;

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

class Meanings {
  final String partOfSpeech;
  final List<DefinitionItem> definitions;

  Meanings({
    @required this.partOfSpeech,
    @required this.definitions,
  });
}

class DefinitionItem {
  final String definition;
  final String example;
  final List<String> synonyms;

  DefinitionItem({
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
