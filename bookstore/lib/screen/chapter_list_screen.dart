import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/chapter.dart';
import '../services/api_service.dart';
import 'reader_screen.dart';

class ChapterListScreen extends StatefulWidget {
  final Book book;

  const ChapterListScreen({super.key, required this.book});

  @override
  State<ChapterListScreen> createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  late Future<List<ChapterSummary>> chaptersFuture;

  @override
  void initState() {
    super.initState();
    chaptersFuture = ApiService.getChapters(widget.book.id);
  }

  void openChapter(ChapterSummary chapter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ReaderScreen(bookId: widget.book.id, chapterId: chapter.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(title: Text(widget.book.title)),
      body: FutureBuilder<List<ChapterSummary>>(
        future: chaptersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          final chapters = snapshot.data ?? [];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                widget.book.author,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 8),

              const Text(
                'Mục lục',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              for (final chapter in chapters)
                Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.article),
                    title: Text(chapter.title),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => openChapter(chapter),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
