import 'package:flutter/material.dart';
import 'package:newst/core/enums/request_status.dart';
import 'package:newst/core/network/api_exception.dart';
import 'package:newst/features/home/models/article_model.dart';
import 'package:newst/features/home/repositories/news_repository.dart';

class HomeController extends ChangeNotifier {
  HomeController(this.newsRepository) {
    initialize();
  }
  final NewsRepository newsRepository;

  // Top Headlines
  List<ArticleModel> topHeadlinesArticles = [];
  RequestStatus topHeadlinesStatus = RequestStatus.loading;
  String? topHeadlinesErrorMessage;

  // Everything
  List<ArticleModel> everythingArticles = [];
  RequestStatus everythingStatus = RequestStatus.loading;
  String? everythingErrorMessage;

  String selectedCategory = 'general';

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    _isInitialized = true;

    await Future.wait([fetchEverything(), fetchTopHeadlines()]);
  }

  Future<void> fetchTopHeadlines() async {
    topHeadlinesStatus = RequestStatus.loading;
    topHeadlinesErrorMessage = null;

    notifyListeners();

    try {
      final articles = await newsRepository.getTopHeadlines(
        category: selectedCategory,
      );

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
      final articles = await newsRepository.getEverything(query: 'news');

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

  void selectCategory(String category) {
    selectedCategory = category;
    fetchTopHeadlines();
  }
}
