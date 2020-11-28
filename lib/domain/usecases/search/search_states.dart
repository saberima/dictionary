import 'package:dictionary/core/errors/Failures.dart';
import 'package:dictionary/domain/entities/word.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchStateInitial extends SearchState {}

class SearchStateLoadInProgress extends SearchState {}

class SearchStatePhoneticPlayed extends SearchState {}

class SearchStateLoadSuccess extends SearchState {
  final Word word;

  const SearchStateLoadSuccess({@required this.word});

  @override
  List<Object> get props => [word];
}

class SearchStateLoadFailure extends SearchState {
  final Failure failure;

  const SearchStateLoadFailure({@required this.failure});

  @override
  List<Object> get props => [failure];
}