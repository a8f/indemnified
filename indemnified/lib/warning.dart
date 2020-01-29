import 'package:flutter/material.dart';

class Warning extends StatelessWidget {
  String _warning;

  Warning(String warning) {
    _warning = warning;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(child: Text(_warning)),
    ));
  }
}
