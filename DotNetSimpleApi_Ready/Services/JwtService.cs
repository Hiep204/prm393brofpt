using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using DotNetSimpleApi.Entities;
using Microsoft.IdentityModel.Tokens;

namespace DotNetSimpleApi.Services;

public class JwtService : IJwtService
{
    private readonly IConfiguration _configuration;

    public JwtService(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public string GenerateToken(User user)
    {
        string key = _configuration["Jwt:Key"]
            ?? throw new InvalidOperationException("JWT key is missing");

        string issuer = _configuration["Jwt:Issuer"] ?? "DotNetSimpleApi";
        string audience = _configuration["Jwt:Audience"] ?? "DotNetSimpleApiClient";
        int expireMinutes = int.Parse(_configuration["Jwt:ExpireMinutes"] ?? "60");

        var claims = new List<Claim>
        {
            new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
            new Claim(ClaimTypes.Name, user.UserName),
            new Claim(ClaimTypes.Email, user.Email),
            new Claim(ClaimTypes.Role, user.Role.Name)
        };

        var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key));
        var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: issuer,
            audience: audience,
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(expireMinutes),
            signingCredentials: credentials
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
