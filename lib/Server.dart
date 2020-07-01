import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:i_fund_me/models/Group.dart';
import 'package:i_fund_me/models/Membership.dart';
import 'package:i_fund_me/models/User.dart';

class Server {
  static String serverUrl = "http://10.0.2.2:8080";
  static Server _instance = new Server._();
  static Map<String, String> _jsonHeaders = { 'Content-Type': 'application/json' };

  Server._();

  factory Server.instance() {
    return _instance;
  }

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
        throw new InternalServerException(message: body['errorMessage'], code: response.statusCode);
      }
      throw new InternalServerException();
    } catch (error) {
      if (error is InternalServerException) {
        throw error;
      }
      throw new ServerConnectionException();
    }
  }

  Future<User> createUser(String username) async {
    try {
      String reqBody = json.encode({ 'username': username });
      http.Response response = await http.post(serverUrl + '/users',
          headers: _jsonHeaders, body: reqBody);
      Map body = json.decode(response.body);
      if (response.statusCode == 200) {
        User u = User.fromJson(body['user']);
        return u;
      }
      if (body['errorMessage'] != null) {
        throw new InternalServerException(message: body['errorMessage'], code: response.statusCode);
      }
      throw new InternalServerException();
    } catch (error) {
      if (error is InternalServerException) {
        throw error;
      }
      throw new ServerConnectionException();
    }
  }

  Future<List<Membership>> getMembershipsByUser(String username) async {
    try {
      String reqBody = json.encode({ 'searchType': 'username', 'searchId': username });
      http.Response response = await http.post(serverUrl + '/memberships/search',
          headers: _jsonHeaders, body: reqBody);
      String responseBody = response.body;
      Map body = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        List<dynamic> rawMemberships = body['memberships'];
        List<Membership> memberships = List<Membership>();
        for (Map<String, dynamic> rawMembership in rawMemberships) {
          Membership m = Membership.fromJson(rawMembership);
          memberships.add(m);
        }
        return memberships;
      }
      if (body['errorMessage'] != null) {
        throw new InternalServerException(message: body['errorMessage'], code: response.statusCode);
      }
      throw new InternalServerException();
    } catch (error) {
      if (error is InternalServerException) {
        throw error;
      }
      throw new ServerConnectionException();
    }
  }

  Future<Membership> createMembership(String username, String groupName, String memberType)  async {
    try {
      String reqBody = json.encode({
        'groupName': groupName,
        'username': username,
        'memberType': memberType
      });
      http.Response response = await http.post(
          serverUrl + '/memberships',
          headers: _jsonHeaders, body: reqBody);
      Map body = json.decode(response.body);
      if (response.statusCode == 200) {
        Membership m = Membership.fromJson(body);
        return m;
      }
      if (body['errorMessage'] != null) {
        throw new InternalServerException(message: body['errorMessage'], code: response.statusCode);
      }
      throw new InternalServerException();
    } catch (error) {
      if (error is InternalServerException) {
        throw error;
      }
      throw new ServerConnectionException();
    }
  }

  Future<Group> createGroup(String groupName) async {
    try {
      String reqBody = json.encode({ 'groupName': groupName });
      http.Response response = await http.post(serverUrl + '/groups',
          headers: _jsonHeaders, body: reqBody);
      Map body = json.decode(response.body);
      if (response.statusCode == 200) {
        Group g = Group.fromJson(body);
        return g;
      }
      if (body['errorMessage'] != null) {
        throw new InternalServerException(message: body['errorMessage'], code: response.statusCode);
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
  int code;

  InternalServerException({String message, this.code}) {
    if (message != null) {
      this.message = "Exception (" + this.code.toString() + "): " + message;
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