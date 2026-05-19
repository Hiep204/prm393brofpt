/* Dart là một ngôn ngữ thuần hướng đối tượng , vì vậy ngay cả trong cả các hàm  cx là hướng đổi tượng kiểu Fucntion
Điều này có nghĩa là các hàm có thể được gắn cho các biến hoặc truyền làm tham số cho các 
Ta cũng có thể gọi một thể hiện (instance) của một lớp Dart như thế nó là một hàm */

// Hàm main () : khởi đầu ứng dụng
// => expression là cách viết gọn của return expression
double Sum(double a, int b, int c) => a + b + c;
// toán tư ba ngôi
int a = 3;
var b = a >= 3 ? 'Yes' : 'No';

void main() {
  print("Hello Word!");
  print(b);
}

// Đa phần giống như C# and Java không khác gì nhiều trong việc cách tổ chức and sắp xếp
