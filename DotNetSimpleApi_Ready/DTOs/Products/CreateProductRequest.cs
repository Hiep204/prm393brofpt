using System.ComponentModel.DataAnnotations;

namespace DotNetSimpleApi.DTOs.Products;

public class CreateProductRequest
{
    [Required]
    public string Name { get; set; } = string.Empty;

    [Range(0, double.MaxValue)]
    public decimal Price { get; set; }

    [Range(0, int.MaxValue)]
    public int Stock { get; set; }
}
