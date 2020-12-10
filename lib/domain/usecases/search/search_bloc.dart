import 'package:dictionary/data_provider/repositories/repositories.dart';
import 'package:dictionary/domain/usecases/search/play_phonetic.dart';
import 'package:dictionary/domain/usecases/search/search.dart';
import 'package:dictionary/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final WordRepository wordRepository;
  final FlashcardRepository flashcardRepository;

  SearchBloc(
      {@required this.wordRepository, @required this.flashcardRepository})
      : super(SearchStateInitial());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchEventCompleteWordRequested) {
      yield SearchStateLoadInProgress();
      final either = await wordRepository.getWord(
        event.word,
      );

      yield* either.fold(
        (failure) async* {
          yield SearchStateLoadFailure(failure: failure);
        },
        (word) async* {
          yield SearchStateLoadSuccess(
            word: word,
            bucketNumber: flashcardRepository.getBucketNumber(word.word),
          );
        },
      );
    } else if (event is SearchEventPlayPhoneticRequested) {
      var either = await wordRepository.getPhonetic(event.audioFile);
      yield* either.fold((l) => null, (phonetic) async* {
        sl<PlayPhonetic>().play(phonetic);
        yield SearchStatePhoneticPlayed();
      });
    } else if (event is SearchEventStoreInFlashcardRequested) {
      var bucketNumber = event.bucketNumber;
      if (event.store)
        bucketNumber =
            (await flashcardRepository.addCard(event.word.word)).bucketNumber;
      else {
        flashcardRepository.removeCard(event.bucketNumber, event.word.word);
        bucketNumber = -1;
      }
      yield SearchStateLoadSuccess(
        word: event.word,
        bucketNumber: bucketNumber,
      );
    }
  }

  Future<List<String>> getSuggestions(String string) async {
    return wordRepository.getWordsLike(string);
  }
}
