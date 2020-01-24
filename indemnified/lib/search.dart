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
  final TextEditingController _searchController = TextEditingController();
  bool _loading = true;
  List<Binding> _allBindings = [];
  List<Binding> _results = [];
  String _selectedManufacturer, _selectedType;
  List<String> _manufacturers;
  Map<String, List<String>> _manTypes;
  List<String> _types;
  int _maxTypeLength = 0,
      _maxManLength = 0;
  String _searchTerm = '';

  @override
  initState() {
    super.initState();
    init();
  }

  void init() async {
    _loadBindingsFile().then((String bindings) {
      // Load data from json
      Map<String, Map<String, bool>> manTypes = {};
      Set<String> newManufacturers = new Set<String>();
      Set<String> newTypes = new Set<String>();
      List<dynamic> bindingsJson = json.decode(bindings)["bindings"];
      _allBindings = bindingsJson.map((b) => Binding.fromJson(b)).toList();
      _allBindings.forEach((b) {
        newManufacturers.add(b.manufacturer);
        if (b.manufacturer.length > _maxManLength)
          _maxManLength = b.manufacturer.length;
        newTypes.add(b.type);
        if (b.type != null) {
          if (b.type.length > _maxTypeLength) _maxTypeLength = b.type.length;
          if (manTypes.containsKey(b.manufacturer)) {
            manTypes[b.manufacturer][b.type] = true;
          } else {
            manTypes[b.manufacturer] = new Map<String, bool>();
            manTypes[b.manufacturer][b.type] = true;
          }
        }
      });

      Map<String, List<String>> newManTypes = {};
      manTypes.forEach((k, v) {
        newManTypes[k] = v.keys.toList();
        newManTypes[k].sort();
      });
      // Initialize the class variables
      _manufacturers = newManufacturers.toList();
      _manufacturers.sort();
      debugPrint(newTypes.toString());
      newTypes.remove(null);
      _types = newTypes.toList();
      _types.sort();
      _manTypes = newManTypes;
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

  List<DropdownMenuItem<String>> _manufacturerDropdownMenuItems() {
    return _manufacturers
        .map((m) => DropdownMenuItem<String>(value: m, child: Text(m)))
        .toList();
  }

  List<DropdownMenuItem<String>> _typeDropdownMenuItems() {
    if (_selectedManufacturer == null || _selectedManufacturer.isEmpty) {
      return _types
          .map((m) => DropdownMenuItem<String>(value: m, child: Text(m)))
          .toList();
    }
    if (!_manTypes.containsKey(_selectedManufacturer)) {
      return new List<DropdownMenuItem<String>>();
    }
    return _manTypes[_selectedManufacturer]
        .map((m) => DropdownMenuItem<String>(value: m, child: Text(m)))
        .toList();
  }

  void _filter() {
    List<Binding> bindings = _allBindings;
    _results = bindings.where((b) {
      if (_searchTerm != null && _searchTerm.isNotEmpty) {
        if (!b.name().toLowerCase().contains(_searchTerm) &&
            !b.manufacturer.toLowerCase().contains(_searchTerm)) return false;
      }
      if (_selectedManufacturer == null) {
        return _selectedType == null || _selectedType == b.type;
      }
      if (_selectedManufacturer != b.manufacturer) return false;
      if (_selectedType == null) return true;
      return _selectedType == b.type;
    }).toList();
    _scrollController.jumpTo(0);
  }

  Widget _searchBox(BuildContext context) {
    if (_loading) {
      return Padding(padding: EdgeInsets.only(top: 10.0));
    }
    debugPrint(_maxTypeLength.toString());
    String typeHint = S
        .of(context)
        .type;
    typeHint += ' ' * (_maxTypeLength - typeHint.length);
    String manHint = S
        .of(context)
        .manufacturer;
    manHint += ' ' * (_maxManLength - manHint.length);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: Card(
                color: Theme
                    .of(context)
                    .cardColor,
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            DropdownButton<String>(
                                value: _selectedManufacturer,
                                onChanged: (String s) {
                                  setState(() {
                                    if (_manTypes[s] == null ||
                                        !(_manTypes[s]
                                            .contains(_selectedType))) {
                                      _selectedType = null;
                                    }
                                    _selectedManufacturer = s;
                                  });
                                  _filter();
                                },
                                isExpanded: false,
                                items: _manufacturerDropdownMenuItems(),
                                hint: Text(manHint)),
                            DropdownButton<String>(
                                value: _selectedType,
                                onChanged: (String s) {
                                  setState(() {
                                    _selectedType = s;
                                  });
                                  _filter();
                                },
                                isExpanded: false,
                                items: _typeDropdownMenuItems(),
                                hint: Text(typeHint)),
                            MaterialButton(
                              color: Color(1),
                              child: Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _selectedType = null;
                                  _selectedManufacturer = null;
                                  _searchTerm = '';
                                });
                                _filter();
                              },
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration:
                                  InputDecoration(icon: Icon(Icons.search)),
                                  style: TextStyle(color: Colors.black),
                                  textInputAction: TextInputAction.search,
                                  onChanged: (s) {
                                    setState(() {
                                      _searchTerm = s;
                                    });
                                    _filter();
                                  },
                                ))
                          ],
                        )
                      ],
                    )))),
      ],
    );
  }

  Widget _resultsListView(BuildContext context) {
    if (_loading) {
      return Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Visibility(
              visible: _loading,
              child: SpinKitRing(color: Theme
                  .of(context)
                  .accentColor)));
    }
    if (_results.length == 0) {
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
          dense: true,
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
    return SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Column(children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: _searchBox(context)),
              Expanded(child: _resultsListView(context))
            ])));
  }
}
