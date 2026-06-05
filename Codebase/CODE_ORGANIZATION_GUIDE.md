# Huong dan to chuc code va them API moi

Tai lieu nay giai thich cach project `DotNetSimpleApi_Ready` duoc to chuc, code quan trong nam o dau, va khi them moi mot API thi can sua nhung file nao.

## 1. Tong quan kien truc

Project di theo luong:

```text
Controller -> Service -> Repository -> AppDbContext -> SQLite Database
```

Y nghia tung tang:

- `Controller`: nhan HTTP request, goi service, tra HTTP response.
- `Service`: xu ly logic nghiep vu, validate theo rule cua ung dung, chuyen Entity sang DTO.
- `Repository`: thao tac truc tiep voi database thong qua Entity Framework Core.
- `AppDbContext`: khai bao cac bang va ket noi Entity Framework voi SQLite.
- `Entity`: mo ta bang trong database.
- `DTO`: mo ta du lieu request/response de API khong tra truc tiep Entity.

## 2. Code quan trong gom nhung gi

### `Program.cs`

Day la file khoi dong ung dung.

Nhung viec quan trong trong file nay:

- Dang ky controller bang `builder.Services.AddControllers()`.
- Dang ky database SQLite bang `AddDbContext<AppDbContext>()`.
- Dang ky dependency injection cho Repository va Service.
- Cau hinh JWT Authentication.
- Cau hinh Swagger.
- Tao database va seed data mau bang `DbSeeder.Seed(...)`.
- Bat middleware xu ly loi, authentication va authorization.

Khi thuyet trinh, co the noi:

```text
Program.cs la noi cau hinh toan bo ung dung: database, dependency injection, JWT, Swagger va middleware.
```

### `Data/AppDbContext.cs`

File nay khai bao cac bang EF Core quan ly, vi du:

```text
Users
Roles
Products
```

Khi them entity moi, phai them `DbSet` vao day.

### `Data/DbSeeder.cs`

File nay tao du lieu mau khi ung dung chay lan dau:

- Role `ADMIN`
- Role `USER`
- User `admin`
- User `user`
- Product demo

Day la bang chung de chung minh project co san tai khoan test va co phan role.

### `Entities/`

Thu muc nay chua model dai dien bang database.

Hien tai co:

- `Role.cs`
- `User.cs`
- `Product.cs`

Vi du `Product.cs` la entity cua bang product.

### `DTOs/`

DTO la lop du lieu dung cho request/response cua API.

Vi du voi Product:

- `CreateProductRequest.cs`: body khi tao product.
- `UpdateProductRequest.cs`: body khi sua product.
- `ProductResponse.cs`: du lieu tra ve cho client.

Khong nen tra Entity truc tiep ra API vi Entity co the chua du lieu noi bo, quan he database, password hash, hoac field khong muon public.

### `Repositories/`

Repository la tang thao tac database.

Vi du:

- `IProductRepository.cs`: interface quy dinh cac ham can co.
- `ProductRepository.cs`: code that su dung `AppDbContext` de query, create, update, delete.

Khi can lay du lieu tu database, Service se goi Repository.

### `Services/`

Service la tang xu ly logic nghiep vu.

Vi du:

- `ProductService.cs`: kiem tra product co ton tai khong, tao/sua/xoa product, map sang DTO response.
- `AuthService.cs`: login, register, hash password, tao JWT.
- `JwtService.cs`: tao token va dua role vao claim.
- `PasswordService.cs`: hash va verify password.

Neu logic lon dan, nen dat o Service thay vi dat het trong Controller.

### `Controllers/`

Controller la noi khai bao endpoint API.

Vi du `ProductsController.cs`:

- `GET /api/products`
- `GET /api/products/{id}`
- `POST /api/products`
- `PUT /api/products/{id}`
- `DELETE /api/products/{id}`

Controller chi nen mong: nhan request, goi service, tra result.

### `Middlewares/ExceptionHandlingMiddleware.cs`

Middleware nay xu ly loi toan cuc. Khi Service/Repository throw exception, middleware se chuyen thanh response loi phu hop.

Loi thuong gap:

- `BadRequestException` -> 400
- `NotFoundException` -> 404
- `UnauthorizedAccessException` -> 401
- Loi khac -> 500

### `appsettings.json`

File cau hinh:

- Connection string SQLite.
- JWT key, issuer, audience, expire minutes.
- Logging.

Trong project thuc te, JWT key khong nen commit len GitHub. Project nay dang la demo nen de san de chay nhanh.

## 3. Khi them moi 1 API thi sua nhung file nao

Vi du can them API quan ly `Category`.

### Buoc 1: Tao Entity

Tao file:

```text
Entities/Category.cs
```

Vi du:

```csharp
namespace DotNetSimpleApi.Entities;

public class Category
{
    public int Id { get; set; }

    public string Name { get; set; } = string.Empty;
}
```

