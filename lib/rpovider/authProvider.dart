import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AuthProvider with ChangeNotifier {
  bool loading = false;
  bool get _loading => loading;
  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void login(String email, String password) async {
    setLoading(true);
    try {
      Response response = await post(Uri.parse('https://reqres.in/api/login'),
          body: {'email': email, 'password': password});
      if (response.statusCode == 200) {
        print('succefull');
        setLoading(false);
      } else {
        print('failed');
        setLoading(false);
      }
    } catch (e) {
      setLoading(false);
      print(e.toString());
    }
  }
}
