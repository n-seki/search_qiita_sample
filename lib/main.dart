import 'package:flutter/material.dart';

import 'data.dart';
import 'detail.dart';
import 'search.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qiita Article Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ArticleListPage(title: 'Qiita Article'),
    );
  }
}


class ArticleListPage extends StatefulWidget {
  final String title;
  ArticleListPage({@required this.title});

  @override
  _ArticleListPageState createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {

  String _query = "";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            tooltip: "Search",
            icon: const Icon(Icons.search),
            onPressed: () async {
              final String query = await showSearch(
                  context: context,
                  delegate: ArticleSearchDelegate()
              );

              if (query != null && _query != query) {
                setState(() {
                  _query = query;
                });
              }
            }
          )
        ],
      ),
      body: Center(
          child: FutureBuilder(
              future: fetchArticle(_query),
              builder: (context, snapshot) {
                if (_query.isEmpty) {
                  return Center(
                    child: Text('タグを入力'),
                  );
                }
                if (snapshot.hasData) {
                  return _createListView(snapshot.data);
                } else if (snapshot.hasError) {
                  return Text("Error!  ${snapshot.error}");
                }
                return CircularProgressIndicator();
              }
          ),
      )
    );
  }

  ListView _createListView(ArticleList articleList) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return _createListItemWidget(context, articleList.articles[index]);
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: articleList.articles.length
    );
  }

  Widget _createListItemWidget(BuildContext context, Article article) {
    return Container(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Icon(Icons.star, color: Colors.yellow[500]),
                Text(article.likesCount.toString())
              ],
            ),
          ),
          Flexible(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    child: DefaultTextStyle(
                        style: TextStyle(fontSize: 20, fontStyle: FontStyle.normal, color: Colors.black),
                        maxLines: 3,
                        child: Padding(
                            child: Text(article.title),
                            padding: EdgeInsets.all(10))
                    ),
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LibraryDetailPage(text: article.title))
                      )
                    },
                  ),
                  GestureDetector(
                      child: DefaultTextStyle(
                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.normal, color: Colors.black),
                        maxLines: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(article.user.id, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic))),
                      ),
                      onTap: () => _showUserDialog(context, article.user),
                  )
                ],
              )
          )
        ],
      ),
    );
  }

  void _showUserDialog(BuildContext context, User user) {
    showDialog(
        context: context,
        builder: (_) => Dialog(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                        width: 75,
                        height: 75,
                        child: Image.network(user.profileImageUrl)
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("id: ${user.id}"),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
                  child: Text(user.description ?? 'No Description'),
                )
              ],
            ),
          ),
        )
    );
  }
}
