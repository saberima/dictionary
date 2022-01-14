import 'package:dictionary/data_provider/repositories/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'flashcard.dart';

class FlashcardBloc extends Bloc<FlashcardEvent, FlashcardState> {
  final FlashcardRepository flashcardRepository;

  FlashcardBloc({@required this.flashcardRepository})
      : super(FlashcardStateLoadCardListSuccess(
            flashcardList: flashcardRepository.getList()));

  @override
  Stream<FlashcardState> mapEventToState(FlashcardEvent event) async* {
    if (event is FlashcardEventCardRequested) {
      if (event.wordTitle == null)
        yield FlashcardStateEndOfList();
      else {
        yield FlashcardStateLoadInProgress();
        final card = await flashcardRepository.getCard(
            event.bucketNumber, event.wordTitle);
        yield FlashcardStateLoadCardSuccess(card: card);
      }
    } else if (event is FlashcardEventDeleteCardRequested) {
      yield FlashcardStateLoadInProgress();
      flashcardRepository.removeCard(event.bucketNumber, event.wordTitle);
      yield FlashcardStateLoadCardListSuccess(
          flashcardList: flashcardRepository.getList());
    } else if (event is FlashcardEventShiftCardRequested) {
      yield FlashcardStateLoadInProgress();
      await flashcardRepository.moveCardToNextBucket(
          event.currentBucket, event.wordTitle);
      yield FlashcardStateLoadCardListSuccess(
          flashcardList: flashcardRepository.getList());
    }
  }
}
