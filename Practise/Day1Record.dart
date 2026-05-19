//Record là một kiểu dữ liệu tổng hơp (composite type) được giới thiệu tỏng Dart 3.0
// cho phép nhóm nhiều giá trị có kiểu khác nhau thành một đơn vị duy nhất.
// Records là immutable - nghĩa không thể thay đổi sau khi được tạo
void main() {
  var r = ('first, a:2 , 5, 10.5');

  /// record
  // Nó khác với các kiểu dữ liệu khác nó là tổng hợp nhiều kiểu dữ liệu khác nhau trong một record
  // Định nghịa record có 2 giá trị
  var point = (123, 456);
  // Định nghĩa person

  var person = (name: 'Alice', age: 25, 5);
  // Try cập giá trị
  // Dùng chỉ số để truy cập vào một record
  print(point.$1);
  // Dùng tên biến ở trong record để trích xuất dữ liệu
  print(person.name);

  print(person.$1);
}
