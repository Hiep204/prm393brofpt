using BookReaderApi.Data;
using BookReaderApi.Dtos;
using BookReaderApi.Models;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<AppDbContext>(options =>
{
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("MyCnn")
    );
});

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutter", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

var app = builder.Build();

app.UseCors("AllowFlutter");

app.MapGet("/", () =>
{
    return Results.Ok("BookReader API is running");
});

// =======================
// BOOKS
// =======================

app.MapGet("/api/books", async (
    string? keyword,
    AppDbContext db) =>
{
    var query = db.Books.AsNoTracking();

    if (!string.IsNullOrWhiteSpace(keyword))
    {
        query = query.Where(book =>
            book.Title.Contains(keyword) ||
            book.Author.Contains(keyword)
        );
    }

    var books = await query
        .Select(book => new
        {
            book.Id,
            book.Title,
            book.Author,
            book.CoverUrl
        })
        .ToListAsync();

    return Results.Ok(books);
});

app.MapGet("/api/books/{bookId}/chapters", async (
    int bookId,
    AppDbContext db) =>
{
    var bookExists = await db.Books
        .AnyAsync(book => book.Id == bookId);

    if (!bookExists)
    {
        return Results.NotFound("Không tìm thấy sách");
    }

    var chapters = await db.Chapters
        .AsNoTracking()
        .Where(chapter => chapter.BookId == bookId)
        .Select(chapter => new
        {
            chapter.Id,
            chapter.Title
        })
        .ToListAsync();

    return Results.Ok(chapters);
});

app.MapGet("/api/books/{bookId}/chapters/{chapterId}", async (
    int bookId,
    int chapterId,
    AppDbContext db) =>
{
    var chapter = await db.Chapters
        .AsNoTracking()
        .Where(c => c.BookId == bookId && c.Id == chapterId)
        .Select(c => new
        {
            BookId = c.BookId,
            BookTitle = c.Book!.Title,
            Author = c.Book.Author,
            ChapterId = c.Id,
            ChapterTitle = c.Title,
            c.Content
        })
        .FirstOrDefaultAsync();

    if (chapter == null)
    {
        return Results.NotFound("Không tìm thấy chương");
    }

    return Results.Ok(chapter);
});

// =======================
// BOOKMARKS
// =======================

app.MapGet("/api/bookmarks/{userId}", async (
    string userId,
    AppDbContext db) =>
{
    var bookmark = await db.Bookmarks
        .AsNoTracking()
        .Where(b => b.UserId == userId)
        .OrderByDescending(b => b.UpdatedAt)
        .Select(b => new
        {
            b.BookId,
            b.ChapterId,
            BookTitle = b.Book!.Title,
            ChapterTitle = b.Chapter!.Title,
            b.UpdatedAt
        })
        .FirstOrDefaultAsync();

    if (bookmark == null)
    {
        return Results.NotFound("Chưa có bookmark");
    }

    return Results.Ok(bookmark);
});

app.MapPost("/api/bookmarks", async (
    SaveBookmarkRequest request,
    AppDbContext db) =>
{
    var chapterExists = await db.Chapters.AnyAsync(chapter =>
        chapter.Id == request.ChapterId &&
        chapter.BookId == request.BookId
    );

    if (!chapterExists)
    {
        return Results.BadRequest("Sách hoặc chương không hợp lệ");
    }

    var bookmark = await db.Bookmarks
        .FirstOrDefaultAsync(b => b.UserId == request.UserId);

    if (bookmark == null)
    {
        bookmark = new Bookmark
        {
            UserId = request.UserId,
            BookId = request.BookId,
            ChapterId = request.ChapterId,
            UpdatedAt = DateTime.UtcNow
        };

        db.Bookmarks.Add(bookmark);
    }
    else
    {
        bookmark.BookId = request.BookId;
        bookmark.ChapterId = request.ChapterId;
        bookmark.UpdatedAt = DateTime.UtcNow;
    }

    await db.SaveChangesAsync();

    return Results.Ok(new
    {
        message = "Đã lưu bookmark",
        bookmark.BookId,
        bookmark.ChapterId
    });
});

// =======================
// FAVORITES
// =======================

app.MapGet("/api/favorites/{userId}", async (
    string userId,
    AppDbContext db) =>
{
    var favoriteBooks = await db.Favorites
        .AsNoTracking()
        .Where(f => f.UserId == userId)
        .OrderByDescending(f => f.CreatedAt)
        .Select(f => new
        {
            f.Book!.Id,
            f.Book.Title,
            f.Book.Author,
            f.Book.CoverUrl
        })
        .ToListAsync();

    return Results.Ok(favoriteBooks);
});

app.MapPost("/api/favorites", async (
    SaveFavoriteRequest request,
    AppDbContext db) =>
{
    var bookExists = await db.Books
        .AnyAsync(book => book.Id == request.BookId);

    if (!bookExists)
    {
        return Results.BadRequest("Sách không tồn tại");
    }

    var existed = await db.Favorites.AnyAsync(f =>
        f.UserId == request.UserId &&
        f.BookId == request.BookId
    );

    if (existed)
    {
        return Results.Ok(new
        {
            message = "Sách đã có trong danh sách yêu thích"
        });
    }

    var favorite = new Favorite
    {
        UserId = request.UserId,
        BookId = request.BookId,
        CreatedAt = DateTime.UtcNow
    };

    db.Favorites.Add(favorite);
    await db.SaveChangesAsync();

    return Results.Ok(new
    {
        message = "Đã thêm vào yêu thích",
        favorite.BookId
    });
});

app.MapDelete("/api/favorites/{userId}/{bookId}", async (
    string userId,
    int bookId,
    AppDbContext db) =>
{
    var favorite = await db.Favorites.FirstOrDefaultAsync(f =>
        f.UserId == userId &&
        f.BookId == bookId
    );

    if (favorite == null)
    {
        return Results.NotFound("Không tìm thấy sách yêu thích");
    }

    db.Favorites.Remove(favorite);
    await db.SaveChangesAsync();

    return Results.Ok(new
    {
        message = "Đã xóa khỏi yêu thích",
        bookId
    });
});

app.Run("http://0.0.0.0:5000");