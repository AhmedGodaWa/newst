import 'package:hive_flutter/hive_flutter.dart';

import 'package:newst/features/auth/data/auth_service.dart';
import 'package:newst/features/home/models/article_model.dart';

class BookmarkLocalStorage {
  static const String _boxName = 'bookmark_box';
  static const String _bookmarksKeyPrefix = 'bookmarked_articles';

  final AuthService _authService;

  BookmarkLocalStorage({AuthService? authService})
    : _authService = authService ?? AuthService();

  Future<Box<dynamic>> _openBox() {
    return Hive.openBox<dynamic>(_boxName);
  }

  Future<List<ArticleModel>> getBookmarks() async {
    final box = await _openBox();
    final bookmarksKey = _currentUserBookmarksKey();

    if (bookmarksKey == null) {
      return [];
    }

    final savedBookmarks = box.get(bookmarksKey);

    if (savedBookmarks is! List) {
      return [];
    }

    return savedBookmarks.whereType<Map>().map((bookmark) {
      final articleJson = Map<String, dynamic>.from(bookmark);
      return ArticleModel.fromJson(articleJson);
    }).toList();
  }

  Future<void> saveBookmark(ArticleModel article) async {
    final bookmarksKey = _currentUserBookmarksKey();

    if (bookmarksKey == null) {
      return;
    }

    final bookmarks = await getBookmarks();
    final bookmarkKey = _bookmarkKey(article);
    final existingIndex = bookmarks.indexWhere(
      (bookmark) => _bookmarkKey(bookmark) == bookmarkKey,
    );

    if (existingIndex == -1) {
      bookmarks.add(article);
    } else {
      bookmarks[existingIndex] = article;
    }

    await _saveBookmarks(bookmarksKey, bookmarks);
  }

  Future<void> removeBookmark(ArticleModel article) async {
    final bookmarksKey = _currentUserBookmarksKey();

    if (bookmarksKey == null) {
      return;
    }

    final bookmarkKey = _bookmarkKey(article);
    final bookmarks = await getBookmarks();
    bookmarks.removeWhere((bookmark) => _bookmarkKey(bookmark) == bookmarkKey);
    await _saveBookmarks(bookmarksKey, bookmarks);
  }

  Future<bool> isBookmarked(ArticleModel article) async {
    final bookmarkKey = _bookmarkKey(article);
    final bookmarks = await getBookmarks();
    return bookmarks.any((bookmark) => _bookmarkKey(bookmark) == bookmarkKey);
  }

  Future<void> clearBookmarks() async {
    final userId = _currentUserId;

    if (userId == null) {
      return;
    }

    await clearBookmarksForUser(userId);
  }

  Future<void> clearBookmarksForUser(String userId) async {
    final box = await _openBox();
    await box.delete(_bookmarksKeyForUser(userId));
  }

  Future<void> _saveBookmarks(
    String bookmarksKey,
    List<ArticleModel> bookmarks,
  ) async {
    final box = await _openBox();
    final bookmarkJson = bookmarks
        .map((bookmark) => bookmark.toJson())
        .toList();
    await box.put(bookmarksKey, bookmarkJson);
  }

  String? _currentUserBookmarksKey() {
    final userId = _currentUserId;

    if (userId == null) {
      return null;
    }

    return _bookmarksKeyForUser(userId);
  }

  String _bookmarksKeyForUser(String userId) {
    return '${_bookmarksKeyPrefix}_$userId';
  }

  String? get _currentUserId => _authService.currentUser?.id;

  String _bookmarkKey(ArticleModel article) {
    final url = article.url?.trim();
    if (url != null && url.isNotEmpty) {
      return url;
    }

    return '${article.title ?? ''}|${article.publishedAt ?? ''}';
  }
}
