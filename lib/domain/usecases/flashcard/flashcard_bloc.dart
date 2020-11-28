import 'package:flutter_bloc/flutter_bloc.dart';
import 'flashcard.dart';

class FlashcardBloc extends Bloc<FlashcardEvent, FlashcardState> {
  FlashcardBloc(FlashcardState initialState) : super(initialState);

  @override
  Stream<FlashcardState> mapEventToState(FlashcardEvent event) async* {}
}
