import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String hintText) {
  return InputDecoration(
    //prefixIcon: Icon(icon, color: Colors.grey),
    labelText: hintText,
    labelStyle: TextStyle(color: Color(0xff000000)),
    contentPadding: EdgeInsets.all(8.0),
    filled: true,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xff00629a), width: 2.0)
    )
  );
}