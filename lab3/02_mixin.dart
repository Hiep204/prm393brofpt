import 'dart:developer';

void main() {
  UserService user = UserService();
  user.getUser();
}

mixin Logger {
  void Log(String mess) {
    print("Log: $mess");
  }
}

class UserService with Logger {
  void getUser() {
    log("Getting user information");
    print("User name: Nguyen Van A");
  }
}

//Trong ví dụ này, Logger là một mixin dùng để chia sẻ chức năng ghi log. 
//UserService sử dụng từ khóa with Logger để có thể dùng lại hàm logMessage() mà không cần kế thừa bằng extends. 
//Mixin giúp tái sử dụng code cho nhiều class khác nhau.