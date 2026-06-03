namespace BookReaderApi.Models;

public class Bookmark
{
    public int Id { get; set; }

    public string UserId { get; set; } = string.Empty;

    public int BookId { get; set; }

    public int ChapterId { get; set; }

    public DateTime UpdatedAt { get; set; }

    public Book? Book { get; set; }

    public Chapter? Chapter { get; set; }
}