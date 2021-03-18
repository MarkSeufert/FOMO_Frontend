import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import '../exception/custom_exception.dart';
import 'package:flutter_config/flutter_config.dart';

class ApiProvider {
  final String _baseUrl = FlutterConfig.get('API_URL');

  Future<dynamic> get(String url,
      [Map<String, dynamic> queryParameters]) async {
    var responseJson;
    try {
      final response =
          await http.get(Uri.https(_baseUrl, "/api/" + url, queryParameters));
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url,
      [Map<String, dynamic> queryParameters]) async {
    var responseJson;
    try {
      final response = await http.post(Uri.https(_baseUrl, "/api/" + url),
          body: queryParameters);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
