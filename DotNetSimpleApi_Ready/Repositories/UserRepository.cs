using DotNetSimpleApi.Data;
using DotNetSimpleApi.Entities;
using Microsoft.EntityFrameworkCore;

namespace DotNetSimpleApi.Repositories;

public class UserRepository : IUserRepository
{
    private readonly AppDbContext _context;

    public UserRepository(AppDbContext context)
    {
        _context = context;
    }

    public async Task<List<User>> GetAllAsync()
    {
        return await _context.Users
            .Include(user => user.Role)
            .AsNoTracking()
            .ToListAsync();
    }

    public async Task<User?> GetByIdAsync(int id)
    {
        return await _context.Users
            .Include(user => user.Role)
            .FirstOrDefaultAsync(user => user.Id == id);
    }

    public async Task<User?> GetByUserNameAsync(string userName)
    {
        return await _context.Users
            .Include(user => user.Role)
            .FirstOrDefaultAsync(user => user.UserName == userName);
    }

    public async Task<User?> GetByEmailAsync(string email)
    {
        return await _context.Users
            .Include(user => user.Role)
            .FirstOrDefaultAsync(user => user.Email == email);
    }

    public async Task<User> CreateAsync(User user)
    {
        _context.Users.Add(user);
        await _context.SaveChangesAsync();
        return user;
    }

    public async Task<User> UpdateAsync(User user)
    {
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        return user;
    }

    public async Task<bool> DeleteAsync(int id)
    {
        User? user = await _context.Users.FindAsync(id);

        if (user == null)
        {
            return false;
        }

        _context.Users.Remove(user);
        return await _context.SaveChangesAsync() > 0;
    }
}
