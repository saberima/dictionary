import 'package:dictionary/domain/entities/flashcard.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FlashcardState extends Equatable {
  const FlashcardState();

  @override
  List<Object> get props => [];
}

class FlashcardStateLoadCardListSuccess extends FlashcardState {
  final List<List<Flashcard>> flashcardList;

  FlashcardStateLoadCardListSuccess({@required this.flashcardList});

  @override
  List<Object> get props => [flashcardList];
}

class FlashcardStateLoadInProgress extends FlashcardState {}

class FlashcardStateLoadCardSuccess extends FlashcardState {
  final Flashcard card;

  FlashcardStateLoadCardSuccess({@required this.card});

  @override
  List<Object> get props => [card];
}

class FlashcardStateEndOfList extends FlashcardState {}
