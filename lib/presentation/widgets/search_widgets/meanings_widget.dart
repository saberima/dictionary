import 'package:dictionary/domain/entities/word.dart';
import 'package:dictionary/domain/usecases/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MeaningWidget extends StatelessWidget {
  final Word word;

  const MeaningWidget({Key key, this.word}) : super(key: key);

  List<Widget> meanings(BuildContext context) {
    var meanings = List<Widget>();
    word.meanings.map(
      (meaning) {
        var definitionList = List<Widget>();
        meaning.definitions.asMap().forEach((index, definition) {
          var synonymList = List<Widget>();
          if (definition.synonyms.isNotEmpty) {
            synonymList = List<Widget>.from(
              [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    "Similar: ",
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            );
            definition.synonyms.forEach((synonym) {
              synonymList.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SizedBox(
                    height: 25,
                    child: RaisedButton(
                      child: Text(synonym),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(color: Colors.purple[700])),
                      onPressed: () => BlocProvider.of<SearchBloc>(
                        context,
                      ).add(SearchEventCompleteWordRequested(synonym)),
                    ),
                  ),
                ),
              );
            });
          }
          var definitionExampleSynonyms = List<Widget>.from([
            Padding(
              padding: const EdgeInsets.only(bottom: 4, right: 4),
              child: Text(
                definition.definition,
              ),
            ),
          ]);
          if (definition.example.isNotEmpty) {
            definitionExampleSynonyms.add(Padding(
              padding: const EdgeInsets.only(bottom: 4, right: 4),
              child: Text(
                '"' + definition.example + '"',
                style: TextStyle(color: Colors.blueGrey),
              ),
            ));
          }
          if (synonymList.isNotEmpty) {
            definitionExampleSynonyms.add(Wrap(
              children: synonymList,
            ));
          }
          definitionList.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Text((index + 1).toString() + "."),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: definitionExampleSynonyms,
                  ),
                )
              ],
            ),
          );
        });
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding: EdgeInsets.only(
                  bottom: 8,
                  left: 8,
                ),
                child: Text(
                  meaning.partOfSpeech,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                )),
            Column(
              children: definitionList,
            ),
          ],
        );
      },
    ).forEach((element) {
      meanings.add(
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10,
            ),
            element
          ],
        ),
      );
    });

    return meanings;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: meanings(context));
  }
}
