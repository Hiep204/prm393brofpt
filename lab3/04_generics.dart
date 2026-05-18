class Box<T> {
  T value;

  Box(this.value);

  void showValue() {
    print("Value: $value");
  }
}

class Animal {
  void eat() {
    print("Animal is eating");
  }
}

class Dog extends Animal {
  void bark() {
    print("Dog is barking");
  }
}

class AnimalBox<T extends Animal> {
  T animal;

  AnimalBox(this.animal);

  void feedAnimal() {
    animal.eat();
  }
}

void main() {
  Box<int> intBox = Box<int>(100);
  Box<String> stringBox = Box<String>("Hello Dart");

  intBox.showValue();
  stringBox.showValue();

  Dog dog = Dog();
  AnimalBox<Dog> dogBox = AnimalBox<Dog>(dog);
  dogBox.feedAnimal();
  dog.bark();
}


//Trong ví dụ này, Box<T> là một generic class, giúp class có thể chứa nhiều kiểu dữ liệu khác nhau như int hoặc String. 
//AnimalBox<T extends Animal> là generic có ràng buộc, nghĩa là kiểu T bắt buộc phải là Animal hoặc lớp con của Animal. 
//Vì Dog kế thừa Animal nên có thể dùng AnimalBox<Dog>. Điều này giúp code vừa linh hoạt vừa đảm bảo an toàn kiểu dữ liệu.