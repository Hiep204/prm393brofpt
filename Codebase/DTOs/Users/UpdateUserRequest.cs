using System.ComponentModel.DataAnnotations;

namespace DotNetSimpleApi.DTOs.Users;

public class UpdateUserRequest
{
    [Required]
    public string UserName { get; set; } = string.Empty;

    [Required]
    [EmailAddress]
    public string Email { get; set; } = string.Empty;

    public string RoleName { get; set; } = "USER";
}
