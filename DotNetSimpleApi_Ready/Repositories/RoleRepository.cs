using DotNetSimpleApi.Data;
using DotNetSimpleApi.Entities;
using Microsoft.EntityFrameworkCore;

namespace DotNetSimpleApi.Repositories;

public class RoleRepository : IRoleRepository
{
    private readonly AppDbContext _context;

    public RoleRepository(AppDbContext context)
    {
        _context = context;
    }

    public async Task<Role?> GetByNameAsync(string name)
    {
        string normalizedName = name.Trim().ToUpperInvariant();

        return await _context.Roles
            .FirstOrDefaultAsync(role => role.Name == normalizedName);
    }
}
