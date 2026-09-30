import 'package:flutter/material.dart';

import '../../../core/enums/request_status.dart';
import '../../../core/network/api_exception.dart';
import '../../home/models/article_model.dart';
import '../../home/repositories/news_repository.dart';

class NewsSearchController extends ChangeNotifier {
  NewsSearchController(this.newsRepository);

  final NewsRepository newsRepository;

  List<ArticleModel> searchResults = [];

  RequestStatus searchStatus = RequestStatus.loading;

  String? searchErrorMessage;

  bool hasSearched = false;

  Future<void> searchNews(String query) async {
    hasSearched = true;
    searchStatus = RequestStatus.loading;
    searchErrorMessage = null;

    notifyListeners();

    try {
      final articles = await newsRepository.getEverything(query: query);

      searchResults = articles;
      searchStatus = RequestStatus.success;
    } on ApiException catch (e) {
      searchErrorMessage = e.message;
      searchStatus = RequestStatus.error;
    } catch (e) {
      searchErrorMessage = 'Something went wrong';
      searchStatus = RequestStatus.error;
    }

    notifyListeners();
  }
}
