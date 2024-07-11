import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class NewsDetailsScreen extends StatelessWidget {
  final String url;

  const NewsDetailsScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Details'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class NewsResponse {
  final List<Article> articles;

  NewsResponse({required this.articles});

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    List<Article> articles = [];
    if (json['articles'] != null) {
      json['articles'].forEach((article) {
        articles.add(Article.fromJson(article));
      });
    }
    return NewsResponse(articles: articles);
  }
}

class Article {
  final String title;
  final String url;
  final String urlToImage;

  Article({required this.title, required this.url, required this.urlToImage});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
    );
  }
}