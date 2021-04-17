import 'package:flutter/material.dart';

MaterialButton primaryButton(String title, Function fun,
    {Color color: const Color(0xff00629a),
    Color textColor: const Color(0xffffffff)}) {
  return MaterialButton(
    onPressed: fun,
    textColor: textColor,
    color: color,
    child: SizedBox(
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    ),
    height: 48.0,
    minWidth: 600,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
  );
}

Container secondaryButton(String title, Function fun,
    {Color color: const Color(0xff00629a),
    Color textColor: const Color(0xff00629a)}) {
  return Container(
    height: 48.0,
    width: double.infinity,
    child: OutlineButton(
      onPressed: fun,
      textColor: textColor,
      borderSide: BorderSide(color: color),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
    ),
  );
}

FlatButton tertiaryButton(String title, Function fun,
    {Color textColor: const Color(0xff00629a)}) {
  return FlatButton(
    onPressed: fun,
    textColor: textColor,
    child: SizedBox(
      width: double.infinity,
      child: Text(title, textAlign: TextAlign.center),
    ),
  );
}

IconButton iconButton(IconData icon, Function fun, double size,
    {Color color: const Color(0xff00629a)}) {
  return IconButton(
    onPressed: fun,
    icon: Icon(
      icon,
      color: color,
      size: size,
    ),
  );
}
