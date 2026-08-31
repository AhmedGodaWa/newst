import 'package:flutter/material.dart';
import 'package:newst/core/network/api_exception.dart';
import 'package:newst/features/home/models/article_model.dart';
import 'package:newst/features/home/services/news_service.dart';

class HomeController extends ChangeNotifier {
  final NewsService newsService = NewsService();

  // Top Headlines
  List<ArticleModel> topHeadlinesArticles = [];

  bool isTopHeadlinesLoading = false;

  String? topHeadlinesErrorMessage;

  // Everything
  List<ArticleModel> everythingArticles = [];

  bool isEverythingLoading = false;

  String? everythingErrorMessage;

  Future<void> fetchTopHeadlines() async {
    isTopHeadlinesLoading = true;
    topHeadlinesErrorMessage = null;

    notifyListeners();

    try {
      final articles = await newsService.getTopHeadlines();

      topHeadlinesArticles = articles;
    } on ApiException catch (e) {
      topHeadlinesErrorMessage = e.message;
    } catch (e) {
      topHeadlinesErrorMessage = 'Something went wrong';
    }

    isTopHeadlinesLoading = false;

    notifyListeners();
  }

  Future<void> fetchEverything() async {
    isEverythingLoading = true;
    everythingErrorMessage = null;

    notifyListeners();

    try {
      final articles = await newsService.getEverything();

      everythingArticles = articles;
    } on ApiException catch (e) {
      everythingErrorMessage = e.message;
    } catch (e) {
      everythingErrorMessage = 'Something went wrong';
    }

    isEverythingLoading = false;

    notifyListeners();
  }
}
