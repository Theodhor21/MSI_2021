import 'package:flutter/material.dart';
import 'package:mis_flutter_app/components/Button.dart';
import 'package:mis_flutter_app/components/Callout.dart';
import 'package:mis_flutter_app/components/TextField.dart';
import 'package:mis_flutter_app/screens/HomeScreen.dart';
import 'package:mis_flutter_app/utils/AuthProvider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String route = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  String _studentNumber, _studentLastName;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final studentNumberField = TextFormField(
      autofocus: false,
      validator: (value) => value.isEmpty ? 'This is a mandatory field' : null,
      onSaved: (value) => _studentNumber = value,
      decoration: buildInputDecoration('Student number'),
    );

    final studentLastNameField = TextFormField(
      autofocus: false,
      validator: (value) => value.isEmpty ? 'This is a mandatory field' : null,
      onSaved: (value) => _studentLastName = value,
      decoration: buildInputDecoration('Student last name'),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        Text('Login in..'),
      ],
    );

    var doLogin = () async {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        await auth.login(_studentNumber, _studentLastName);
        if(auth.loggedInStatus == Status.LoggedIn) {
          Navigator.pushReplacementNamed(context, HomeScreen.route);
        }
      }
    };

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xffffffff),
          title: Text(
            'Student login',
            style: TextStyle(color: Color(0xff000000)),
          ),
          centerTitle: true,
          leading:
              iconButton(Icons.close, () => Navigator.of(context).pop(), 24.0)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    auth.loggedInStatus == Status.NotLoggedIn
                        ? infoCallout(
                            'Please use your unique student number, e.g: r0123456.')
                        : Container(),
                    SizedBox(height: 8.0),
                    auth.error == Error.LoginError
                        ? errorCallout(
                            'Student number or last name is incorrect.')
                        : Container(),
                    SizedBox(height: 32.0),
                    studentNumberField,
                    SizedBox(height: 16.0),
                    studentLastNameField,
                    SizedBox(height: 32.0),
                    auth.loggedInStatus == Status.Authenticating
                        ? loading
                        : primaryButton('Login now', doLogin),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
