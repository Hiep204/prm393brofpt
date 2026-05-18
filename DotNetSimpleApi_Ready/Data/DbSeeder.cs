using DotNetSimpleApi.Entities;
using DotNetSimpleApi.Services;

namespace DotNetSimpleApi.Data;

public static class DbSeeder
{
    public static void Seed(AppDbContext context, IPasswordService passwordService)
    {
        if (!context.Roles.Any())
        {
            context.Roles.AddRange(
                new Role { Name = "ADMIN" },
                new Role { Name = "USER" }
            );

            context.SaveChanges();
        }

        Role adminRole = context.Roles.First(role => role.Name == "ADMIN");
        Role userRole = context.Roles.First(role => role.Name == "USER");

        if (!context.Users.Any())
        {
            context.Users.AddRange(
                new User
                {
                    UserName = "admin",
                    Email = "admin@example.com",
                    PasswordHash = passwordService.HashPassword("Admin@123"),
                    RoleId = adminRole.Id
                },
                new User
                {
                    UserName = "user",
                    Email = "user@example.com",
                    PasswordHash = passwordService.HashPassword("User@123"),
                    RoleId = userRole.Id
                }
            );

            context.SaveChanges();
        }

        if (!context.Products.Any())
        {
            context.Products.AddRange(
                new Product { Name = "Demo Product 1", Price = 100000, Stock = 10 },
                new Product { Name = "Demo Product 2", Price = 250000, Stock = 5 }
            );

            context.SaveChanges();
        }
    }
}
