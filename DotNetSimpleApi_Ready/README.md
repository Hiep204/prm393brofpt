# DotNetSimpleApi

Đây là project mẫu **ASP.NET Core Web API** có cấu trúc đơn giản nhưng đủ ý để nộp/báo cáo:

```text
Controller → Service → Repository → DbContext → SQLite Database
```

Project có:

- REST API bằng ASP.NET Core Controller
- Entity Framework Core + SQLite
- JWT Authentication
- Role Authorization: `ADMIN`, `USER`
- Global Exception Handling
- CRUD Product làm ví dụ
- CRUD User dành cho ADMIN
- Swagger để test API
- Seed sẵn tài khoản demo

---

## 1. Cách mở project bằng Visual Studio 2022

1. Giải nén file zip.
2. Mở Visual Studio 2022.
3. Chọn **Open a project or solution**.
4. Chọn file:

```text
DotNetSimpleApi.csproj
```

5. Chờ Visual Studio restore NuGet packages.
6. Bấm nút chạy màu xanh **https** hoặc nhấn **F5**.
7. Trình duyệt sẽ mở Swagger:

```text
https://localhost:7043/swagger
```

---

## 2. Tài khoản demo

Project tự tạo database SQLite khi chạy lần đầu.

### ADMIN

```json
{
  "userName": "admin",
  "password": "Admin@123"
}
```

### USER

```json
{
  "userName": "user",
  "password": "User@123"
}
```

---

## 3. Cách test JWT trên Swagger

### Bước 1: Login

Gọi API:

```http
POST /api/auth/login
```

Body:

```json
{
  "userName": "admin",
  "password": "Admin@123"
}
```

Kết quả trả về có `token`.

### Bước 2: Authorize

1. Copy token.
2. Bấm nút **Authorize** trên Swagger.
3. Nhập:

```text
Bearer <token_của_bạn>
```

Ví dụ:

```text
Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6...
```

4. Bấm **Authorize**.

---

## 4. API chính

### Auth

```http
POST /api/auth/register
POST /api/auth/login
```

### Products

```http
GET    /api/products
GET    /api/products/{id}
POST   /api/products       ADMIN only
PUT    /api/products/{id}  ADMIN only
DELETE /api/products/{id}  ADMIN only
```

### Users

```http
GET    /api/users          ADMIN only
GET    /api/users/{id}     ADMIN only
POST   /api/users          ADMIN only
PUT    /api/users/{id}     ADMIN only
DELETE /api/users/{id}     ADMIN only
```

---

## 5. Cấu trúc thư mục

```text
DotNetSimpleApi/
│
├── Controllers/
│   ├── AuthController.cs
│   ├── ProductsController.cs
│   └── UsersController.cs
│
├── Services/
│   ├── AuthService.cs
│   ├── ProductService.cs
│   ├── UserService.cs
│   ├── JwtService.cs
│   └── PasswordService.cs
│
├── Repositories/
│   ├── ProductRepository.cs
│   ├── UserRepository.cs
│   └── RoleRepository.cs
│
├── Entities/
│   ├── Product.cs
│   ├── User.cs
│   └── Role.cs
│
├── DTOs/
│   ├── Auth/
│   ├── Products/
│   └── Users/
│
├── Data/
│   ├── AppDbContext.cs
│   └── DbSeeder.cs
│
├── Exceptions/
├── Middlewares/
├── Program.cs
├── appsettings.json
└── CODING_CONVENTION.md
```

---

## 6. Luồng xử lý của API

Ví dụ khi gọi:

```http
POST /api/products
```

Luồng chạy là:

```text
ProductsController
↓
ProductService
↓
ProductRepository
↓
AppDbContext
↓
SQLite Database
```

Ý nghĩa:

- **Controller**: nhận request và trả response.
- **Service**: xử lý logic nghiệp vụ, kiểm tra dữ liệu.
- **Repository**: thao tác trực tiếp với database.
- **DbContext**: cầu nối giữa code C# và database.

---

## 7. Bằng chứng nên chụp để nộp thầy

Bạn nên chụp các ảnh sau:

1. Ảnh cấu trúc thư mục `Controllers`, `Services`, `Repositories`, `Entities`, `Data`.
2. Ảnh project chạy Swagger thành công.
3. Ảnh login trả về JWT token.
4. Ảnh bấm Authorize với Bearer token.
5. Ảnh gọi `GET /api/products` thành công.
6. Ảnh gọi `POST /api/products` bằng tài khoản ADMIN thành công.
7. Ảnh gọi API không có token bị lỗi `401 Unauthorized`.
8. Ảnh gọi API không đúng role bị lỗi `403 Forbidden`.

---

## 8. Câu giải thích khi báo cáo

Em xây dựng project backend bằng ASP.NET Core Web API. Project có cấu trúc theo mô hình Controller, Service, Repository và sử dụng Entity Framework Core để tương tác với SQLite Database. Project có xác thực bằng JWT, phân quyền theo Role ADMIN/USER, xử lý lỗi toàn cục bằng middleware và có CRUD Product/User làm ví dụ.
