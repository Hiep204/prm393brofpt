using DotNetSimpleApi.DTOs.Users;
using DotNetSimpleApi.Entities;
using DotNetSimpleApi.Exceptions;
using DotNetSimpleApi.Repositories;

namespace DotNetSimpleApi.Services;

public class UserService : IUserService
{
    private readonly IUserRepository _userRepository;
    private readonly IRoleRepository _roleRepository;
    private readonly IPasswordService _passwordService;

    public UserService(
        IUserRepository userRepository,
        IRoleRepository roleRepository,
        IPasswordService passwordService)
    {
        _userRepository = userRepository;
        _roleRepository = roleRepository;
        _passwordService = passwordService;
    }

    public async Task<List<UserResponse>> GetAllAsync()
    {
        List<User> users = await _userRepository.GetAllAsync();

        return users.Select(ToResponse).ToList();
    }

    public async Task<UserResponse> GetByIdAsync(int id)
    {
        User user = await GetUserOrThrowAsync(id);

        return ToResponse(user);
    }

    public async Task<UserResponse> CreateAsync(CreateUserRequest request)
    {
        if (await _userRepository.GetByUserNameAsync(request.UserName) != null)
        {
            throw new BadRequestException("User name already exists");
        }

        if (await _userRepository.GetByEmailAsync(request.Email) != null)
        {
            throw new BadRequestException("Email already exists");
        }

        Role role = await GetRoleOrThrowAsync(request.RoleName);

        var user = new User
        {
            UserName = request.UserName.Trim(),
            Email = request.Email.Trim(),
            PasswordHash = _passwordService.HashPassword(request.Password),
            RoleId = role.Id,
            Role = role
        };

        User createdUser = await _userRepository.CreateAsync(user);
        createdUser.Role = role;

        return ToResponse(createdUser);
    }

    public async Task<UserResponse> UpdateAsync(int id, UpdateUserRequest request)
    {
        User user = await GetUserOrThrowAsync(id);
        Role role = await GetRoleOrThrowAsync(request.RoleName);

        user.UserName = request.UserName.Trim();
        user.Email = request.Email.Trim();
        user.RoleId = role.Id;
        user.Role = role;

        User updatedUser = await _userRepository.UpdateAsync(user);
        updatedUser.Role = role;

        return ToResponse(updatedUser);
    }

    public async Task DeleteAsync(int id)
    {
        bool deleted = await _userRepository.DeleteAsync(id);

        if (!deleted)
        {
            throw new NotFoundException("User not found");
        }
    }

    private async Task<User> GetUserOrThrowAsync(int id)
    {
        User? user = await _userRepository.GetByIdAsync(id);

        if (user == null)
        {
            throw new NotFoundException("User not found");
        }

        return user;
    }

    private async Task<Role> GetRoleOrThrowAsync(string roleName)
    {
        Role? role = await _roleRepository.GetByNameAsync(roleName);

        if (role == null)
        {
            throw new BadRequestException("Role not found. Use ADMIN or USER.");
        }

        return role;
    }

    private static UserResponse ToResponse(User user)
    {
        return new UserResponse
        {
            Id = user.Id,
            UserName = user.UserName,
            Email = user.Email,
            Role = user.Role.Name,
            CreatedAt = user.CreatedAt
        };
    }
}
