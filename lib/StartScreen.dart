import 'package:flutter/material.dart';
import 'package:mis_flutter_app/components/TextStyle.dart';
import 'package:mis_flutter_app/main.dart';
import 'package:mis_flutter_app/screens/HomeScreen.dart';
import 'RegistrationScreen.dart';
import 'LoginScreen.dart';
import 'package:mis_flutter_app/components/Button.dart';
import 'HomeScreen.dart';

class StartScreen extends StatelessWidget {
  static const String route = 'start';

  @override
  Widget build(BuildContext context) {
    final welcomeText = Text(
      'Welcome to the <some text>.',
      style: header5(),
    );

    if (sharedPreferences.containsKey('studentId')) {
      return HomeScreen();
    } else {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                left: 24.0, top: 24.0, right: 24.0, bottom: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                welcomeText,
                SizedBox(height: 80.0),
                primaryButton(
                  'Login',
                  () => Navigator.pushNamed(context, LoginScreen.route),
                ),
                SizedBox(height: 16.0),
                secondaryButton(
                    'Registration',
                    () =>
                        Navigator.pushNamed(context, RegistrationScreen.route)),
              ],
            ),
          ),
        ),
      );
    }
  }
}
