import 'dart:convert';
import 'dart:io';

import 'package:testapp/baseapiresponse.dart';
import 'package:testapp/exceptiond.dart';
import 'package:http/http.dart' as https;

class NetworkService extends BaseApiResponse {
  @override
  Future getApiRespinse(String url) async {
    dynamic responseJson;
    try {
      final response =
          await https.get(Uri.parse(url)).timeout(const Duration(seconds: 3));
      responseJson = jsonResponseError(response);
    } on SocketException {
      throw FetchException('No Internet');
    }
    return responseJson;
  }

  @override
  Future getPostResponse(String url, dynamic data) async {
    try {
      final response = await https
          .post(Uri.parse(url), body: data)
          .timeout(const Duration(seconds: 10));
    } on SocketException {
      throw FetchException('No Internet');
    }
  }

  dynamic jsonResponseError(https.Response response) {
    switch (response) {
      case 200:
        {
          dynamic jsonres = jsonDecode(response.body);
          return jsonres;
        }
      case 400:
        {
          throw BadRequestException('Bad Response');
        }
      default:
        {
          throw FetchException('Error accured');
        }
    }
  }
}
