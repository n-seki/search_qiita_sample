import 'package:http/http.dart' as http;
import 'dart:convert';

Future<ArticleList> fetchArticle(String tag) async {
  final http.Response response = await http.get(
      'https://qiita.com/api/v2/tags/$tag/items?page=1&per_page=20');

  if (response.statusCode == 200) {
    return ArticleList.fromJson(json.decode(response.body));
  } else {
    throw Exception("Failed fetch");
  }
}

class ArticleList {
  final List<Article> articles;

  ArticleList({this.articles});

  factory ArticleList.fromJson(List<dynamic> json) {
    return ArticleList(
      articles: json.map((j) => Article.fromJson(j as Map<String, dynamic>)).toList()
    );
  }
}

class Article {
  final String title;
  final int likesCount;
  final User user;

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        title: json['title'],
        likesCount: json['likes_count'],
        user: User.fromJson(json['user'] as Map<String, dynamic>)
    );
  }

  Article({this.title, this.likesCount, this.user});
}

class User {
  final String id;
  final String description;
  final String profileImageUrl;

  User({this.id, this.description, this.profileImageUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        description: json['description'],
        profileImageUrl: json['profile_image_url']
    );
  }
}