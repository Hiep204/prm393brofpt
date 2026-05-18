class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json["id"], name: json["name"], email: json["email"]);
  }

  void showInfo() {
    print("ID: $id");
    print("Name: $name");
    print("Email: $email");
  }
}

void main() {
  Map<String, dynamic> userJson = {
    "id": 1,
    "name": "Nguyen Van A",
    "email": "vana@gmail.com",
  };

  User user = User.fromJson(userJson);
  user.showInfo();
}


//Trong ví dụ này, factory constructor User.fromJson() dùng để chuyển dữ liệu dạng Map/JSON thành một object User. 
//Nó lấy các giá trị id, name và email từ Map rồi truyền vào constructor User để tạo đối tượng. 
//Cách này thường dùng khi Flutter nhận dữ liệu từ API và cần chuyển JSON thành model Dart.