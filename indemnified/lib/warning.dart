import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fetch_bindings.dart';
import 'generated/i18n.dart';

class Warning extends StatelessWidget {
  SharedPreferences prefs;

  Future<bool> _getAccepted() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.get('accepted') ?? false;
  }

  void _accept(BuildContext context) {
    prefs.setBool('accepted', true);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => FetchBindings()));
  }

  @override
  Widget build(BuildContext context) {
    _getAccepted().then((bool _accepted) {
      if (_accepted) {
        _accept(context);
        return SafeArea(child: Container());
      } else {
        return SafeArea(
            child: Scaffold(
                body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(S.of(context).warningTitle,
                textScaleFactor: 1.5,
                style: Theme.of(context).textTheme.headline),
            Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Text(
                    S.of(context).legalWarning1 +
                        '\n\n' +
                        S.of(context).legalWarning2(S.of(context).accept) +
                        '\n\n',
                    style: Theme.of(context).textTheme.body1)),
            MaterialButton(
              child: Text(S.of(context).accept),
              color: Theme.of(context).buttonColor,
              onPressed: () => _accept(context),
            )
          ],
        )));
      }
    });
    return SafeArea(child: Container());
  }
}
