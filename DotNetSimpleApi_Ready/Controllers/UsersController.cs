using DotNetSimpleApi.DTOs.Users;
using DotNetSimpleApi.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DotNetSimpleApi.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "ADMIN")]
public class UsersController : ControllerBase
{
    private readonly IUserService _userService;

    public UsersController(IUserService userService)
    {
        _userService = userService;
    }

    [HttpGet]
    public async Task<ActionResult<List<UserResponse>>> GetAll()
    {
        List<UserResponse> users = await _userService.GetAllAsync();

        return Ok(users);
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<UserResponse>> GetById(int id)
    {
        UserResponse user = await _userService.GetByIdAsync(id);

        return Ok(user);
    }

    [HttpPost]
    public async Task<ActionResult<UserResponse>> Create(CreateUserRequest request)
    {
        UserResponse user = await _userService.CreateAsync(request);

        return CreatedAtAction(nameof(GetById), new { id = user.Id }, user);
    }

    [HttpPut("{id:int}")]
    public async Task<ActionResult<UserResponse>> Update(int id, UpdateUserRequest request)
    {
        UserResponse user = await _userService.UpdateAsync(id, request);

        return Ok(user);
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        await _userService.DeleteAsync(id);

        return NoContent();
    }
}
