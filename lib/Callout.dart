import 'package:flutter/material.dart';

Container errorCallout(String title) {
  return Container(
    width: double.infinity,
    color: Color(0xffffcccc),
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(
            Icons.error,
            color: Color(0xffff0000),
          ),
          SizedBox(width: 16.0),
          Flexible(
            child: Container(
              child: Text(
                title,
                style: TextStyle(
                    color: Color(0xffff0000), fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Container infoCallout(String title) {
  return Container(
    width: double.infinity,
    color: Color(0xffcce6ff),
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(
            Icons.info,
            color: Color(0xff3399ff),
          ),
          SizedBox(width: 16.0),
          Flexible(
            child: Container(
              child: Text(
                title,
                style: TextStyle(
                    color: Color(0xff3399ff), fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}