using DotNetSimpleApi.Data;
using DotNetSimpleApi.Entities;
using Microsoft.EntityFrameworkCore;

namespace DotNetSimpleApi.Repositories;

public class ProductRepository : IProductRepository
{
    private readonly AppDbContext _context;

    public ProductRepository(AppDbContext context)
    {
        _context = context;
    }

    public async Task<List<Product>> GetAllAsync()
    {
        return await _context.Products
            .AsNoTracking()
            .OrderByDescending(product => product.Id)
            .ToListAsync();
    }

    public async Task<Product?> GetByIdAsync(int id)
    {
        return await _context.Products.FindAsync(id);
    }

    public async Task<Product> CreateAsync(Product product)
    {
        _context.Products.Add(product);
        await _context.SaveChangesAsync();
        return product;
    }

    public async Task<Product> UpdateAsync(Product product)
    {
        _context.Products.Update(product);
        await _context.SaveChangesAsync();
        return product;
    }

    public async Task<bool> DeleteAsync(int id)
    {
        Product? product = await _context.Products.FindAsync(id);

        if (product == null)
        {
            return false;
        }

        _context.Products.Remove(product);
        return await _context.SaveChangesAsync() > 0;
    }
}
