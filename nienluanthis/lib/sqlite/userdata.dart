class UserData {
  final int id;
  final String username;
  final double weight;
  final double height;
  final DateTime date;

  UserData({
    required this.id,
    required this.username,
    required this.weight,
    required this.height,
    required this.date,
  });

  double get bmi => weight / ((height / 100) * (height / 100));

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'],
      username: map['username'],
      weight: map['weight'],
      height: map['height'],
      date: DateTime.parse(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'weight': weight,
      'height': height,
      'date': date.toIso8601String(),
    };
  }
}
