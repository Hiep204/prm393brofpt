namespace BookReaderApi.Dtos;

public record SaveFavoriteRequest(
    string UserId,
    int BookId
);