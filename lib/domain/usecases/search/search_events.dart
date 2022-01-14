import 'package:dictionary/domain/entities/word.dart';
import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchEventCompleteWordRequested extends SearchEvent {
  final String word;

  const SearchEventCompleteWordRequested(this.word);

  @override
  List<Object> get props => [word];
}

class SearchEventStoreInFlashcardRequested extends SearchEvent {
  final Word word;
  final bool store;
  final int bucketNumber;

  const SearchEventStoreInFlashcardRequested(this.word, this.store, this.bucketNumber);

  @override
  List<Object> get props => [word, store, bucketNumber];
}

class SearchEventPlayPhoneticRequested extends SearchEvent {
  final String audioFile;

  const SearchEventPlayPhoneticRequested(this.audioFile);

  @override
  List<Object> get props => [audioFile];
}

class SearchEventIncompleteWordRequested extends SearchEvent {
  final String word;

  const SearchEventIncompleteWordRequested(this.word);

  @override
  List<Object> get props => [word];
}
