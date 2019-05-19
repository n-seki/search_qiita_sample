
import 'package:flutter/material.dart';

class ArticleSearchDelegate extends SearchDelegate<String> {

  // ignore: non_constant_identifier_names
  final List<String> _SUGGEST_DATA = [
    'android',
    'python',
    'java',
    'kotlin',
    'scala'
  ].toList();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close),
      onPressed: () => {
        Navigator.of(context).pop()
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("Result");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return ListView(
        children: [],
      );
    }

    List<Widget> suggests = _SUGGEST_DATA
        .where((str) => str.startsWith(query.toLowerCase()))
        .map((suggest) =>
        GestureDetector(
          onTap: () => close(context, suggest),
          child: Text(suggest, style: TextStyle(fontSize: 20),),
        )
    ).toList();

    return ListView(
      children: suggests,
    );
  }
}