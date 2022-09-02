import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier {
  String _name = 'Flutter';
  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }
}
