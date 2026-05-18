using DotNetSimpleApi.Entities;

namespace DotNetSimpleApi.Services;

public interface IJwtService
{
    string GenerateToken(User user);
}
