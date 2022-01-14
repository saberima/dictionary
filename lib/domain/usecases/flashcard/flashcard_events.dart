import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class FlashcardEvent extends Equatable {
  const FlashcardEvent();

  @override
  List<Object> get props => [];
}

class FlashcardEventCardRequested extends FlashcardEvent {
    final String wordTitle;
  final int bucketNumber;

  FlashcardEventCardRequested({@required this.bucketNumber, @required this.wordTitle});

  @override
  List<Object> get props => [bucketNumber, wordTitle];
}

class FlashcardEventShiftCardRequested extends FlashcardEvent {
    final String wordTitle;
  final int currentBucket;

  FlashcardEventShiftCardRequested({@required this.currentBucket, @required this.wordTitle});

  @override
  List<Object> get props => [currentBucket, wordTitle];
}

class FlashcardEventDeleteCardRequested extends FlashcardEvent {
  final String wordTitle;
  final int bucketNumber;

  FlashcardEventDeleteCardRequested({@required this.bucketNumber, @required this.wordTitle});

  @override
  List<Object> get props => [bucketNumber, wordTitle];
}
