using DotNetSimpleApi.DTOs.Products;
using DotNetSimpleApi.Entities;
using DotNetSimpleApi.Exceptions;
using DotNetSimpleApi.Repositories;

namespace DotNetSimpleApi.Services;

public class ProductService : IProductService
{
    private readonly IProductRepository _productRepository;

    public ProductService(IProductRepository productRepository)
    {
        _productRepository = productRepository;
    }

    public async Task<List<ProductResponse>> GetAllAsync()
    {
        List<Product> products = await _productRepository.GetAllAsync();

        return products.Select(ToResponse).ToList();
    }

    public async Task<ProductResponse> GetByIdAsync(int id)
    {
        Product product = await GetProductOrThrowAsync(id);

        return ToResponse(product);
    }

    public async Task<ProductResponse> CreateAsync(CreateProductRequest request)
    {
        ValidateProduct(request.Name, request.Price, request.Stock);

        var product = new Product
        {
            Name = request.Name.Trim(),
            Price = request.Price,
            Stock = request.Stock
        };

        Product createdProduct = await _productRepository.CreateAsync(product);

        return ToResponse(createdProduct);
    }

    public async Task<ProductResponse> UpdateAsync(int id, UpdateProductRequest request)
    {
        ValidateProduct(request.Name, request.Price, request.Stock);

        Product product = await GetProductOrThrowAsync(id);

        product.Name = request.Name.Trim();
        product.Price = request.Price;
        product.Stock = request.Stock;
        product.UpdatedAt = DateTime.UtcNow;

        Product updatedProduct = await _productRepository.UpdateAsync(product);

        return ToResponse(updatedProduct);
    }

    public async Task DeleteAsync(int id)
    {
        bool deleted = await _productRepository.DeleteAsync(id);

        if (!deleted)
        {
            throw new NotFoundException("Product not found");
        }
    }

    private async Task<Product> GetProductOrThrowAsync(int id)
    {
        Product? product = await _productRepository.GetByIdAsync(id);

        if (product == null)
        {
            throw new NotFoundException("Product not found");
        }

        return product;
    }

    private static void ValidateProduct(string name, decimal price, int stock)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new BadRequestException("Product name is required");
        }

        if (price < 0)
        {
            throw new BadRequestException("Product price cannot be negative");
        }

        if (stock < 0)
        {
            throw new BadRequestException("Product stock cannot be negative");
        }
    }

    private static ProductResponse ToResponse(Product product)
    {
        return new ProductResponse
        {
            Id = product.Id,
            Name = product.Name,
            Price = product.Price,
            Stock = product.Stock,
            CreatedAt = product.CreatedAt,
            UpdatedAt = product.UpdatedAt
        };
    }
}
