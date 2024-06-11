import 'package:flutter/foundation.dart';

class CountProvider with ChangeNotifier {
  List<int> selectItem = [];
  List<int> get selectedItems => selectItem;

  void setCount(int value) {
    selectItem.add(value);
    notifyListeners();
  }

  void setRemove(int values) {
    selectItem.remove(values);
    notifyListeners();
  }
}
