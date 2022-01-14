import 'package:dictionary/domain/usecases/flashcard/flashcard.dart';
import 'package:dictionary/injection_container.dart';
import 'package:dictionary/presentation/widgets/flashcard/flashcard_widgets.dart';
import 'package:dictionary/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardPage extends StatelessWidget {
  static const routeName = "/flashcard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard'),
        centerTitle: true,
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<FlashcardBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FlashcardBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocBuilder<FlashcardBloc, FlashcardState>(
            // buildWhen: (prevState, state) =>
            //     !(state is FlashcardState),
            builder: (context, state) {
              if (state is FlashcardStateLoadInProgress) {
                return ShowProgressIndicator();
              } else if (state is FlashcardStateEndOfList) {
                return DisplayMessage(
                  message: "You don't have any word in search list",
                );
              } else if (state is FlashcardStateLoadCardSuccess) {
                return DisplayCubicWord(card: state.card);
              } else if (state is FlashcardStateLoadCardListSuccess) {
                return DisplayCardList(cardList: state.flashcardList);
              }
              // never happen
              return ShowProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
