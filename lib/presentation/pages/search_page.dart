import 'package:dictionary/core/errors/Failures.dart';
import 'package:dictionary/domain/usecases/search/search.dart';
import 'package:dictionary/injection_container.dart';
import 'package:dictionary/presentation/widgets/search_widgets/search_widgets.dart';
import 'package:dictionary/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'flashcard_page.dart';

class SearchPage extends StatelessWidget {
  static const routeName = "/search";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.book),
            onPressed: () =>
                Navigator.pushNamed(context, FlashcardPage.routeName),
          )
        ],
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<SearchBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SearchInput(),
              SizedBox(height: 10),
              BlocBuilder<SearchBloc, SearchState>(
                buildWhen: (prevState, state) =>
                    !(state is SearchStatePhoneticPlayed),
                builder: (context, state) {
                  if (state is SearchStateLoadInProgress) {
                    return ShowProgressIndicator();
                  } else if (state is SearchStateInitial) {
                    return DisplayMessage(message: "Type your word...");
                  } else if (state is SearchStateLoadFailure) {
                    if (state.failure is ServerFailure) {
                      return DisplayMessage(
                          message: "Could not connect to the Internet.\n" +
                              "Please check your Internet connection.");
                    } else if (state.failure is WordNotFoundFailure) {
                      return DisplayMessage(message: "Not found...");
                    }
                  } else if (state is SearchStateLoadSuccess) {
                    return DisplayWord(
                      word: state.word,
                      bucketNumber: state.bucketNumber,
                    );
                  }
                  // never happen
                  return ShowProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
