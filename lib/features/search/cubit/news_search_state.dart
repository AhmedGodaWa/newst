import 'package:newst/features/home/models/article_model.dart';

sealed class NewsSearchState {}

class SearchInitial extends NewsSearchState {}

class SearchLoading extends NewsSearchState {}

class SearchSuccess extends NewsSearchState {
  final List<ArticleModel> articles;

  SearchSuccess(this.articles);
}

class SearchError extends NewsSearchState {
  final String message;

  SearchError(this.message);
}
