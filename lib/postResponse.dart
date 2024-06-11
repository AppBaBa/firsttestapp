import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:testapp/post.dart';

class Postonse {
  Future<List<Post>?> getPost() async {
    var clint = http.Client();
    var uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    var response = await clint.get(uri);
    if (response.statusCode == 200) {
      var jsonResponse = response.body;
      return postFromJson(jsonResponse);
    } else {
      if (kDebugMode) {
        print("Show Error");
      }
    }
    return null;
  }
}
