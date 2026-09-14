import 'package:flutter/material.dart';
import 'package:newst/core/enums/request_status.dart';
import 'package:newst/core/network/api_exception.dart';
import 'package:newst/features/home/models/article_model.dart';
import 'package:newst/features/home/services/news_service.dart';

class HomeController extends ChangeNotifier {
  final NewsService newsService = NewsService();

  // Top Headlines
  List<ArticleModel> topHeadlinesArticles = [];
  RequestStatus topHeadlinesStatus = RequestStatus.loading;
  String? topHeadlinesErrorMessage;

  // Everything
  List<ArticleModel> everythingArticles = [];
  RequestStatus everythingStatus = RequestStatus.loading;
  String? everythingErrorMessage;

  Future<void> fetchTopHeadlines() async {
    topHeadlinesStatus = RequestStatus.loading;
    topHeadlinesErrorMessage = null;

    notifyListeners();

    try {
      final articles = await newsService.getTopHeadlines();

      topHeadlinesArticles = articles;
      topHeadlinesStatus = RequestStatus.success;
    } on ApiException catch (e) {
      topHeadlinesErrorMessage = e.message;
      topHeadlinesStatus = RequestStatus.error;
    } catch (e) {
      topHeadlinesErrorMessage = 'Something went wrong';
      topHeadlinesStatus = RequestStatus.error;
    }

    notifyListeners();
  }

  Future<void> fetchEverything() async {
    everythingStatus = RequestStatus.loading;
    everythingErrorMessage = null;
    notifyListeners();

    try {
      final articles = await newsService.getEverything();

      everythingArticles = articles;
      everythingStatus = RequestStatus.success;
    } on ApiException catch (e) {
      everythingErrorMessage = e.message;
      everythingStatus = RequestStatus.error;
    } catch (e) {
      everythingErrorMessage = 'Something went wrong';
      everythingStatus = RequestStatus.error;
    }

    notifyListeners();
  }
}
