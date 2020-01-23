import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'generated/i18n.dart';
import 'theme.dart';
import 'search.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: S().appTitle,
      home: Search(),
      theme: theme,
      localizationsDelegates: [
        S.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
