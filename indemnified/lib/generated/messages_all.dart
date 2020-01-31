// DO NOT EDIT. This is code generated via package:gen_lang/generate.dart

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
// ignore: implementation_imports
import 'package:intl/src/intl_helpers.dart';

final _$en = $en();

class $en extends MessageLookupByLibrary {
  get localeName => 'en';
  
  final messages = {
		"appTitle" : MessageLookupByLibrary.simpleMessage("Indemnified"),
		"searchAppBarTitle" : MessageLookupByLibrary.simpleMessage("This is a simple Message"),
		"noResults" : MessageLookupByLibrary.simpleMessage("No matching models"),
		"manufacturer" : MessageLookupByLibrary.simpleMessage("Manufacturer"),
		"type" : MessageLookupByLibrary.simpleMessage("Type"),
		"fetchBindingsTitle" : MessageLookupByLibrary.simpleMessage("Update Bindings List"),
		"connectionError" : MessageLookupByLibrary.simpleMessage("Error connecting to the internet"),
		"searchHint" : MessageLookupByLibrary.simpleMessage("Search..."),
		"updating" : MessageLookupByLibrary.simpleMessage("Updating indemnified binding list"),
		"legalWarning1" : MessageLookupByLibrary.simpleMessage("The software is provided \"as is\", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software."),
		"legalWarning2" : (acceptText) => "This list of bindings is incomplete and not definitive. Although we try our best to make sure all data is up to date, a model appearing on this list does not mean it is indemnified. By pressing \"${acceptText}\" below, you agree that the app developers shall not be held liable in the event that a listed binding is not indemnified. Check with the manufacturer for every binding to ensure it is indemnified before servicing.",
		"accept" : MessageLookupByLibrary.simpleMessage("Ok"),
		"warningTitle" : MessageLookupByLibrary.simpleMessage("Warning"),

  };
}



typedef Future<dynamic> LibraryLoader();
Map<String, LibraryLoader> _deferredLibraries = {
	"en": () => Future.value(null),

};

MessageLookupByLibrary _findExact(localeName) {
  switch (localeName) {
    case "en":
        return _$en;

    default:
      return null;
  }
}

/// User programs should call this before using [localeName] for messages.
Future<bool> initializeMessages(String localeName) async {
  var availableLocale = Intl.verifiedLocale(
      localeName,
          (locale) => _deferredLibraries[locale] != null,
      onFailure: (_) => null);
  if (availableLocale == null) {
    return Future.value(false);
  }
  var lib = _deferredLibraries[availableLocale];
  await (lib == null ? Future.value(false) : lib());

  initializeInternalMessageLookup(() => CompositeMessageLookup());
  messageLookup.addLocale(availableLocale, _findGeneratedMessagesFor);

  return Future.value(true);
}

bool _messagesExistFor(String locale) {
  try {
    return _findExact(locale) != null;
  } catch (e) {
    return false;
  }
}

MessageLookupByLibrary _findGeneratedMessagesFor(locale) {
  var actualLocale = Intl.verifiedLocale(locale, _messagesExistFor,
      onFailure: (_) => null);
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}
