import 'package:flutter/material.dart';

import '../models/chapter.dart';
import '../services/api_service.dart';

class ReaderScreen extends StatefulWidget {
  final int bookId;
  final int chapterId;

  const ReaderScreen({
    super.key,
    required this.bookId,
    required this.chapterId,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late int currentBookId;
  late int currentChapterId;

  late Future<ChapterDetail> chapterFuture;
  late Future<List<ChapterSummary>> chaptersFuture;

  @override
  void initState() {
    super.initState();

    currentBookId = widget.bookId;
    currentChapterId = widget.chapterId;

    chaptersFuture = ApiService.getChapters(currentBookId);
    loadChapter(currentChapterId);
  }

  void loadChapter(int chapterId) {
    chapterFuture = ApiService.getChapterDetail(
      bookId: currentBookId,
      chapterId: chapterId,
    );
  }

  Future<void> saveBookmark(ChapterDetail chapter) async {
    await ApiService.saveBookmark(
      bookId: chapter.bookId,
      chapterId: chapter.chapterId,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu bookmark vào database')),
    );
  }

  void goToChapter(int chapterId) {
    setState(() {
      currentChapterId = chapterId;
      loadChapter(chapterId);
    });
  }

  int getCurrentChapterIndex(List<ChapterSummary> chapters) {
    return chapters.indexWhere((chapter) => chapter.id == currentChapterId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChapterDetail>(
      future: chapterFuture,
      builder: (context, chapterSnapshot) {
        if (chapterSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (chapterSnapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Đọc sách')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Lỗi: ${chapterSnapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final chapter = chapterSnapshot.data!;

        return Scaffold(
          backgroundColor: const Color(0xFFFFFBF0),
          appBar: AppBar(
            title: Text(chapter.bookTitle),
            actions: [
              IconButton(
                onPressed: () => saveBookmark(chapter),
                icon: const Icon(Icons.bookmark_add),
                tooltip: 'Lưu bookmark',
              ),
            ],
          ),
          body: FutureBuilder<List<ChapterSummary>>(
            future: chaptersFuture,
            builder: (context, chaptersSnapshot) {
              final chapters = chaptersSnapshot.data ?? [];
              final currentIndex = getCurrentChapterIndex(chapters);

              final bool hasPrevious = chapters.isNotEmpty && currentIndex > 0;

              final bool hasNext =
                  chapters.isNotEmpty && currentIndex < chapters.length - 1;

              ChapterSummary? previousChapter;
              ChapterSummary? nextChapter;

              if (hasPrevious) {
                previousChapter = chapters[currentIndex - 1];
              }

              if (hasNext) {
                nextChapter = chapters[currentIndex + 1];
              }

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    chapter.chapterTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Tác giả: ${chapter.author}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  const SizedBox(height: 12),

                  if (chapters.isNotEmpty && currentIndex != -1)
                    Text(
                      'Chương ${currentIndex + 1}/${chapters.length}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                  const SizedBox(height: 20),

                  Text(
                    chapter.content,
                    style: const TextStyle(fontSize: 18, height: 1.7),
                  ),

                  const SizedBox(height: 32),

                  FilledButton.icon(
                    onPressed: () => saveBookmark(chapter),
                    icon: const Icon(Icons.bookmark),
                    label: const Text('Lưu bookmark'),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: hasPrevious
                              ? () => goToChapter(previousChapter!.id)
                              : null,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Chương trước'),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: hasNext
                              ? () => goToChapter(nextChapter!.id)
                              : null,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Chương sau'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  if (chaptersSnapshot.connectionState ==
                      ConnectionState.waiting)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
