import 'package:flutter/cupertino.dart';

class CommonText {
  String? text;
  CommonText(this.text);
}

class ProviderText extends ChangeNotifier {
  List<CommonText> textList = [];

  void addText(String text) {
    textList.add(CommonText(text));
    notifyListeners();
  }
}
