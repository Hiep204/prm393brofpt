using System.Security.Cryptography;
using System.Text;

namespace DotNetSimpleApi.Services;

public class PasswordService : IPasswordService
{
    public string HashPassword(string password)
    {
        byte[] saltBytes = RandomNumberGenerator.GetBytes(16);
        string salt = Convert.ToBase64String(saltBytes);
        string hash = ComputeHash(password, salt);

        return $"{salt}.{hash}";
    }

    public bool VerifyPassword(string password, string passwordHash)
    {
        string[] parts = passwordHash.Split('.');

        if (parts.Length != 2)
        {
            return false;
        }

        string salt = parts[0];
        string savedHash = parts[1];
        string currentHash = ComputeHash(password, salt);

        return savedHash == currentHash;
    }

    private static string ComputeHash(string password, string salt)
    {
        string rawData = $"{password}.{salt}";
        byte[] bytes = SHA256.HashData(Encoding.UTF8.GetBytes(rawData));

        return Convert.ToBase64String(bytes);
    }
}
