import 'package:i_fund_me/models/User.dart';

class Auth {
  static Auth _instance = new Auth._();
  User currentUser;

  Auth._();

  void setUser(User u) {
    this.currentUser = u;
  }

  String getUsername() {
    return this.currentUser.username;
  }
}