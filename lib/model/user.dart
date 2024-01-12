class User {
  int? id;
  final String username;
  final String fullname;
  final String password;

  User({ this.id, required this.username, required this.fullname, required this.password });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      fullname: json['fullname'],
      password: json['password']
    );
  }
}