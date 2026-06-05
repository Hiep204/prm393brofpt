using DotNetSimpleApi.Entities;

namespace DotNetSimpleApi.Repositories;

public interface IUserRepository
{
    Task<List<User>> GetAllAsync();

    Task<User?> GetByIdAsync(int id);

    Task<User?> GetByUserNameAsync(string userName);

    Task<User?> GetByEmailAsync(string email);

    Task<User> CreateAsync(User user);

    Task<User> UpdateAsync(User user);

    Task<bool> DeleteAsync(int id);
}
