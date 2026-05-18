class User {
  final int id;
  final String name;

  User({required this.id, required this.name});
}

class UserRepository {
  Future<User> getUser() async {
    await Future.delayed(Duration(seconds: 1));

    return User(id: 1, name: "Nguyen Van A");
  }
}

class UserScreen {
  final UserRepository repository;

  UserScreen(this.repository);

  Future<void> showUser() async {
    print("Loading user...");

    User user = await repository.getUser();

    print("User ID: ${user.id}");
    print("User Name: ${user.name}");
  }
}

void main() async {
  UserRepository repository = UserRepository();
  UserScreen screen = UserScreen(repository);

  await screen.showUser();
}
