import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/book.dart';
import '../models/bookmark_info.dart';
import '../models/chapter.dart';

class ApiService {
  static const String userId = 'demo-user';

  static String get baseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000/api';
    }

    return 'http://localhost:5000/api';
  }

  static Future<List<Book>> getFavoriteBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/favorites/$userId'));

    if (response.statusCode != 200) {
      throw Exception('Không tải được danh sách yêu thích');
    }

    final List data = jsonDecode(response.body);

    return data.map((item) => Book.fromJson(item)).toList();
  }

  static Future<void> addFavorite(int bookId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/favorites'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'bookId': bookId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Không thêm được sách yêu thích');
    }
  }

  static Future<void> removeFavorite(int bookId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/favorites/$userId/$bookId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Không xóa được sách yêu thích');
    }
  }

  static Future<List<Book>> getBooks({String keyword = ''}) async {
    final uri = Uri.parse('$baseUrl/books').replace(
      queryParameters: keyword.trim().isEmpty
          ? null
          : {'keyword': keyword.trim()},
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Không tải được danh sách sách');
    }

    final List data = jsonDecode(response.body);

    return data.map((item) => Book.fromJson(item)).toList();
  }

  static Future<List<ChapterSummary>> getChapters(int bookId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/books/$bookId/chapters'),
    );

    if (response.statusCode != 200) {
      throw Exception('Không tải được mục lục');
    }

    final List data = jsonDecode(response.body);

    return data.map((item) => ChapterSummary.fromJson(item)).toList();
  }

  static Future<ChapterDetail> getChapterDetail({
    required int bookId,
    required int chapterId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/books/$bookId/chapters/$chapterId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Không tải được nội dung chương');
    }

    return ChapterDetail.fromJson(jsonDecode(response.body));
  }

  static Future<BookmarkInfo?> getBookmark() async {
    final response = await http.get(Uri.parse('$baseUrl/bookmarks/$userId'));

    if (response.statusCode == 404) {
      return null;
    }

    if (response.statusCode != 200) {
      throw Exception('Không tải được bookmark');
    }

    return BookmarkInfo.fromJson(jsonDecode(response.body));
  }

  static Future<void> saveBookmark({
    required int bookId,
    required int chapterId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bookmarks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'bookId': bookId,
        'chapterId': chapterId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Không lưu được bookmark');
    }
  }
}
