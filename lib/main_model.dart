import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier {
  String popouniText = 'ぽぽうに';

  void changePopouniText() {
    popouniText = 'ぽぽうには犬';
    notifyListeners();
  }
}
