import 'package:flutter/material.dart';
import 'package:mis_flutter_app/components/Button.dart';
import 'package:mis_flutter_app/main.dart';
import 'package:mis_flutter_app/models/StudentModel.dart';
import 'package:mis_flutter_app/models/WorkspaceModel.dart';
import 'package:mis_flutter_app/utils/Database.dart';
import 'StartScreen.dart';

class HomeScreen extends StatefulWidget {
  static const String route = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Database _db = Database();
  String studentId = sharedPreferences.getString('studentId');
  Future<Student> futureStudent;
  Future<Machines> futureMachines;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    futureStudent = _db.fetchStudent(studentId);
    futureMachines = _db.fetchMachineFromWorkspace("Bibliothek");
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      _buildDashboard(context, futureMachines),
      _buildHistoryLog(),
    ];

    var doDelete = () async {
      //await _db.deleteStudent(studentId);
      sharedPreferences.clear();
      Navigator.pushReplacementNamed(context, StartScreen.route);
    };

    return Scaffold(
      body: FutureBuilder<Student>(
        future: futureStudent,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
                child: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('Log history'),
            backgroundColor: Colors.red,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff00629a),
        onTap: _onItemTapped,
      ),
    );
  }
}

Widget _buildDashboard(BuildContext context, Future<Machines> futureMachines) {
  Database _db = Database();

  var doLogout = () async {
    //await _db.deleteStudent(studentId);
    sharedPreferences.clear();
    Navigator.pushReplacementNamed(context, StartScreen.route);
  };

  var leaveWorkspace = () async {
    _db.decrementStudentInWorkspace("Bibliothek");
  };

  var addWorkspace = () async {
    await _db.addWorkspace("Raum A");
  };

  var addEntry = () async {
    await _db.addStudentEnterLog("Bibliothek", "r38711", "louis", "Born");
  };

  var addMachineToWorkspace = () async {
    await _db.addMachineToWorkspace("Bibliothek", "1", "Aceton", "10");
  };

  return FutureBuilder<Machines>(
    future: futureMachines,
    builder: (context, snapshot) {
      return Padding(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tertiaryButton('Logout', doLogout),
            tertiaryButton('Leave workspace', leaveWorkspace),
            primaryButton('Add Workspace', addWorkspace),
            SizedBox(height: 16.0),
            primaryButton('Add Entry', addEntry),
            SizedBox(height: 16.0),
            primaryButton('Add Machine', addMachineToWorkspace),
            Text(
              "This is a text from lborn"
            ),
          ],
        ),
      );
    }
  );
}

Widget _buildHistoryLog() {
  return Center(
    child: Text('History log'),
  );
}
