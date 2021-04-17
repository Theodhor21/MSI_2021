import 'package:flutter/material.dart';
import 'package:mis_flutter_app/components/Button.dart';
import 'package:mis_flutter_app/components/Callout.dart';
import 'package:mis_flutter_app/components/TextField.dart';
import 'package:mis_flutter_app/utils/AuthProvider.dart';
import 'HomeScreen.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  static const String route = 'authentication';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final formKey = GlobalKey<FormState>();

  String _studentNumber, _studentFirstName, _studentLastName;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final studentNumberField = TextFormField(
      autofocus: false,
      validator: (value) => value.isEmpty ? 'This is a mandatory field' : null,
      onSaved: (value) => _studentNumber = value,
      decoration: buildInputDecoration('Student number'),
    );

    final studentFirstNameField = TextFormField(
      autofocus: false,
      validator: (value) => value.isEmpty ? 'This is a mandatory field' : null,
      onSaved: (value) => _studentFirstName = value,
      decoration: buildInputDecoration('First name'),
    );

    final studentLastNameField = TextFormField(
      autofocus: false,
      validator: (value) => value.isEmpty ? 'This is a mandatory field' : null,
      onSaved: (value) => _studentLastName = value,
      decoration: buildInputDecoration('Last name'),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        Text('Registering..'),
      ],
    );

    var doRegistration = () async {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        await auth.register(
            _studentFirstName, _studentLastName, _studentNumber);
        Navigator.pushReplacementNamed(context, HomeScreen.route);
      }
    };

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xffffffff),
          title: Text(
            'Create student account',
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
                  children: [
                    auth.registeredInStatus == Status.NotRegistered
                        ? infoCallout(
                            'Please use your unique student number, e.g: r0123456')
                        : Container(),
                    SizedBox(height: 32.0),
                    studentNumberField,
                    SizedBox(height: 16.0),
                    studentFirstNameField,
                    SizedBox(height: 16.0),
                    studentLastNameField,
                    SizedBox(height: 32.0),
                    auth.registeredInStatus == Status.Registering
                        ? loading
                        : primaryButton('Register now', doRegistration),
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
