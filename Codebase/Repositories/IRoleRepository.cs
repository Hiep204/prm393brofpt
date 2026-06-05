using DotNetSimpleApi.Entities;

namespace DotNetSimpleApi.Repositories;

public interface IRoleRepository
{
    Task<Role?> GetByNameAsync(string name);
}
