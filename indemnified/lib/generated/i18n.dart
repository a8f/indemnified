// DO NOT EDIT. This is code generated via package:gen_lang/generate.dart

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'messages_all.dart';

class S {
 
  static const GeneratedLocalizationsDelegate delegate = GeneratedLocalizationsDelegate();

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }
  
  static Future<S> load(Locale locale) {
    final String name = locale.countryCode == null ? locale.languageCode : locale.toString();

    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new S();
    });
  }
  
  String get appTitle {
    return Intl.message("Indemnified", name: 'appTitle');
  }

  String get searchAppBarTitle {
    return Intl.message("This is a simple Message", name: 'searchAppBarTitle');
  }

  String get noResults {
    return Intl.message("No matching models", name: 'noResults');
  }

  String get manufacturer {
    return Intl.message("Manufacturer", name: 'manufacturer');
  }

  String get type {
    return Intl.message("Type", name: 'type');
  }

  String get fetchBindingsTitle {
    return Intl.message("Update Bindings List", name: 'fetchBindingsTitle');
  }

  String get connectionError {
    return Intl.message("Error connecting to the internet", name: 'connectionError');
  }

  String get searchHint {
    return Intl.message("Search...", name: 'searchHint');
  }

  String get updating {
    return Intl.message("Updating indemnified binding list", name: 'updating');
  }

  String get legalWarning1 {
    return Intl.message("The software is provided \"as is\", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.", name: 'legalWarning1');
  }

  String legalWarning2(acceptText) {
    return Intl.message("This list of bindings is incomplete and not definitive. Although we try our best to make sure all data is up to date, a model appearing on this list does not mean it is indemnified. By pressing \"${acceptText}\" below, you agree that the app developers shall not be held liable in the event that a listed binding is not indemnified. Check with the manufacturer for every binding to ensure it is indemnified before servicing.", name: 'legalWarning2', args: [acceptText]);
  }

  String get accept {
    return Intl.message("Ok", name: 'accept');
  }

  String get warningTitle {
    return Intl.message("Warning", name: 'warningTitle');
  }


}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<S> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
			Locale("en", ""),

    ];
  }

  LocaleListResolutionCallback listResolution({Locale fallback}) {
    return (List<Locale> locales, Iterable<Locale> supported) {
      if (locales == null || locales.isEmpty) {
        return fallback ?? supported.first;
      } else {
        return _resolve(locales.first, fallback, supported);
      }
    };
  }

  LocaleResolutionCallback resolution({Locale fallback}) {
    return (Locale locale, Iterable<Locale> supported) {
      return _resolve(locale, fallback, supported);
    };
  }

  Locale _resolve(Locale locale, Locale fallback, Iterable<Locale> supported) {
    if (locale == null || !isSupported(locale)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  @override
  Future<S> load(Locale locale) {
    return S.load(locale);
  }

  @override
  bool isSupported(Locale locale) =>
    locale != null && supportedLocales.contains(locale);

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => false;
}
