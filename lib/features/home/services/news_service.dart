import 'package:newst/core/constants/api_constants.dart';
import 'package:newst/core/network/api_service.dart';
import 'package:newst/features/home/models/article_model.dart';

class NewsService {
  final ApiService apiService = ApiService();

  Future<List<ArticleModel>> getTopHeadlines() async {
    final url = Uri.https(ApiConstants.baseUrl, ApiConstants.topHeadlines, {
      'apiKey': ApiConstants.apiKey,
      'country': 'us',
    });

    final data = await apiService.get(url);

    return (data['articles'] as List<dynamic>)
        .map(
          (article) => ArticleModel.fromJson(article as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<ArticleModel>> getEverything() async {
    final url = Uri.https(ApiConstants.baseUrl, ApiConstants.everything, {
      'apiKey': ApiConstants.apiKey,
      'q': 'bitcoin',
    });

    final data = await apiService.get(url);

    return (data['articles'] as List<dynamic>)
        .map(
          (article) => ArticleModel.fromJson(article as Map<String, dynamic>),
        )
        .toList();
  }
}

// class NewsService {
//   Future<List<ArticleModel>> getTopHeadlines() async {
//     final url = Uri.https('newsapi.org', '/v2/top-headlines', {
//       'apiKey': 'd80a0626981f42e38a423575327bda88',
//       'country': 'us',
//     });

//     final response = await http.get(url);

//     final data = jsonDecode(response.body);

//     final articles = (data['articles'] as List<dynamic>)
//         .map(
//           (article) => ArticleModel.fromJson(article as Map<String, dynamic>),
//         )
//         .toList();

//     return articles;
//   }

//   Future<List<ArticleModel>> getEverything() async {
//     final url = Uri.https('newsapi.org', '/v2/everything', {
//       'apiKey': 'd80a0626981f42e38a423575327bda88',
//       'q': 'bitcoin',
//     });

//     final response = await http.get(url);

//     final data = jsonDecode(response.body);

//     final articles = (data['articles'] as List<dynamic>)
//         .map(
//           (article) => ArticleModel.fromJson(article as Map<String, dynamic>),
//         )
//         .toList();

//     return articles;
//   }
// }
