import 'package:dictionary/domain/usecases/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({
    Key key,
  }) : super(key: key);

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  var _controller = TextEditingController();
  String word;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: _controller,
              onChanged: (value) {
                word = value;
              },
              onSubmitted: (value) => search(value),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(5),
                    topLeft: const Radius.circular(5),
                  ),
                ),
              ),
            ),
            suggestionsCallback: (string) async =>
                BlocProvider.of<SearchBloc>(context).getSuggestions(string),
            itemBuilder: (context, word) => ListTile(
              title: Text(word),
            ),
            onSuggestionSelected: (word) => search(word),
            hideOnEmpty: true,
            keepSuggestionsOnLoading: false,
          ),
        ),
        SizedBox(
          width: 50,
          child: Container(
            color: Colors.transparent,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    bottomRight: const Radius.circular(5),
                    topRight: const Radius.circular(5),
                  )),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => search(word),
              ),
            ),
          ),
        ),
      ],
    );
  }

  search(value) {
    word = value;
    if (word.isNotEmpty) {
      BlocProvider.of<SearchBloc>(context).add(
        SearchEventCompleteWordRequested(word),
      );
    }
    word = "";
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
