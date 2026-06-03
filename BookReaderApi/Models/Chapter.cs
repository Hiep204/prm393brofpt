namespace BookReaderApi.Models;

public class Chapter
{
    public int Id { get; set; }

    public string Title { get; set; } = string.Empty;

    public string Content { get; set; } = string.Empty;

    public int BookId { get; set; }

    public Book? Book { get; set; }
}