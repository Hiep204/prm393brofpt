Future<String> fetchUserName() async {
  print("Start fetching user name...");

  await Future.delayed(Duration(seconds: 2));

  return "Nguyen Van A";
}

void main() async {
  print("Program started");

  String name = await fetchUserName();

  print("User name: $name");
  print("Program finished");
}

//Trong ví dụ này, em sử dụng Future, async và await để mô phỏng việc lấy dữ liệu bất đồng bộ. 
//Hàm fetchUserName() trả về Future<String>, chờ 2 giây bằng Future.delayed rồi trả về tên người dùng. 
//Trong main(), em dùng await để chờ kết quả trước khi in dữ liệu ra console.