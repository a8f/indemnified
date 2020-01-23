import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'generated/i18n.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'util.dart';
import 'binding.dart';

class Search extends StatefulWidget implements AppBarPageBase {
  _SearchState createState() => _SearchState();

  @override
  AppBar getAppBar(BuildContext context) =>
      new AppBar(title: Text(S.of(context).searchAppBarTitle));
}

class _SearchState extends State<Search> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  bool _loading = true;
  List<Binding> _allBindings = [];
  List<Binding> _results = [];
  String _selectedManufacturer, _selectedType;
  List<String> _manufacturers = [];
  List<String> _types;
  Map<String, List<String>> _manufacturerTypes = {};

  @override
  initState() {
    super.initState();
  }

  void init(BuildContext buildContext) {
    final future = _loadBindingsFile();
    future.then((String bindings) {
      Map<String, Map<String, bool>> manTypes = {};
      List<dynamic> bindingsJson = json.decode(bindings)["bindings"];
      _allBindings = bindingsJson.map((b) => Binding.fromJson(b)).toList();
      _allBindings.forEach((b) {
        _manufacturers.add(b.manufacturer);
        if (manTypes.containsKey(b.manufacturer)) {
          manTypes[b.manufacturer][b.type] = true;
        } else {
          manTypes[b.manufacturer] = {b.type: true};
        }
      });
      manTypes.keys.forEach((manufacturer) {
        _manufacturerTypes[manufacturer] = manTypes[manufacturer].keys.toList();
      });
      setState(() {
        _results = _allBindings;
        _loading = false;
      });
    });
  }

  Future<String> _loadBindingsFile() async {
    String bindings =
        await DefaultAssetBundle.of(context).loadString("res/bindings.json");
    return bindings;
  }

  List<DropdownMenuItem<String>> _manufacturerDropdownMenuItems(
      BuildContext context) {
    return _manufacturers
        .map((m) => DropdownMenuItem<String>(value: m, child: Text(m)))
        .toList();
  }

  List<DropdownMenuItem<String>> _typeDropdownMenuItems() {
    List<DropdownMenuItem<String>> types;
    return types;
  }

  Widget _resultsListView(BuildContext context) {
    if (_results.length == 0) {
      if (_loading) {
        return Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Visibility(
                visible: _loading,
                child: SpinKitRing(color: Theme.of(context).accentColor)));
      }
      return Center(
          child: Text(
        S.of(context).noResults,
        style: Theme.of(context).primaryTextTheme.display1,
      ));
    }
    return ListView.separated(
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: _results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_results[index].name(),
              style: Theme.of(context).primaryTextTheme.body1),
          subtitle: Text(_results[index].manufacturer,
              style: Theme.of(context).primaryTextTheme.body2),
          /*onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RideInfo(ride: _rides[index])));
          },*/
        );
      },
      separatorBuilder: (context, index) => Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Column(children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: Card(
                              color: Theme.of(context).cardColor,
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          DropdownButton<String>(
                                              value: _selectedManufacturer,
                                              onChanged: (String s) {
                                                setState(() {
                                                  _selectedManufacturer = s;
                                                });
                                              },
                                              isExpanded: false,
                                              items:
                                                  _manufacturerDropdownMenuItems(
                                                      context),
                                              hint: Text(
                                                  S.of(context).manufacturer)),
                                          DropdownButton<String>(
                                              value: _selectedType,
                                              onChanged: (String s) {
                                                setState(() {
                                                  _selectedType = s;
                                                });
                                              },
                                              isExpanded: false,
                                              items:
                                                  _manufacturerDropdownMenuItems(
                                                      context),
                                              hint: Text(S.of(context).type)),
                                        ],
                                      ),
                                    ],
                                  )))),
                    ],
                  )),
              Row(
                children: <Widget>[Expanded(child: _resultsListView(context))],
              )
            ])));
  }
}
