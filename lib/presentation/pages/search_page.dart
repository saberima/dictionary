import 'package:dictionary/core/errors/Failures.dart';
import 'package:dictionary/domain/usecases/search/search.dart';
import 'package:dictionary/injection_container.dart';
import 'package:dictionary/presentation/widgets/search_widgets/search_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'flashcard_page.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        centerTitle: true,
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
                    return Container(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
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
                    return Expanded(
                      child: DisplayWord(word: state.word),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
