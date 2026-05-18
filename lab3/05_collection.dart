void main() {
  final numbers = [1, 2, 3, 4, 5];

  final moreNumbers = [0, ...numbers, 6, 7];
  print("Spread operator:");
  print(moreNumbers);

  bool isLoggedIn = true;

  final menu = ["Home", if (isLoggedIn) "Profile", "Setting"];

  print("Collection if:");
  print(menu);

  final labels = [for (var number in numbers) "Item $number"];

  print("Collection for:");
  print(labels);

  final evenNumbers = numbers.where((n) => n.isEven).toList();
  print("Even numbers:");
  print(evenNumbers);

  final doubleNumbers = numbers.map((n) => n * 2).toList();
  print("Double numbers:");
  print(doubleNumbers);
}

//Trong ví dụ này, em thực hành các tính năng Collection nâng cao trong Dart. 
//Spread operator dùng để chèn toàn bộ phần tử của một list vào list khác. 
//Collection-if dùng để thêm phần tử theo điều kiện. 
//Collection-for dùng để tạo list mới bằng vòng lặp. 
//Ngoài ra, where() dùng để lọc dữ liệu, còn map() dùng để biến đổi từng phần tử trong danh sách.