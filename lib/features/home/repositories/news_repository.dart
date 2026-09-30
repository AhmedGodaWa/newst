import '../models/article_model.dart';
import '../services/news_service.dart';

class NewsRepository {
  final NewsService _newsService;

  NewsRepository(this._newsService);

  Future<List<ArticleModel>> getTopHeadlines({required String category}) {
    return _newsService.getTopHeadlines(category: category);
  }

  Future<List<ArticleModel>> getEverything({String query = 'news'}) {
    return _newsService.getEverything(query: query);
  }
}
