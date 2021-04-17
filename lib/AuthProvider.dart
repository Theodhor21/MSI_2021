import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mis_flutter_app/models/StudentModel.dart';
import 'package:mis_flutter_app/utils/StudentPreferences.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
}

enum Error {
  NoError,
  LoginError,
  RegistrationError,
}

class AuthProvider extends ChangeNotifier {
  Error _error = Error.NoError;
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Error get error => _error;
  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  Future login(String studentNumber, String studentLastName) async {
    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    final http.Response response = await http.get(
        "https://mis21-61b88-default-rtdb.europe-west1.firebasedatabase.app/studentprofile/" +
            studentNumber +
            ".json");

    if (response.statusCode == 200) {
      Student _student = Student.fromJson(jsonDecode(response.body));

      if (_student.studentNumber == studentNumber) {

        if (_student.studentLastName == studentLastName) {
          saveStudentInSharedPreferences(studentNumber);
          _loggedInStatus = Status.LoggedIn;
          _error = Error.NoError;
          notifyListeners();
        } else {
          _loggedInStatus = Status.NotLoggedIn;
          _error = Error.LoginError;
          notifyListeners();
        }

      } else {
        _loggedInStatus = Status.NotLoggedIn;
        _error = Error.LoginError;
        notifyListeners();
      }

    } else {
      throw Exception('Failed to load');
    }
  }

  Future<Map<String, dynamic>> register(String studentFirstName,
      String studentLastName, String studentNumber) async {

    final Map<String, dynamic> registrationData = {
      'studentFirstName': studentFirstName,
      'studentLastName': studentLastName,
      'studentNumber': studentNumber,
    };

    _registeredInStatus = Status.Registering;
    notifyListeners();

    final http.Response response = await http.put(
        "https://mis21-61b88-default-rtdb.europe-west1.firebasedatabase.app/studentprofile/" +
            studentNumber +
            ".json",
        body: json.encode(registrationData));

    if (response.statusCode == 200) {
      saveStudentInSharedPreferences(studentNumber);

      _registeredInStatus = Status.Registered;
      notifyListeners();
    } else {
      _registeredInStatus = Status.NotRegistered;
      notifyListeners();
    }
  }

  static saveStudentInSharedPreferences(String studentId) async {
    StudentPreferences().saveStudent(studentId);
    return true;
  }
}
