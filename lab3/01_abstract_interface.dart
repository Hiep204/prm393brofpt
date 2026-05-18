void main() {
  Dog dog = Dog();
  dog.eat();
  dog.makeSound();
}

abstract class Animal {
  void makeSound();
  void eat() {
    print("Animal is eating");
  }
}

class Dog extends Animal {
  @override
  void makeSound() {
    print("Woof woof");
  }
}
// Trong ví dụ này, Animal là abstract class, dùng để định nghĩa khung chung cho các loài động vật. 
// Hàm makeSound() chưa được triển khai nên class Dog bắt buộc phải override lại. 
// Hàm eat() đã có sẵn trong Animal nên Dog có thể kế thừa và sử dụng trực tiếp.