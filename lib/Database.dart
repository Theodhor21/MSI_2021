import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mis_flutter_app/main.dart';
import 'package:mis_flutter_app/models/StudentModel.dart';
import 'package:mis_flutter_app/models/WorkspaceModel.dart';
import 'package:mis_flutter_app/utils/StudentPreferences.dart';

/// A database instance with different crud operations using REST from firebase.
/// [http.get], read data from database.
/// [http.put], create or overwrite data to database.
/// [http.patch], update data in database.
/// [http.delete], delete data from database.
///
///
class Database extends ChangeNotifier {
  StudentPreferences studentPreferences = StudentPreferences();

  /// Returns the current date and time.
  String calculateCurrentDateTime() {
    var now = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String timestamp = dateFormat.format(now);

    return timestamp;
  }

  /// CRUD Operations belonging to students
  /// 
  /// Fetches a student from the database and returns a [Student] Object.
  Future<Student> fetchStudent(String studentId) async {

    final http.Response response = await http.get(
      "https://mis21-61b88-default-rtdb.europe-west1.firebasedatabase.app/studentprofile/" +
            studentId +
            ".json");

    if (response.statusCode == 200) {
      return Student.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch student');
    }
  }

  /// Deletes a student from the database.
  Future<bool> deleteStudent(String studentId) async {
    final http.Response response = await http.delete(
      "https://mis21-61b88-default-rtdb.europe-west1.firebasedatabase.app/studentprofile/" +
            studentId +
            ".json");

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// CRUD Operations belonging to workspaces.
  ///
  /// Adds a new workspace to the database.
  addWorkspace(String workspaceName) async {
    /// Create and initialize a new workspace.
    Workspace workspace = new Workspace();
    workspace.name = workspaceName;
    workspace.currentInWorkspace = 0;

    var jsonData = jsonEncode(workspace.toJson());

    final http.Response response = await http.put(
        "https://mis21-61b88-default-rtdb.europe-west1.firebasedatabase.app/workspaces/" +
            workspaceName +
            ".json",
        body: jsonData);

    if (response.statusCode == 200) {
      print('New workspace added');
    } else {
      throw Exception('Failed to add new workspace');
    }   
  }

  /// Fetches the current number of students in a workspace.
  Future<int> fetchCurrentStudentInWorkspace() async {

    final http.Response response = await http.get(
      "https://mis21-61b88-default-rtdb.europe-west1.firebasedatabase.app/workspaces/Bibliothek/currentInWorkspace.json");

    /// Returns the number of students as int, if the get request was successfull.
    if (response.statusCode == 200) {
      int currentStudentInWorkspace = jsonDecode(response.body);
      return currentStudentInWorkspace;
    } else {
      throw Exception('Failed to load album');
    }
  }

  /// Increments the counter for the number of students in a workspace.
  incrementStudentInWorkspace(String workspaceId) async {
    /// The number of currently active students in a workspace.
    var currentStudentInWorkspace = await fetchCurrentStudentInWorkspace();
    currentStudentInWorkspace = currentStudentInWorkspace + 1;

    final http.Response response = await http.patch(
        "https://mis21-61b88-default-rtdb.europe-west1.firebasedatabase.app/workspaces/" +
            workspaceId +
            ".json",
        body: json.encode({
          'currentInWorkspace': currentStudentInWorkspace,
        }
      )
    );

    if (response.statusCode == 200) {

    } else {
      throw Exception('Failed to increment student in workspace');
    }
  }

  /// Decrements the counter for the number of students in a workspace.
  decrementStudentInWorkspace(String workspaceId) async {
    /// The number of currently active students in a workspace.
    var currentStudentInWorkspace = await fetchCurrentStudentInWorkspace();
    currentStudentInWorkspace = currentStudentInWorkspace - 1;

    final http.Response response = await http.patch(
        "https://mis21-61b88-default-rtdb.europe-west1.firebasedatabase.app/workspaces/" +
            workspaceId +
            ".json",
        body: json.encode({
          'currentInWorkspace': currentStudentInWorkspace,
        }
      )
    );

    if (response.statusCode == 200) {
      /// Sets a leave timestamp for the current logged in student.
      await(leaveWorkspace(workspaceId));
    } else {
      throw Exception('Failed to decrement student in workspace');
    }
  }
  
  /// Adds a left timestamp entry to enterLog.
  leaveWorkspace(String workspaceId) async {
    String timestamp = calculateCurrentDateTime();
    /// The enter time of the student to a workspace.
    /// The "await" is needed!
    String enterTimestamp = await sharedPreferences.getString('timestamp');
    
    EnterLog enterLog = EnterLog();
    enterLog.leaveTimestamp = timestamp;

    var jsonBody = '{"leaveTimestamp": "$timestamp"}';

    final http.Response response = await http.patch(
        "https://mis21-61b88-default-rtdb.europe-west1.firebasedatabase.app/workspaces/" +
            workspaceId + "/enterLog/" + enterTimestamp +
            ".json",
        body: jsonBody);

    if (response.statusCode == 200) {

    } else {
      throw Exception('Failed to leave workspace for student');
    }
  }

  /// Saves a users entry to a workspace.
  addStudentEnterLog(String workspaceId, String studentId, String studentFirstName, String studentLastName) async {
    String timestamp = calculateCurrentDateTime();
    
    EnterLog enterLog = EnterLog();
    enterLog.studentId = studentId;
    enterLog.studentFirstName = studentFirstName;
    enterLog.studentLastName = studentLastName;
    enterLog.enterTimestamp = timestamp;

    var jsonData = jsonEncode(enterLog.toJson());

    final http.Response response = await http.put(
        "https://mis21-61b88-default-rtdb.europe-west1.firebasedatabase.app/workspaces/" +
            workspaceId + "/enterLog/" + timestamp +
            ".json",
        body: jsonData);

    if (response.statusCode == 200) {
      await fetchCurrentStudentInWorkspace();
      /// Increments the count for the number of students in a workspace.
      await (incrementStudentInWorkspace(workspaceId));
      /// Saves the enter timestamp in the users shared preferences.
      await studentPreferences.saveWorkspaceEntryTimestamp(timestamp);
    } else {
      throw Exception('Failed to add entry');
    }
  }

  /// CRUD Operations belonging to machines.
  ///
  /// Fetches all machines from one workspace.
  Future<Machines> fetchMachineFromWorkspace(String workspaceId) async {

    final http.Response response = await http.get(
      "https://mis21-61b88-default-rtdb.europe-west1.firebasedatabase.app/workspaces/"
      + workspaceId + "/machines.json");

    if (response.statusCode == 200) {
      print(response.body);
      return Machines.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch machines');
    }
  }




  /// Adds a machine to a workspace.
  addMachineToWorkspace(String workspaceId, String machineId, String machineType, String machineCertificateStatus) async {
    Machines machines = Machines();
    machines.machineId = machineId;
    machines.machineType = machineType;
    machines.machineCertificateStatus = machineCertificateStatus;

    var jsonData = jsonEncode(machines.toJson());

    final http.Response response = await http.put(
        "https://mis21-61b88-default-rtdb.europe-west1.firebasedatabase.app/workspaces/" +
            workspaceId + "/machines/" + machineType +
            ".json",
        body: jsonData);

    if (response.statusCode == 200) {
      
    } else {
      throw Exception('Failed to add entry');
    }
  }
}
