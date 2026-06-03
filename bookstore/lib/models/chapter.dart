class ChapterSummary {
  final int id;
  final String title;

  ChapterSummary({required this.id, required this.title});

  factory ChapterSummary.fromJson(Map<String, dynamic> json) {
    return ChapterSummary(id: json['id'], title: json['title']);
  }
}

class ChapterDetail {
  final int bookId;
  final String bookTitle;
  final String author;
  final int chapterId;
  final String chapterTitle;
  final String content;

  ChapterDetail({
    required this.bookId,
    required this.bookTitle,
    required this.author,
    required this.chapterId,
    required this.chapterTitle,
    required this.content,
  });

  factory ChapterDetail.fromJson(Map<String, dynamic> json) {
    return ChapterDetail(
      bookId: json['bookId'],
      bookTitle: json['bookTitle'],
      author: json['author'],
      chapterId: json['chapterId'],
      chapterTitle: json['chapterTitle'],
      content: json['content'],
    );
  }
}
