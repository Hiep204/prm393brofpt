import 'dart:async';

import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/bookmark_info.dart';
import '../services/api_service.dart';
import 'chapter_list_screen.dart';
import 'reader_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> booksFuture;
  BookmarkInfo? bookmark;

  final TextEditingController searchController = TextEditingController();
  Timer? searchDebounce;

  List<Book> favoriteBooks = [];
  Set<int> favoriteBookIds = {};

  @override
  void initState() {
    super.initState();
    booksFuture = ApiService.getBooks();
    loadBookmark();
    loadFavorites();
  }

  @override
  void dispose() {
    searchDebounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadBookmark() async {
    final data = await ApiService.getBookmark();

    if (!mounted) return;

    setState(() {
      bookmark = data;
    });
  }

  Future<void> loadFavorites() async {
    final data = await ApiService.getFavoriteBooks();

    if (!mounted) return;

    setState(() {
      favoriteBooks = data;
      favoriteBookIds = data.map((book) => book.id).toSet();
    });
  }

  void searchBooks(String value) {
    searchDebounce?.cancel();

    searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;

      setState(() {
        booksFuture = ApiService.getBooks(keyword: value);
      });
    });
  }

  void clearSearch() {
    searchDebounce?.cancel();
    searchController.clear();

    setState(() {
      booksFuture = ApiService.getBooks();
    });
  }

  Future<void> toggleFavorite(Book book) async {
    final bool isFavorite = favoriteBookIds.contains(book.id);

    try {
      if (isFavorite) {
        await ApiService.removeFavorite(book.id);

        if (!mounted) return;

        setState(() {
          favoriteBookIds.remove(book.id);
          favoriteBooks.removeWhere((item) => item.id == book.id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa khỏi sách yêu thích')),
        );
      } else {
        await ApiService.addFavorite(book.id);

        if (!mounted) return;

        setState(() {
          favoriteBookIds.add(book.id);

          final existed = favoriteBooks.any((item) => item.id == book.id);
          if (!existed) {
            favoriteBooks.insert(0, book);
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã thêm vào sách yêu thích')),
        );
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $error')));
    }
  }

  void openBook(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChapterListScreen(book: book)),
    ).then((_) {
      loadBookmark();
      loadFavorites();
    });
  }

  void openBookmark() {
    if (bookmark == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReaderScreen(
          bookId: bookmark!.bookId,
          chapterId: bookmark!.chapterId,
        ),
      ),
    ).then((_) => loadBookmark());
  }

  Widget buildSearchBox() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Tìm kiếm sách hoặc tác giả...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchController.text.isEmpty
            ? null
            : IconButton(icon: const Icon(Icons.clear), onPressed: clearSearch),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.indigo, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (value) {
        setState(() {});
        searchBooks(value);
      },
    );
  }

  Widget buildBookmarkCard() {
    if (bookmark == null) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Colors.indigo.shade50,
      child: ListTile(
        leading: const Icon(Icons.bookmark, color: Colors.indigo),
        title: const Text(
          'Đọc tiếp',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${bookmark!.bookTitle}\n${bookmark!.chapterTitle}'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: openBookmark,
      ),
    );
  }

  Widget buildFavoriteSection() {
    if (favoriteBooks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Sách yêu thích',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 145,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: favoriteBooks.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final book = favoriteBooks[index];

              return InkWell(
                onTap: () => openBook(book),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 210,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.indigo.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.favorite, color: Colors.red),
                      const SizedBox(height: 10),
                      Text(
                        book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        book.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildBookItem(Book book) {
    final bool isFavorite = favoriteBookIds.contains(book.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 48,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.indigo.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.menu_book, color: Colors.indigo),
        ),
        title: Text(
          book.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(book.author),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => toggleFavorite(book),
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
        onTap: () => openBook(book),
      ),
    );
  }

  Widget buildEmptyResult() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey.shade500),
            const SizedBox(height: 12),
            const Text(
              'Không tìm thấy sách phù hợp',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(title: const Text('Bookstore'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildBookmarkCard(),
                if (bookmark != null) const SizedBox(height: 16),
                buildSearchBox(),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: booksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Lỗi: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final books = snapshot.data ?? [];

                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    buildFavoriteSection(),

                    const SizedBox(height: 16),

                    const Text(
                      'Danh sách sách',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (books.isEmpty) buildEmptyResult(),

                    for (final book in books) buildBookItem(book),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
