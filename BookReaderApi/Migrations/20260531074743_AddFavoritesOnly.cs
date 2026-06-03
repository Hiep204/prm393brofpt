using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace BookReaderApi.Migrations
{
    /// <inheritdoc />
    public partial class AddFavoritesOnly : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
{
    migrationBuilder.CreateTable(
        name: "Favorites",
        columns: table => new
        {
            Id = table.Column<int>(type: "int", nullable: false)
                .Annotation("SqlServer:Identity", "1, 1"),

            UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),

            BookId = table.Column<int>(type: "int", nullable: false),

            CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
        },
        constraints: table =>
        {
            table.PrimaryKey("PK_Favorites", x => x.Id);

            table.ForeignKey(
                name: "FK_Favorites_Books_BookId",
                column: x => x.BookId,
                principalTable: "Books",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        });

    migrationBuilder.CreateIndex(
        name: "IX_Favorites_BookId",
        table: "Favorites",
        column: "BookId");

    migrationBuilder.CreateIndex(
        name: "IX_Favorites_UserId_BookId",
        table: "Favorites",
        columns: new[] { "UserId", "BookId" },
        unique: true);
}

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
{
    migrationBuilder.DropTable(
        name: "Favorites");
}
    }
}
