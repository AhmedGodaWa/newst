import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newst/features/home/repositories/news_repository.dart';
import 'package:newst/features/search/cubit/news_search_state.dart';
import '../../../core/network/api_exception.dart';

class NewsSearchCubit extends Cubit<NewsSearchState> {
  final NewsRepository newsRepository;

  NewsSearchCubit(this.newsRepository) : super(SearchInitial());

  Future<void> searchNews(String query) async {
    emit(SearchLoading());

    try {
      final articles = await newsRepository.getEverything(query: query);

      emit(SearchSuccess(articles));
    } on ApiException catch (e) {
      emit(SearchError(e.message));
    } catch (e) {
      emit(SearchError('Something went wrong'));
    }
  }
}
