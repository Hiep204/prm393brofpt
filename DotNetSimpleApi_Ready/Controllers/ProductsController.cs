using DotNetSimpleApi.DTOs.Products;
using DotNetSimpleApi.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DotNetSimpleApi.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ProductsController : ControllerBase
{
    private readonly IProductService _productService;

    public ProductsController(IProductService productService)
    {
        _productService = productService;
    }

    [HttpGet]
    public async Task<ActionResult<List<ProductResponse>>> GetAll()
    {
        List<ProductResponse> products = await _productService.GetAllAsync();

        return Ok(products);
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<ProductResponse>> GetById(int id)
    {
        ProductResponse product = await _productService.GetByIdAsync(id);

        return Ok(product);
    }

    [HttpPost]
    [Authorize(Roles = "ADMIN")]
    public async Task<ActionResult<ProductResponse>> Create(CreateProductRequest request)
    {
        ProductResponse product = await _productService.CreateAsync(request);

        return CreatedAtAction(nameof(GetById), new { id = product.Id }, product);
    }

    [HttpPut("{id:int}")]
    [Authorize(Roles = "ADMIN")]
    public async Task<ActionResult<ProductResponse>> Update(int id, UpdateProductRequest request)
    {
        ProductResponse product = await _productService.UpdateAsync(id, request);

        return Ok(product);
    }

    [HttpDelete("{id:int}")]
    [Authorize(Roles = "ADMIN")]
    public async Task<IActionResult> Delete(int id)
    {
        await _productService.DeleteAsync(id);

        return NoContent();
    }
}
