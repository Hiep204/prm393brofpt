using BookReaderApi.Models;
using Microsoft.EntityFrameworkCore;

namespace BookReaderApi.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public DbSet<Book> Books => Set<Book>();

    public DbSet<Chapter> Chapters => Set<Chapter>();

    public DbSet<Bookmark> Bookmarks => Set<Bookmark>();
    public DbSet<Favorite> Favorites => Set<Favorite>();
    protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    base.OnModelCreating(modelBuilder);
    
    modelBuilder.Entity<Favorite>()
    .HasIndex(f => new { f.UserId, f.BookId })
    .IsUnique();

    modelBuilder.Entity<Bookmark>()
        .HasOne(b => b.Book)
        .WithMany()
        .HasForeignKey(b => b.BookId)
        .OnDelete(DeleteBehavior.NoAction);

    modelBuilder.Entity<Bookmark>()
        .HasOne(b => b.Chapter)
        .WithMany()
        .HasForeignKey(b => b.ChapterId)
        .OnDelete(DeleteBehavior.NoAction);

    modelBuilder.Entity<Book>().HasData(
        new Book
        {
            Id = 1,
            Title = "Dế Mèn Phiêu Lưu Ký",
            Author = "Tô Hoài",
            CoverUrl = "https://example.com/de-men.jpg"
        },
        new Book
        {
            Id = 2,
            Title = "Tôi Thấy Hoa Vàng Trên Cỏ Xanh",
            Author = "Nguyễn Nhật Ánh",
            CoverUrl = "https://example.com/hoa-vang.jpg"
        },
        new Book
        {
            Id = 3,
            Title = "Nhà Giả Kim",
            Author = "Paulo Coelho",
            CoverUrl = "https://example.com/nha-gia-kim.jpg"
        }
    );

    modelBuilder.Entity<Chapter>().HasData(
        new Chapter
        {
            Id = 1,
            BookId = 1,
            Title = "Chương 1: Tôi sống độc lập từ thuở bé",
            Content = "Tôi sống độc lập từ thuở bé. Ấy là tục lệ lâu đời trong họ nhà dế chúng tôi. Mỗi chú dế khi lớn lên đều phải tự tìm cho mình một nơi ở riêng."
        },
        new Chapter
        {
            Id = 2,
            BookId = 1,
            Title = "Chương 2: Bài học đường đời đầu tiên",
            Content = "Tôi từng rất kiêu căng và xem thường người khác. Chính sự kiêu căng ấy đã khiến tôi nhận được một bài học lớn trong cuộc đời."
        },
        new Chapter
        {
            Id = 3,
            BookId = 1,
            Title = "Chương 3: Cuộc phiêu lưu bắt đầu",
            Content = "Sau những biến cố đầu đời, tôi quyết định rời khỏi nơi ở quen thuộc để bắt đầu chuyến phiêu lưu khám phá thế giới rộng lớn."
        },
        new Chapter
        {
            Id = 4,
            BookId = 2,
            Title = "Chương 1: Tuổi thơ",
            Content = "Tuổi thơ là những ngày tháng trong veo, có cánh đồng, con đường làng và những người bạn thân thiết."
        },
        new Chapter
        {
            Id = 5,
            BookId = 2,
            Title = "Chương 2: Những ngày mưa",
            Content = "Mưa rơi trên mái nhà, trên hàng cây và trên những ký ức dịu dàng của tuổi nhỏ."
        },
        new Chapter
        {
            Id = 6,
            BookId = 2,
            Title = "Chương 3: Hoa vàng",
            Content = "Trên bãi cỏ xanh, những bông hoa vàng nở rộ dưới ánh nắng. Đó là hình ảnh đẹp đẽ của tuổi thơ và tình bạn."
        },
        new Chapter
        {
            Id = 7,
            BookId = 3,
            Title = "Chương 1: Giấc mơ",
            Content = "Cậu bé chăn cừu luôn có một giấc mơ kỳ lạ về kho báu ở phương xa. Giấc mơ ấy thôi thúc cậu lên đường."
        },
        new Chapter
        {
            Id = 8,
            BookId = 3,
            Title = "Chương 2: Hành trình",
            Content = "Trên hành trình, cậu gặp nhiều người và học được nhiều bài học quý giá về cuộc sống."
        },
        new Chapter
        {
            Id = 9,
            BookId = 3,
            Title = "Chương 3: Kho báu",
            Content = "Sau bao thử thách, cậu nhận ra rằng kho báu lớn nhất chính là sự trưởng thành và hiểu biết về chính mình."
        }
    );
}
}