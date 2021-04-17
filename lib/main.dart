import 'package:flutter/material.dart';
import 'package:mis_flutter_app/screens/LoginScreen.dart';
import 'package:mis_flutter_app/screens/RegistrationScreen.dart';
import 'package:mis_flutter_app/screens/HomeScreen.dart';
import 'package:mis_flutter_app/screens/StartScreen.dart';
import 'package:mis_flutter_app/utils/AuthProvider.dart';
import 'package:mis_flutter_app/utils/Database.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => Database()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: StartScreen(),
        routes: <String, WidgetBuilder>{
          StartScreen.route: (context) => StartScreen(),
          HomeScreen.route: (context) => HomeScreen(),
          LoginScreen.route: (context) => LoginScreen(),
          RegistrationScreen.route: (context) => RegistrationScreen(),
        },
      ),
    );
  }
}
