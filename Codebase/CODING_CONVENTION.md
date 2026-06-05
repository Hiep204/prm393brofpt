# Coding Convention - DotNetSimpleApi

## 1. Naming Convention

- Class: PascalCase  
  Ví dụ: `ProductService`, `UserRepository`

- Interface: bắt đầu bằng chữ `I`  
  Ví dụ: `IProductService`, `IUserRepository`

- Method: PascalCase  
  Ví dụ: `GetAllAsync()`, `CreateAsync()`

- Variable/private field: camelCase hoặc `_camelCase`  
  Ví dụ: `_productRepository`, `createdProduct`

- Async method: kết thúc bằng `Async`  
  Ví dụ: `GetByIdAsync()`

---

## 2. Project Structure

```text
Controllers  → nhận request, trả response
Services     → xử lý logic nghiệp vụ
Repositories → thao tác database
Entities     → class ánh xạ bảng database
DTOs         → dữ liệu request/response
Data         → DbContext và seed data
Middlewares  → xử lý logic toàn cục
Exceptions   → custom exception
```

---

## 3. Controller Rules

Controller chỉ nên:

- Nhận request
- Gọi Service
- Trả response

Không nên:

- Viết logic nghiệp vụ phức tạp
- Truy cập trực tiếp DbContext
- Viết SQL trong Controller

---

## 4. Service Rules

Service dùng để:

- Kiểm tra dữ liệu đầu vào
- Xử lý nghiệp vụ
- Gọi Repository
- Convert Entity sang DTO

---

## 5. Repository Rules

Repository dùng để:

- Query database
- Add, Update, Delete entity
- Gọi `SaveChangesAsync()`

Không xử lý logic nghiệp vụ trong Repository.

---

## 6. Response and Error Rule

Lỗi được xử lý tập trung trong `ExceptionHandlingMiddleware`.

Ví dụ lỗi trả về:

```json
{
  "status": 404,
  "error": "NotFound",
  "message": "Product not found",
  "path": "/api/products/999",
  "timestamp": "2026-05-18T00:00:00Z"
}
```

---

## 7. Authorization Rule

- `ADMIN`: được tạo, sửa, xóa user và product.
- `USER`: chỉ được xem product.
