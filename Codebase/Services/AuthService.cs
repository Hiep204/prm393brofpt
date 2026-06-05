using DotNetSimpleApi.DTOs.Auth;
using DotNetSimpleApi.Entities;
using DotNetSimpleApi.Exceptions;
using DotNetSimpleApi.Repositories;

namespace DotNetSimpleApi.Services;

public class AuthService : IAuthService
{
    private readonly IUserRepository _userRepository;
    private readonly IRoleRepository _roleRepository;
    private readonly IPasswordService _passwordService;
    private readonly IJwtService _jwtService;

    public AuthService(
        IUserRepository userRepository,
        IRoleRepository roleRepository,
        IPasswordService passwordService,
        IJwtService jwtService)
    {
        _userRepository = userRepository;
        _roleRepository = roleRepository;
        _passwordService = passwordService;
        _jwtService = jwtService;
    }

    public async Task<AuthResponse> RegisterAsync(RegisterRequest request)
    {
        User? existingUserName = await _userRepository.GetByUserNameAsync(request.UserName);
        if (existingUserName != null)
        {
            throw new BadRequestException("User name already exists");
        }

        User? existingEmail = await _userRepository.GetByEmailAsync(request.Email);
        if (existingEmail != null)
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

        return CreateAuthResponse(createdUser);
    }

    public async Task<AuthResponse> LoginAsync(LoginRequest request)
    {
        User? user = await _userRepository.GetByUserNameAsync(request.UserName);

        if (user == null || !_passwordService.VerifyPassword(request.Password, user.PasswordHash))
        {
            throw new UnauthorizedAccessException("Invalid username or password");
        }

        return CreateAuthResponse(user);
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

    private AuthResponse CreateAuthResponse(User user)
    {
        return new AuthResponse
        {
            UserId = user.Id,
            UserName = user.UserName,
            Email = user.Email,
            Role = user.Role.Name,
            Token = _jwtService.GenerateToken(user)
        };
    }
}
