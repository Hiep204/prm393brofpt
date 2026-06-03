namespace BookReaderApi.Dtos;

public record SaveBookmarkRequest(
    string UserId,
    int BookId,
    int ChapterId
);