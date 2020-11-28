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
