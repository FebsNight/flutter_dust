// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_dust/models/air_result.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_dust/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


void main() {
  test('http 통신 테스트', () async {
    var url = Uri.http('api.airvisual.com', '/v2/nearest_city', {'key' : '19858f4f-0b57-4859-8108-55dce347bca1'});
    var response = await http.get(url);

    // expect(response.statusCode, 200);
    
    AirResult result = AirResult.fromJson(convert.jsonDecode(response.body));
    expect(result.status, 'success');
  });
}
