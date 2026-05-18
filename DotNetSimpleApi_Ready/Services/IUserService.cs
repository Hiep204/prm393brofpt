using DotNetSimpleApi.DTOs.Users;

namespace DotNetSimpleApi.Services;

public interface IUserService
{
    Task<List<UserResponse>> GetAllAsync();

    Task<UserResponse> GetByIdAsync(int id);

    Task<UserResponse> CreateAsync(CreateUserRequest request);

    Task<UserResponse> UpdateAsync(int id, UpdateUserRequest request);

    Task DeleteAsync(int id);
}
