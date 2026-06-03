namespace BookReaderApi.Models; 

public class Favorite
{
    public int Id { get; set; }

    public string UserId { get; set; } = string.Empty;

    public int BookId { get; set; }

    public DateTime CreatedAt { get; set; }

    public Book? Book { get; set; }
}