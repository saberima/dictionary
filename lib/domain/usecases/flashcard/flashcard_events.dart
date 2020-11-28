import 'package:equatable/equatable.dart';

abstract class FlashcardEvent extends Equatable {
  const FlashcardEvent();
}

class FlashcardEventWordRequested extends FlashcardEvent {
  final String word;

  const FlashcardEventWordRequested(this.word);

  @override
  List<Object> get props => [word];
}
