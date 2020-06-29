import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:i_fund_me/models/User.dart';

class Server {
  static String serverUrl = "http://localhost:8080";

  Future<bool> serverConnected() async {
    try {
      http.Response response = await http.get(serverUrl + '/health');
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  Future<List<User>> getUsers() async {
    try {
      http.Response response = await http.get(serverUrl + '/users');
      String responseBody = response.body;
      Map body = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        List<dynamic> rawUsers = body['users'];
        List<User> users = List<User>();
        for (Map<String, dynamic> rawUser in rawUsers) {
          User u = User.fromJson(rawUser);
          users.add(u);
        }
        return users;
      }
      if (body['errorMessage'] != null) {
        throw new InternalServerException(message: body['errorMessage']);
      }
      throw new InternalServerException();
    } catch (error) {
      if (error is InternalServerException) {
        throw error;
      }
      throw new ServerConnectionException();
    }
  }
}

class InternalServerException implements Exception {
  String message;

  InternalServerException({String message}) {
    if (message != null) {
      this.message = "Exception: " + message;
    }
    else {
      this.message = "Exception: Internal server error.";
    }
  }

  @override
  String toString() {
    return this.message;
  }
}


class ServerConnectionException implements Exception {
  final String message = "Error connecting to the server.";

  @override
  String toString() {
    return this.message;
  }
}