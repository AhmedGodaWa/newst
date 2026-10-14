import 'package:flutter/material.dart';

import 'package:newst/features/bookmark/data/bookmark_local_storage.dart';
import 'package:newst/features/home/models/article_model.dart';

class BookmarkController extends ChangeNotifier {
  BookmarkController({BookmarkLocalStorage? bookmarkLocalStorage})
    : _bookmarkLocalStorage = bookmarkLocalStorage ?? BookmarkLocalStorage();

  final BookmarkLocalStorage _bookmarkLocalStorage;

  final List<ArticleModel> _bookmarks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ArticleModel> get bookmarks => List.unmodifiable(_bookmarks);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasBookmarks => _bookmarks.isNotEmpty;

  Future<void> initialize() async {
    await loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    _isLoading = true;
    _errorMessage = null;
    _bookmarks.clear();
    notifyListeners();

    try {
      final savedBookmarks = await _bookmarkLocalStorage.getBookmarks();
      _bookmarks
        ..clear()
        ..addAll(savedBookmarks);
    } catch (e) {
      _errorMessage = 'Failed to load bookmarks';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Clears only the in-memory list when the authenticated user changes.
  /// Persisted bookmarks remain isolated under their owning user ID.
  void clearInMemory() {
    _bookmarks.clear();
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> saveBookmark(ArticleModel article) async {
    _errorMessage = null;

    try {
      await _bookmarkLocalStorage.saveBookmark(article);
      _upsertBookmark(article);
    } catch (e) {
      _errorMessage = 'Failed to save bookmark';
    }

    notifyListeners();
  }

  Future<void> removeBookmark(ArticleModel article) async {
    _errorMessage = null;

    try {
      await _bookmarkLocalStorage.removeBookmark(article);
      _bookmarks.removeWhere(
        (bookmark) => _hasSameBookmarkKey(bookmark, article),
      );
    } catch (e) {
      _errorMessage = 'Failed to remove bookmark';
    }

    notifyListeners();
  }

  Future<void> toggleBookmark(ArticleModel article) async {
    if (isBookmarked(article)) {
      await removeBookmark(article);
      return;
    }

    await saveBookmark(article);
  }

  bool isBookmarked(ArticleModel article) {
    return _bookmarks.any((bookmark) => _hasSameBookmarkKey(bookmark, article));
  }

  Future<void> clearBookmarks() async {
    _errorMessage = null;

    try {
      await _bookmarkLocalStorage.clearBookmarks();
      _bookmarks.clear();
    } catch (e) {
      _errorMessage = 'Failed to clear bookmarks';
    }

    notifyListeners();
  }

  Future<void> clearBookmarksForUser(String userId) async {
    _errorMessage = null;

    try {
      await _bookmarkLocalStorage.clearBookmarksForUser(userId);
      _bookmarks.clear();
    } catch (e) {
      _errorMessage = 'Failed to clear bookmarks';
    }

    notifyListeners();
  }

  void _upsertBookmark(ArticleModel article) {
    final existingIndex = _bookmarks.indexWhere(
      (bookmark) => _hasSameBookmarkKey(bookmark, article),
    );

    if (existingIndex == -1) {
      _bookmarks.add(article);
      return;
    }

    _bookmarks[existingIndex] = article;
  }

  bool _hasSameBookmarkKey(ArticleModel first, ArticleModel second) {
    return _bookmarkKey(first) == _bookmarkKey(second);
  }

  String _bookmarkKey(ArticleModel article) {
    final url = article.url?.trim();
    if (url != null && url.isNotEmpty) {
      return url;
    }

    return '${article.title ?? ''}|${article.publishedAt ?? ''}';
  }
}
