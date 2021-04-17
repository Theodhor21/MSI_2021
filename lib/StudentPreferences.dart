import 'package:shared_preferences/shared_preferences.dart';

/// A shared preferences to save key values.
///
///
class StudentPreferences {
  /// Saves a students id to a shared preference.
  Future<bool> saveStudent(String studentId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('studentId', studentId);

    return true;
  }

  /// Saves a students entry timestamp in a workspace.
  Future<bool> saveWorkspaceEntryTimestamp(String timestamp) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('timestamp', timestamp);

    return true;
  }
}