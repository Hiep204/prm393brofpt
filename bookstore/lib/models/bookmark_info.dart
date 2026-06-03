class BookmarkInfo {
  final int bookId;
  final int chapterId;
  final String bookTitle;
  final String chapterTitle;

  BookmarkInfo({
    required this.bookId,
    required this.chapterId,
    required this.bookTitle,
    required this.chapterTitle,
  });

  factory BookmarkInfo.fromJson(Map<String, dynamic> json) {
    return BookmarkInfo(
      bookId: json['bookId'],
      chapterId: json['chapterId'],
      bookTitle: json['bookTitle'],
      chapterTitle: json['chapterTitle'],
    );
  }
}
