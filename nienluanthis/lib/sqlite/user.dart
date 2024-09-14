class User {
  int? id;
  final String username;
  final String email;
  final DateTime birthDate;
  final String gender;
  final double weight;
  final double height;
  final String password;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.birthDate,
    required this.gender,
    required this.weight,
    required this.height,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender,
      'weight': weight,
      'height': height,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      birthDate: DateTime.parse(map['birthDate']),
      gender: map['gender'],
      weight: map['weight'],
      height: map['height'],
      password: map['password'],
    );
  }
}
