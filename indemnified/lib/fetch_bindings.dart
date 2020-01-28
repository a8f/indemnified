import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'generated/i18n.dart';
import 'search.dart';

String _downloadUrl = 'https://pastebin.com/raw/6XEJAGqH';

class FetchBindings extends StatefulWidget {
  @override
  _FetchBindingState createState() => _FetchBindingState();
}

class _FetchBindingState extends State<FetchBindings> {
  bool loginLoading = false, noServerConnection = false, loginError = false;
  bool connectionError = false;
  bool savedLoginTried = false;
  Duration updateFreq = Duration(days: 10); // TODO allow setting this
  Map<String, dynamic> _bindingsJson;

  /// Returns true iff a new list should be downloaded from the server
  /// If false is returned then _bindingsJson is set
  Future<bool> shouldFetchNewList() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    File file = File('$path/indemnified.json');
    String contents;
    try {
      contents = await file.readAsString();
    } catch (FileSystemException) {
      await file.create();
      return true;
    }
    Map<String, dynamic> fileJson;
    try {
      fileJson = json.decode(contents);
    } catch (FormatException) {
      return true;
    }
    if (!fileJson.containsKey('downloadDate') ||
        !fileJson.containsKey('bindings')) {
      return true;
    }
    DateTime downloadDate;
    try {
      downloadDate = DateTime.parse(fileJson['downloadDate']);
    } catch (FormatException) {
      return true;
    }
    DateTime now = DateTime.now();
    return now.difference(downloadDate) > updateFreq;
  }

  Future<void> fetchBindings() async {
    if (!(await shouldFetchNewList())) {
      return _bindingsJson;
    }
    final response = await http.get(_downloadUrl);
    if (response.statusCode == 200) {
      Map<String, dynamic> bindingsJson = json.decode(response.body);
      bindingsJson["downloadDate"] = DateTime.now();
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      File file = File('$path/indemnified.json');
      file.writeAsString(bindingsJson.toString());
      _bindingsJson = bindingsJson;
    } else {
      connectionError = true;
      _bindingsJson = null;
    }
  }

  void initState() {
    super.initState();
    fetchBindings().then((_) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Search(_bindingsJson)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).fetchBindingsTitle)),
      body: _mainWindow(context),
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