### Buoc 2: Dang ky DbSet trong AppDbContext

Sua file:

```text
Data/AppDbContext.cs
```

Them:

```csharp
public DbSet<Category> Categories => Set<Category>();
```

Neu entity co quan he voi bang khac, cau hinh them trong `OnModelCreating`.

### Buoc 3: Tao DTO

Tao thu muc:

```text
DTOs/Categories/
```

Tao cac file:

```text
CreateCategoryRequest.cs
UpdateCategoryRequest.cs
CategoryResponse.cs
```

DTO giup tach du lieu API khoi Entity database.

### Buoc 4: Tao Repository interface va implementation

Tao file:

```text
Repositories/ICategoryRepository.cs
Repositories/CategoryRepository.cs
```

Repository se viet cac ham nhu:

```text
GetAllAsync()
GetByIdAsync(id)
CreateAsync(category)
UpdateAsync(category)
DeleteAsync(category)
```

### Buoc 5: Tao Service interface va implementation

Tao file:

```text
Services/ICategoryService.cs
Services/CategoryService.cs
```

Service se:

- Goi repository.
- Kiem tra loi nghiep vu.
- Throw `NotFoundException` neu khong tim thay.
- Map Entity sang Response DTO.

### Buoc 6: Tao Controller

Tao file:

```text
Controllers/CategoriesController.cs
```

Vi du endpoint:

```text
GET    /api/categories
GET    /api/categories/{id}
POST   /api/categories
PUT    /api/categories/{id}
DELETE /api/categories/{id}
```

Neu API can dang nhap, them:

```csharp
[Authorize]
```

Neu chi ADMIN duoc goi, them:

```csharp
[Authorize(Roles = "ADMIN")]
```

### Buoc 7: Dang ky DI trong Program.cs

Sua file:

```text
Program.cs
```

Them:

```csharp
builder.Services.AddScoped<ICategoryRepository, CategoryRepository>();
builder.Services.AddScoped<ICategoryService, CategoryService>();
```

Neu quen buoc nay, khi chay API se loi do ASP.NET Core khong biet cach tao `CategoryService` hoac `CategoryRepository`.

### Buoc 8: Cap nhat seed data neu can

Neu muon co data mau, sua:

```text
Data/DbSeeder.cs
```

Vi du them category demo khi database rong.

### Buoc 9: Test lai API

Can test toi thieu:

- API khong can token neu public.
- API can token thi thieu token phai tra `401 Unauthorized`.
- API chi ADMIN thi token USER phai tra `403 Forbidden`.
- Request hop le tra dung data.
- Request sai id tra `404 Not Found`.

## 4. Vi du luong them Product hien tai

Khi goi:

```http
POST /api/products
```

Code chay theo thu tu:

```text
Controllers/ProductsController.cs
-> Services/ProductService.cs
-> Repositories/ProductRepository.cs
-> Data/AppDbContext.cs
-> dotnet_simple_api.db
```

Trong do:

- `ProductsController.Create(...)` nhan body `CreateProductRequest`.
- `ProductService.CreateAsync(...)` tao entity va map response.
- `ProductRepository.CreateAsync(...)` ghi database.
- `AppDbContext` lam viec voi SQLite.

API nay chi role `ADMIN` goi duoc vi method co:

```csharp
[Authorize(Roles = "ADMIN")]
```

## 5. Noi dung giai thich voi thay

Co the trinh bay ngan gon nhu sau:

```text
Project cua em to chuc theo mo hinh Controller - Service - Repository. Controller chi nhan request va tra response, Service xu ly logic nghiep vu, Repository lam viec voi database thong qua Entity Framework Core va AppDbContext. Du lieu API duoc tach rieng bang DTO de khong public truc tiep Entity. Project co JWT Authentication, token co chua role claim, va cac API duoc phan quyen bang [Authorize] hoac [Authorize(Roles = "ADMIN")]. Khi them API moi, em se tao Entity, DTO, Repository, Service, Controller, dang ky DI trong Program.cs, them DbSet vao AppDbContext va test lai bang Postman/Swagger.
```

## 6. Bang checklist khi them API moi

| Viec can lam | File/thu muc |
| --- | --- |
| Tao bang/entity moi | `Entities/<Name>.cs` |
| Khai bao bang EF Core | `Data/AppDbContext.cs` |
| Tao request/response model | `DTOs/<Name>/` |
| Tao tang database | `Repositories/I<Name>Repository.cs`, `Repositories/<Name>Repository.cs` |
| Tao tang nghiep vu | `Services/I<Name>Service.cs`, `Services/<Name>Service.cs` |
| Tao endpoint | `Controllers/<Name>Controller.cs` |
| Dang ky dependency injection | `Program.cs` |
| Them data mau neu can | `Data/DbSeeder.cs` |
| Test bang Swagger/Postman/curl | `docs/API_CALL_GUIDE.md`, `postman/` |
