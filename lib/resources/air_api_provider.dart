import 'package:flutter_dust/models/air_result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class AirApiProvider {
  final _apiKey = '19858f4f-0b57-4859-8108-55dce347bca1';
  final _baseUrl = 'api.airvisual.com';
  final _baseUrlPath = '/v2/nearest_city';

  Future<AirResult> fetchAirResult() async {
    var url = Uri.http(_baseUrl, _baseUrlPath, {'key' : _apiKey});
    var response = await http.get(url);

    if (response.statusCode != 200) {
      throw StateError('network error status code : ${response.statusCode}');
    }

    var json = convert.jsonDecode(response.body);
    return AirResult.fromJson(json);
  }
}