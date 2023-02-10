import 'package:flutter/material.dart';

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(fontSize: 14),
    ),
    backgroundColor: color,
    duration: const Duration(seconds: 3),
    action: SnackBarAction(
      label: 'ok',
      onPressed: () => null,
      textColor: Colors.white,
    ),
  ));
}

void navigate(BuildContext context, Widget d) {
  Navigator.push(context, MaterialPageRoute(builder: ((context) => d)));
  void pop(context) => Navigator.pop(context);
}

void replace(BuildContext context, Widget d) {
  Navigator.push(context, MaterialPageRoute(builder: ((context) => d)));
  void pop(context) => Navigator.pop(context);
}
