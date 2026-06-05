# Huong dan goi API bang Postman va curl

Tai lieu nay dung cho project `DotNetSimpleApi_Ready`, mot ASP.NET Core Web API co JWT Authentication va phan quyen theo role `ADMIN` / `USER`.

## 1. Chay project

Mo terminal tai thu muc `DotNetSimpleApi_Ready`, sau do chay:

```bash
dotnet run
```

Mac dinh project co the chay o:

```text
https://localhost:7043
http://localhost:5043
```

Neu bi loi SSL khi dung curl/Postman, co the dung base URL HTTP:

```text
http://localhost:5043
```

Swagger:

```text
https://localhost:7043/swagger
```

## 2. Tai khoan demo

Database SQLite duoc tao va seed tu dong trong `Program.cs` va `Data/DbSeeder.cs`.

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

## 3. Lay token JWT

Endpoint:

```http
POST /api/auth/login
```

URL day du:

```text
POST http://localhost:5043/api/auth/login
```

Header:

```text
Content-Type: application/json
```

Body lay token ADMIN:

```json
{
  "userName": "admin",
  "password": "Admin@123"
}
```

Body lay token USER:

```json
{
  "userName": "user",
  "password": "User@123"
}
```

Response thanh cong:

```json
{
  "userId": 1,
  "userName": "admin",
  "email": "admin@example.com",
  "role": "ADMIN",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6..."
}
```

Trong Postman, copy gia tri `token`, sau do them header vao cac request can dang nhap:

```text
Authorization: Bearer <token>
```

Vi du:

```text
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6...
```

## 4. Phan role trong project

Project co 2 role:

```text
ADMIN
USER
```

Role duoc seed trong:

```text
Data/DbSeeder.cs
```

Token JWT chua role claim trong:

```text
Services/JwtService.cs
```

API kiem tra role bang attribute:

```csharp
[Authorize]
[Authorize(Roles = "ADMIN")]
```

Y nghia:

- `[Authorize]`: bat buoc co token hop le, role nao cung duoc.
- `[Authorize(Roles = "ADMIN")]`: bat buoc co token hop le va user phai co role `ADMIN`.

## 5. Danh sach API chinh

### Auth

| Method | Endpoint | Token | Role |
| --- | --- | --- | --- |
| POST | `/api/auth/register` | Khong can | Tao user theo `roleName`, mac dinh `USER` |
| POST | `/api/auth/login` | Khong can | Dang nhap lay token |

### Products

| Method | Endpoint | Token | Role |
| --- | --- | --- | --- |
| GET | `/api/products` | Can | `ADMIN` hoac `USER` |
| GET | `/api/products/{id}` | Can | `ADMIN` hoac `USER` |
| POST | `/api/products` | Can | `ADMIN` |
| PUT | `/api/products/{id}` | Can | `ADMIN` |
| DELETE | `/api/products/{id}` | Can | `ADMIN` |

### Users

| Method | Endpoint | Token | Role |
| --- | --- | --- | --- |
| GET | `/api/users` | Can | `ADMIN` |
| GET | `/api/users/{id}` | Can | `ADMIN` |
| POST | `/api/users` | Can | `ADMIN` |
| PUT | `/api/users/{id}` | Can | `ADMIN` |
| DELETE | `/api/users/{id}` | Can | `ADMIN` |

## 6. Huong dan test bang Postman

### Buoc 1: Tao environment

Tao Postman Environment voi bien:

```text
baseUrl = http://localhost:5043
token = de trong
```

### Buoc 2: Login

Tao request:

```text
POST {{baseUrl}}/api/auth/login
```

Body:

```json
{
  "userName": "admin",
  "password": "Admin@123"
}
```

Trong tab `Tests`, co the them script de tu luu token:

```javascript
const json = pm.response.json();
pm.environment.set("token", json.token);
pm.environment.set("role", json.role);
```

### Buoc 3: Goi API can token

Vao tab `Authorization`:

```text
Type: Bearer Token
Token: {{token}}
```

Hoac them header:

```text
Authorization: Bearer {{token}}
```

### Buoc 4: Test phan quyen

1. Login bang `admin` / `Admin@123`.
2. Goi `POST {{baseUrl}}/api/products` se thanh cong vi role la `ADMIN`.
3. Login bang `user` / `User@123`.
4. Goi `GET {{baseUrl}}/api/products` se thanh cong vi chi can token.
5. Goi `POST {{baseUrl}}/api/products` se bi `403 Forbidden` vi role `USER` khong duoc tao product.
6. Xoa token roi goi `GET {{baseUrl}}/api/products` se bi `401 Unauthorized`.

## 7. Vi du curl

### Login lay token ADMIN

```bash
curl -X POST "http://localhost:5043/api/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"userName\":\"admin\",\"password\":\"Admin@123\"}"
```

### Goi GET products voi token

```bash
curl -X GET "http://localhost:5043/api/products" \
  -H "Authorization: Bearer <TOKEN>"
```

### Tao product bang ADMIN

```bash
curl -X POST "http://localhost:5043/api/products" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <ADMIN_TOKEN>" \
  -d "{\"name\":\"New Product\",\"price\":150000,\"stock\":20}"
```

### Thu loi phan quyen bang USER

Dung token cua user de goi API tao product:

```bash
curl -X POST "http://localhost:5043/api/products" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <USER_TOKEN>" \
  -d "{\"name\":\"Forbidden Product\",\"price\":100000,\"stock\":1}"
```

Ket qua mong doi:

```text
403 Forbidden
```

## 8. Postman collection

File collection da tao san tai:

```text
postman/DotNetSimpleApi.postman_collection.json
```

Cach import:

1. Mo Postman.
2. Bam `Import`.
3. Chon file `postman/DotNetSimpleApi.postman_collection.json`.
4. Tao environment co `baseUrl = http://localhost:5043`.
5. Chay request `Login - Admin` de luu token.
6. Chay cac request con lai.
