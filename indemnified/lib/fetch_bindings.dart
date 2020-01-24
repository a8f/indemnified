import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'generated/i18n.dart';
import 'dart:convert';
import 'binding.dart';

class FetchBindings extends StatefulWidget {
  @override
  _FetchBindingState createState() => _FetchBindingState();
}

class _FetchBindingState extends State<FetchBindings> {
  bool loginLoading = false, noServerConnection = false, loginError = false;
  bool connectionError = false;
  bool savedLoginTried = false;
  Future<Map<String, dynamic>> _bindingsJson;

  Future<Map<String, dynamic>> fetchBindings() async {
    final response = await http
        .get('https://gist.github.com/a8f/28330e4afb9d56ec18e96262739c57a5.js');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      connectionError = true;
    }
  }

  void initState() {
    super.initState();
    _bindingsJson = fetchBindings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).fetchBindingsTitle)),
    );
  }

  @override
  Widget _mainWindow(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).fetchBindingsTitle)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Visibility(
                    visible: loginLoading,
                    child: SpinKitRing(color: Theme.of(context).accentColor)))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Visibility(
                    visible: connectionError,
                    child: Text(S.of(context).connectionError)))
          ]),
        ],
      ),
    );
  }
}
