import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:newst/core/network/api_exception.dart';

class ApiService {
  Future<dynamic> get(Uri url) async {
    try {
      final response = await http.get(url);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      }

      throw ApiException(
        message: 'Request failed',
        statusCode: response.statusCode,
      );
    } on SocketException {
      throw ApiException(message: 'No internet connection');
    } on FormatException {
      throw ApiException(message: 'Invalid response format');
    } catch (e) {
      throw ApiException(message: 'Something went wrong');
    }
  }
}
