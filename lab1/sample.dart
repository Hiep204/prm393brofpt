class Student {
  String name;
  int age;

  Student(this.name, this.age);

  void showInfo() {
    print("Name: $name");
    print("Age: $age");
  }
}

void main() {
  Student s1 = Student("Hiep", 20);

  s1.showInfo();
}
