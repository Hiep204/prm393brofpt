import 'dart:async';

Future<void> main() async {
  exercise1();
  exercise2();
  exercise3();
  exercise4();
  await exercise5();
}

// Exercise 1 – Basic Syntax & Data Types
void exercise1() {
  print('--- Exercise 1: Basic Syntax & Data Types ---');

  int age = 20;
  double height = 1.75;
  String name = 'Hiep';
  bool isStudent = true;

  print('Name: $name');
  print('Age: $age');
  print('Height: $height');
  print('Is student: $isStudent');
  print('Next year, $name will be ${age + 1} years old.');
}

// Exercise 2 – Collections & Operators
void exercise2() {
  print('\n--- Exercise 2: Collections & Operators ---');

  List<int> numbers = [10, 20, 30, 40];
  print('Numbers: $numbers');
  print('First number: ${numbers[0]}');

  numbers.add(50);
  numbers.remove(20);
  print('After add and remove: $numbers');

  int a = 10;
  int b = 5;

  print('a + b = ${a + b}');
  print('a - b = ${a - b}');
  print('a == b: ${a == b}');
  print('a > 0 && b > 0: ${a > 0 && b > 0}');

  String result = a > b ? 'a is greater than b' : 'a is not greater than b';
  print(result);

  Set<String> colors = {'red', 'blue', 'red', 'green'};
  print('Colors set: $colors');

  Map<String, int> scores = {'Math': 90, 'English': 85, 'Science': 88};

  print('Math score: ${scores['Math']}');
}

// Exercise 3 – Control Flow & Functions
void exercise3() {
  print('\n--- Exercise 3: Control Flow & Functions ---');

  int score = 85;

  if (score >= 90) {
    print('Grade: A');
  } else if (score >= 80) {
    print('Grade: B');
  } else if (score >= 70) {
    print('Grade: C');
  } else {
    print('Grade: F');
  }

  String day = 'Monday';

  switch (day) {
    case 'Monday':
      print('Today is Monday');
      break;
    case 'Tuesday':
      print('Today is Tuesday');
      break;
    default:
      print('Another day');
  }

  List<String> fruits = ['Apple', 'Banana', 'Orange'];

  for (int i = 0; i < fruits.length; i++) {
    print('For loop: ${fruits[i]}');
  }

  for (String fruit in fruits) {
    print('For-in loop: $fruit');
  }

  fruits.forEach((fruit) {
    print('forEach loop: $fruit');
  });

  print('Add result: ${add(5, 3)}');
  print('Multiply result: ${multiply(5, 3)}');
}

// Normal function
int add(int a, int b) {
  return a + b;
}

// Arrow function
int multiply(int a, int b) => a * b;

// Exercise 4 – Intro to OOP
void exercise4() {
  print('\n--- Exercise 4: Intro to OOP ---');

  Car car1 = Car('Toyota');
  car1.start();

  Car car2 = Car.namedConstructor();
  car2.start();

  ElectricCar tesla = ElectricCar('Tesla');
  tesla.start();
}

class Car {
  String brand;

  // Constructor
  Car(this.brand);

  // Named constructor
  Car.namedConstructor() : brand = 'Default Car';

  void start() {
    print('$brand car is starting.');
  }
}

class ElectricCar extends Car {
  ElectricCar(String brand) : super(brand);

  @override
  void start() {
    print('$brand electric car is starting silently.');
  }
}

// Exercise 5 – Async, Future, Null Safety & Streams
Future<void> exercise5() async {
  print('\n--- Exercise 5: Async, Future, Null Safety & Streams ---');

  String data = await loadData();
  print(data);

  String? nullableName;
  print('Name: ${nullableName ?? 'No name provided'}');

  nullableName = 'Hiep';
  print('Name length: ${nullableName!.length}');

  Stream<int> numberStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  await for (int number in numberStream) {
    print('Stream value: $number');
  }
}

Future<String> loadData() async {
  print('Loading data...');
  await Future.delayed(Duration(seconds: 2));
  return 'Data loaded successfully!';
}
