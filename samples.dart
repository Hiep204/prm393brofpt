import 'dart:io';
import 'dart:math';

void main() {
  double a = 0, b = 0, c = 0;
  do {
    stdout.write("Nhập hệ số a (a khác 0): ");
    String? input = stdin.readLineSync();
    if (input != null) {
      a = double.tryParse(input) ?? 0;
    }
  } while (a == 0);

  stdout.write("Nhập hệ số b: ");
  String? inputB = stdin.readLineSync();
  if (inputB != null) {
    b = double.tryParse(inputB) ?? 0;
  }

  stdout.write("Nhập hệ số b: ");
  String? inputC = stdin.readLineSync();
  if (inputC != null) {
    b = double.tryParse(inputC) ?? 0;
  }

  double delta = b * b - 4 * a * c;

  print("Phương trình ${a}x^a + ${b}x + c = 0");

  if (delta < 0) {
    print("Phương trình vô nghiệm!");
  } else if (delta == 0) {
    double x = -b / (2 * a);
    print("Phương trình có nghiêm kép x1 = x2 = ${x.toStringAsFixed(2)}");
  } else {
    double x1 = (-b - sqrt(delta)) / 2 * a;
    double x2 = (-b + sqrt(delta)) / 2 * a;
    print(
      "Phương trình có hai nghiệm phân biệt ${x1.toStringAsFixed(2)} and ${x2.toStringAsFixed(2)}",
    );
  }
}
