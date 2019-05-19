import 'package:flutter/material.dart';

class LibraryDetailPage extends StatelessWidget {
  final String text;

  LibraryDetailPage({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        actions: <Widget>[
          Icon(Icons.details)
        ],
      ),
      body: Center(
        child: Text(text),
      ),
    );
  }
}