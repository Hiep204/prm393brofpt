namespace BookReaderApi.Models;

public class Book
{
    public int Id { get; set; }

    public string Title { get; set; } = string.Empty;

    public string Author { get; set; } = string.Empty;

    public string CoverUrl { get; set; } = string.Empty;

    public List<Chapter> Chapters { get; set; } = new();
}