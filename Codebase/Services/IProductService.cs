using DotNetSimpleApi.DTOs.Products;

namespace DotNetSimpleApi.Services;

public interface IProductService
{
    Task<List<ProductResponse>> GetAllAsync();

    Task<ProductResponse> GetByIdAsync(int id);

    Task<ProductResponse> CreateAsync(CreateProductRequest request);

    Task<ProductResponse> UpdateAsync(int id, UpdateProductRequest request);

    Task DeleteAsync(int id);
}
