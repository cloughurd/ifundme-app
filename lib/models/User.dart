class User {
  final String username;
  final String dateCreated;
  final String dateLastAccessed;

  User({this.username, this.dateCreated, this.dateLastAccessed});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      dateCreated: json['dateCreated'],
      dateLastAccessed: json['dateLastAccessed'],
    );
  }
}